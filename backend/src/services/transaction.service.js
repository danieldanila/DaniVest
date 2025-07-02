import NotFoundError from "../errors/notFoundError.js";
import { BankAccount, Transaction, User } from "../models/index.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import transactionValidation from "../validations/transaction.validation.js";
import bankAccountService from "./bankAccount.service.js";

const service = {
    createTransaction: async (transactionBody) => {
        const existingTransactions = await service.getAllTransactions();
        const existingBankAccounts = await bankAccountService.getAllBankAccounts();
        const errors = await transactionValidation.checkTransactionsFields(
            transactionBody,
            existingTransactions,
            existingBankAccounts,
            false
        );

        const senderBankAccount = await bankAccountService.getBankAccountById(transactionBody.senderBankAccountId);
        const receiverBankAccount = await bankAccountService.getBankAccountById(transactionBody.receiverBankAccountId);

        let senderAmount = parseFloat(senderBankAccount.amount);
        let receiverAmount = parseFloat(receiverBankAccount.amount)
        const transactionAmount = parseFloat(transactionBody.amount);

        if (senderAmount >= transactionAmount) {
            senderAmount -= transactionAmount;
            receiverAmount += transactionAmount;

            senderBankAccount.amount = senderAmount;
            receiverBankAccount.amount = receiverAmount;
            await senderBankAccount.save();
            await receiverBankAccount.save();
        } else {
            errors.push("Insufficient funds.");
        }

        if (errors.length === 0) {
            const newTransaction = await Transaction.create(transactionBody);

            return newTransaction;
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    createMultipleTransactions: async (arrayOfTransactionBodies) => {
        for (const transactionBody of arrayOfTransactionBodies) {
            await service.createTransaction(transactionBody);
        }
    },

    getAllTransactions: async () => {
        const transactions = await Transaction.findAll({
            include: [
                {
                    model: BankAccount,
                    as: "sender",
                    include: [
                        {
                            model: User
                        }
                    ]
                },
                {
                    model: BankAccount,
                    as: "receiver",
                    include: [
                        {
                            model: User
                        }
                    ]
                }
            ]
        });
        return transactions;
    },

    getTransactionById: async (transactionId) => {
        const errors = [];

        validation.idParamaterValidation(transactionId, "Transaction id", errors);

        const transaction = await Transaction.findByPk(transactionId);

        if (transaction) {
            return transaction;
        } else {
            throw new NotFoundError("Transaction not found.");
        }
    },
};

export default service;
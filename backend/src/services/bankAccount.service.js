import NotFoundError from "../errors/notFoundError.js";
import { BankAccount } from "../models/index.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import bankAccountValidation from "../validations/bankAccount.validation.js";
import userService from "./user.service.js";

const service = {
    createBankAccount: async (bankAccountBody) => {
        const existingBankAccounts = await service.getAllBankAccounts();
        const existingUsers = await userService.getAllUsers();
        const errors = await bankAccountValidation.checkBankAccountFields(
            bankAccountBody,
            existingBankAccounts,
            existingUsers,
            false
        );

        if (errors.length === 0) {
            const newBankAccount = await BankAccount.create(bankAccountBody);

            return newBankAccount;
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    getAllBankAccounts: async () => {
        const bankAccounts = await BankAccount.findAll();
        return bankAccounts;
    },

    getBankAccountById: async (bankAccountId) => {
        const errors = [];

        validation.idParamaterValidation(bankAccountId, "BankAccount id", errors);

        const bankAccount = await BankAccount.findByPk(bankAccountId);

        if (bankAccount) {
            return bankAccount;
        } else {
            throw new NotFoundError("BankAccount not found.");
        }
    },
};

export default service;
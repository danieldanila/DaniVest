import { TransactionService as transactionService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createTransaction: catchAsync(async (req, res, next) => {
        const newTransaction = await transactionService.createTransaction(req.body);

        res.status(201).json({ message: `Transaction with details '${newTransaction.details}' created.` })

    }),

    createMultipleTransactions: catchAsync(async (req, res, next) => {
        await transactionService.createMultipleTransactions(req.body);
        res.status(201).json({
            message: `${req.body.length} transactions created.`,
        });
    }),


    getAllTransactions: catchAsync(async (req, res, next) => {
        const transactions = await transactionService.getAllTransactions();
        res.status(200).json(transactions);
    }),

    getTransactionById: catchAsync(async (req, res, next) => {
        const transaction = await transactionService.getTransactionById(req.params.id);
        res.status(200).json(transaction);
    }),
}

export default controller;
import { BankAccountService as bankAccountService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createBankAccount: catchAsync(async (req, res, next) => {
        const newBankAccount = await bankAccountService.createBankAccount(req.body);

        res.status(201).json({ message: `BankAccount '${newBankAccount.iban}' created.` })

    }),

    createMultipleBankAccounts: catchAsync(async (req, res, next) => {
        await bankAccountService.createMultipleBankAccounts(req.body);
        res.status(201).json({
            message: `${req.body.length} bank accounts created.`,
        });
    }),

    getAllBankAccounts: catchAsync(async (req, res, next) => {
        const bankAccounts = await bankAccountService.getAllBankAccounts();
        res.status(200).json(bankAccounts);
    }),

    getBankAccountById: catchAsync(async (req, res, next) => {
        const bankAccount = await bankAccountService.getBankAccountById(req.params.id);
        res.status(200).json(bankAccount);
    }),
}

export default controller;
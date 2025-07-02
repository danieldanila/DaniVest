import { UserService as userService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createUser: catchAsync(async (req, res, next) => {
        const { newUser, newBankAccount } = await userService.createUser(req.body);

        res.status(201).json({ message: `User '${newUser.username}' created alongside with his main bank account's IBAN ${newBankAccount.iban}.` })
    }),

    createMultipleUsers: catchAsync(async (req, res, next) => {
        await userService.createMultipleUsers(req.body);
        res.status(201).json({
            message: `${req.body.length} users created.`,
        });
    }),

    getAllUsers: catchAsync(async (req, res, next) => {
        const users = await userService.getAllUsers();
        res.status(200).json(users);
    }),

    getUserById: catchAsync(async (req, res, next) => {
        const user = await userService.getUserById(req.params.id);
        res.status(200).json(user);
    }),

    getUserBankAccount: catchAsync(async (req, res, next) => {
        const bankAccount = await userService.getUserBankAccount(req.params.id);
        res.status(200).json(bankAccount);
    }),

    getUserOtherBankAccount: catchAsync(async (req, res, next) => {
        const bankAccount = await userService.getUserOtherBankAccount(req.params.id);
        res.status(200).json(bankAccount);
    }),

    getUserOtherBankAccountByCardDetails: catchAsync(async (req, res, next) => {
        const bankAccount = await userService.getUserOtherBankAccountByCardDetails(req.params.id, req.params.cardNumber, req.params.expiryDate, req.params.cvv);
        res.status(200).json({ message: `Bank account with IBAN: ${bankAccount.iban} updated as other account.`, data: bankAccount });
    }),

    getUserAllTransactions: catchAsync(async (req, res, next) => {
        const transactions = await userService.getUserAllTransactions(req.params.id);
        res.status(200).json(transactions);
    }),
}

export default controller;
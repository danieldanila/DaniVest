import NotFoundError from "../errors/notFoundError.js";
import { BankAccount, Transaction, User } from "../models/index.js";
import { generateRandomCardNumber, generateRandomCVV, generateRandomRomanianIBAN } from "../utils/bank.util.js";
import { getDateXYearsFromNow } from "../utils/date.util.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import userValidation from "../validations/user.validation.js";
import { BankAccountService as bankAccountService } from "./index.js";

const service = {
    createUser: async (userBody) => {
        const existingUsers = await service.getAllUsers();
        const errors = await userValidation.checkUserFields(
            userBody,
            existingUsers,
            false
        );

        if (errors.length === 0) {
            const newUser = await User.create(userBody);

            const bankAccountBody = {
                "amount": "0.00",
                "iban": generateRandomRomanianIBAN(),
                "cardNumber": generateRandomCardNumber(),
                "expiryDate": getDateXYearsFromNow(5),
                "cvv": generateRandomCVV(),
                "isMain": "true",
                "userId": newUser.id
            }
            const newBankAccount = await bankAccountService.createBankAccount(bankAccountBody)

            return { newUser, newBankAccount };
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    createMultipleUsers: async (arrayOfUserBodies) => {
        for (const userBody of arrayOfUserBodies) {
            await service.createUser(userBody);
        }
    },

    getAllUsers: async () => {
        const users = await User.scope("withPassword").findAll();
        return users;
    },

    getUserById: async (userId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);

        const user = await User.findByPk(userId);

        if (user) {
            return user;
        } else {
            throw new NotFoundError("User not found.");
        }
    },

    getUserBankAccount: async (userId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);

        const bankAccount = await BankAccount.findOne({
            where: {
                userId: userId,
                isMain: true
            }
        })

        if (bankAccount) {
            return bankAccount;
        } else {
            throw new NotFoundError("User has no main bank account.");
        }
    },

    getUserOtherBankAccount: async (userId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);

        const bankAccount = await BankAccount.findOne({
            where: {
                userId: userId,
                isMain: false
            }
        })

        if (bankAccount) {
            return bankAccount;
        } else {
            throw new NotFoundError("User has no other bank account.");
        }
    },

    getUserAllTransactions: async (userId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);

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
            ],
            where: {
                '$sender.User.id$': userId
            }
        })

        if (transactions) {
            return transactions;
        } else {
            throw new NotFoundError("User has no transactions.");
        }
    },


};

export default service;
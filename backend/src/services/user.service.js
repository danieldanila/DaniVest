import { Op } from "sequelize";
import AppError from "../errors/appError.js";
import NotFoundError from "../errors/notFoundError.js";
import { BankAccount, Transaction, User } from "../models/index.js";
import { generateRandomCardNumber, generateRandomCVV, generateRandomRomanianIBAN } from "../utils/bank.util.js";
import { getDateXYearsFromNow } from "../utils/date.util.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import userValidation from "../validations/user.validation.js";
import { BankAccountService as bankAccountService } from "./index.js";

const filterObject = (object, ...allowedFields) => {
    const newObject = {};
    Object.keys(object).forEach((element) => {
        if (allowedFields.includes(element)) {
            newObject[element] = object[element];
        }
    });
    return newObject;
};

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

    updateUser: async (userId, userBody) => {
        const existingUsers = await service.getAllUsers();
        const errors = await userValidation.checkUserFields(
            userBody,
            existingUsers,
            true
        );

        if (errors.length === 0) {
            const userFound = await service.getUserById(userId);

            const updatedUser = await userFound.update(userBody);
            return updatedUser;
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    updateMe: async (loggedUser, userBody) => {
        if (userBody.password) {
            throw new AppError(
                "You can't updated your password here. Please use the update password method.",
                400
            );
        }

        const filteredBody = filterObject(
            userBody,
            "email",
            "phoneNumber",
            "firstName",
            "lastName",
        );
        const updatedUser = await service.updateUser(loggedUser.id, filteredBody);

        return updatedUser;
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

    getUserOtherBankAccountByCardDetails: async (userId, cardNumber, expiryDate, cvv) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);
        validation.cardNumberFieldValidation(cardNumber, "Card number", errors);
        validation.dateValidation(expiryDate, "Expiry date", errors);
        validation.cvvFieldValidation(cvv, "CVV", errors);

        const bankAccount = await BankAccount.findOne({
            where: {
                userId: userId,
                cardNumber: cardNumber,
                // expiryDate: expiryDate,
                cvv: cvv,
                isMain: false
            }
        })

        if (bankAccount) {
            return bankAccount;
        } else {
            throw new NotFoundError("User has no other bank account with those details.");
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
                [Op.or]: [
                    { '$sender.User.id$': userId },
                    { '$receiver.User.id$': userId }
                ]
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
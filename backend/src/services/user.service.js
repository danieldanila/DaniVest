import NotFoundError from "../errors/notFoundError.js";
import { BankAccount, User } from "../models/index.js";
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
};

export default service;
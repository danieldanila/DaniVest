import NotFoundError from "../errors/notFoundError.js";
import { User } from "../models/index.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import userValidation from "../validations/user.validation.js";

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

            return newUser;
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
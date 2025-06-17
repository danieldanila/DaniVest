import NotFoundError from "../errors/notFoundError.js";
import { User } from "../models/index.js";
import validation from "../validations/general.validation.js"; "../validations/general.validation.js"



const service = {
    createUser: async (userBody) => {
        const newUser = await User.create(userBody);
        return newUser;
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

    patchUserPasscode: async (loggedUser, userBody) => {
        const userFound = await service.getUserById(loggedUser.id);

        const updatedUser = await userFound.update({ passcode: userBody.passcode });
        return updatedUser;
    }
};

export default service;
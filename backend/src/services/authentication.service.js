import { User } from "../models/index.js";
import NotFoundError from "../errors/notFoundError.js";
import CredentialsDoNotMatchError from "../errors/credentialsDoNotMatchError.js";
import { signToken } from "../utils/authorization.util.js";

const service = {
    login: async (loginData) => {
        if (!loginData.username || !loginData.password) {
            throw new NotFoundError("Username or password field was not filled.")
        }

        const payload = {
            username: loginData.username,
            password: loginData.password
        }

        const user = await User.scope("withPassword").findOne({
            where: {
                username: payload.username,
            },
        });

        if (!user) {
            throw new CredentialsDoNotMatchError(
                "Credentials provided do not match with our records."
            );
        }

        const arePasswordsEqual = await User.arePasswordsEqual(
            payload.password,
            user.password
        );

        if (!arePasswordsEqual) {
            throw new CredentialsDoNotMatchError(
                "Credentials provided do not match with our records."
            );
        }
        const token = signToken(user.id);

        return token;
    },

    passcode: async (loginData) => {
        if (!loginData.username || !loginData.passcode) {
            throw new NotFoundError("Username or passcode field was not filled.")
        }

        const payload = {
            username: loginData.username,
            passcode: loginData.passcode
        }

        const user = await User.scope("withPassword").findOne({
            where: {
                username: payload.username,
            },
        });

        if (!user) {
            throw new CredentialsDoNotMatchError(
                "Credentials provided do not match with our records."
            );
        }

        const arePassCodesEqual = await User.arePasscodesEqual(
            payload.passcode,
            user.passcode
        );

        if (!arePassCodesEqual) {
            throw new CredentialsDoNotMatchError(
                "Credentials provided do not match with our records."
            );
        }
        const token = signToken(user.id);

        return token;
    }
}

export default service;
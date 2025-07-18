import { User } from "../models/index.js";
import NotFoundError from "../errors/notFoundError.js";
import CredentialsDoNotMatchError from "../errors/credentialsDoNotMatchError.js";
import { createPasswordResetToken, signToken } from "../utils/authorization.util.js";
import sendEmail from "../utils/email.util.js";
import validation from "../validations/general.validation.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import { Op } from "sequelize";
import crypto from "crypto";
import { UserService as userService } from "./index.js";


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
    },

    patchUserPasscode: async (loggedUser, userBody) => {
        const userFound = await userService.getUserById(loggedUser.id);

        const updatedUser = await userFound.update({ passcode: userBody.passcode });
        return updatedUser;
    },

    forgotPassword: async (userEmail) => {
        const user = await User.findOne({
            where: {
                email: userEmail,
            },
        });

        if (!user) {
            throw new NotFoundError("User is the given email was not found.");
        }

        const resetToken = createPasswordResetToken(user);

        await user.save();

        const resetURL = `frontend://resetPassword/${resetToken}`;

        const message = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>Password Reset</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #f2f2f2;
          padding: 20px;
        }

        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #fff;
          border-radius: 5px;
          padding: 20px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h1 {
          color: #007bff;
          text-align: center;
        }

        p {
          margin-bottom: 20px;
          line-height: 1.5;
        }

        .button {
          display: inline-block;
          padding: 10px 20px;
          background-color: #007bff;
          color: #fff;
          text-decoration: none;
          border-radius: 5px;
        }

        .button:hover {
          background-color: #0056b3;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Forgot Your Password?</h1>
        <p>Please reset your password by clicking the button below:</p>
        <p>
          <a class="button" href="${resetURL}">Reset Password</a>
        </p>
        <p>If you didn't request to reset your password, please ignore this email!</p>
      </div>
    </body>
    </html>
    `;

        try {
            await sendEmail({
                email: user.email,
                subject: "Password reset for DaniVest",
                message,
            });
        } catch (err) {
            user.passwordResetToken = null;
            user.passwordResetExpires = null;
            await user.save();

            throw new Error("There was an error when sending the email.");
        }
    },

    resetPassword: async (tokenParam, password) => {
        const hashedToken = crypto
            .createHash("sha256")
            .update(tokenParam)
            .digest("hex");

        const user = await User.findOne({
            where: {
                passwordResetToken: hashedToken,
                passwordResetExpires: { [Op.gt]: Date.now().toString() },
            },
        });

        if (!user) {
            throw new NotFoundError("Token is invalid or has expired.");
        }

        const errors = [];
        validation.validateCompletedField(
            validation.passwordValidation,
            password,
            "Password",
            errors,
            false
        );

        if (errors.length > 0) {
            throwValidationErrorWithMessage(errors);
        }

        user.password = password;
        user.passwordResetToken = null;
        user.passwordResetExpires = null;

        await user.save();

        return user;
    },


    updatePassword: async (loggedUser, userBody) => {
        const user = await User.scope("withPassword").findByPk(loggedUser.id);

        if (
            !(await User.arePasswordsEqual(userBody.currentPassword, user.password))
        ) {
            throw new CredentialsDoNotMatchError("Current password is wrong.");
        }

        const errors = [];

        validation.validateCompletedField(
            validation.passwordValidation,
            userBody.password,
            "Password",
            errors,
            false
        );

        if (errors.length > 0) {
            throwValidationErrorWithMessage(errors);
        }

        user.password = userBody.password;

        await user.save();

        const token = signToken(user.id);

        return token;
    },

    updatePasscode: async (loggedUser, userBody) => {
        const user = await User.scope("withPassword").findByPk(loggedUser.id);

        if (
            !(await User.arePasscodesEqual(userBody.currentPasscode, user.passcode))
        ) {
            throw new CredentialsDoNotMatchError("Current passcode is wrong.");
        }

        const errors = [];

        validation.validateCompletedField(
            validation.passcodeValidation,
            userBody.passcode,
            "Passcode",
            errors,
            false
        );

        if (errors.length > 0) {
            throwValidationErrorWithMessage(errors);
        }

        const updatedUser = await user.update({ passcode: userBody.passcode });

        return updatedUser;
    },
}

export default service;
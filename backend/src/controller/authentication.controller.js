import { AuthenticationService as authenticationService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    login: catchAsync(async (req, res, next) => {
        const token = await authenticationService.login(req.body);
        res.status(200).json({
            message: "Succesful login.",
            token
        });
    }),

    passcode: catchAsync(async (req, res, next) => {
        const token = await authenticationService.passcode(req.body);
        res.status(200).json({
            message: "Succesful login.",
            token
        });
    }),

    patchUserPasscode: catchAsync(async (req, res, next) => {
        const patchedUser = await authenticationService.patchUserPasscode(req.user, req.body);

        res.status(202).json({ message: `User '${patchedUser.username}' passcode modified.` })
    }),

    getCurrentUser: catchAsync(async (req, res, next) => {
        return res.status(200).json(res.locals.user);
    }),

    forgotPassword: catchAsync(async (req, res, next) => {
        await authenticationService.forgotPassword(req.body.email);
        res.status(200).json({
            message: "Account recovery email sent.",
        });
    }),

    resetPassword: catchAsync(async (req, res, next) => {
        const userUpdated = await authenticationService.resetPassword(
            req.params.token,
            req.body.password
        );

        res
            .status(200)
            .json({ message: `Sucessful password reset for ${userUpdated.email}.` });
    }),

    updatePassword: catchAsync(async (req, res, next) => {
        const token = await authenticationService.updatePassword(
            req.user,
            req.body
        );

        res
            .status(200)
            .json({ message: "You successfully updated your password.", token });
    }),


    updatePasscode: catchAsync(async (req, res, next) => {
        const patchedUser = await authenticationService.updatePasscode(req.user, req.body);

        res.status(202).json({ message: `${patchedUser.fullName}, you successfully updated your passcode.` })
    }),
}

export default controller;
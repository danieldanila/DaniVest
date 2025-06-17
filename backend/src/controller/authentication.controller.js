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

    getCurrentUser: catchAsync(async (req, res, next) => {
        return res.status(200).json(res.locals.user);
    }),
}

export default controller;
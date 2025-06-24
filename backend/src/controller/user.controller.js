import { UserService as userService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createUser: catchAsync(async (req, res, next) => {
        const newUser = await userService.createUser(req.body);

        res.status(201).json({ message: `User '${newUser.username}' created.` })

    }),

    getUserById: catchAsync(async (req, res, next) => {
        const user = await userService.getUserById(req.params.id);
        res.status(200).json(user);
    }),

    patchUserPasscode: catchAsync(async (req, res, next) => {
        const patchedUser = await userService.patchUserPasscode(req.user, req.body);

        res.status(202).json({ message: `User '${patchedUser.username}' passcode modified.` })
    }),
}

export default controller;
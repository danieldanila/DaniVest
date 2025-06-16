import { UserService as userService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createUser: catchAsync(async (req, res, next) => {
        const newUser = await userService.createUser(req.body);

        res.status(201).json({ message: `User '${newUser.username}' created.` })

    })
}

export default controller;
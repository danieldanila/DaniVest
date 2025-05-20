import { UserService as userService } from "../services/index.js";

const controller = {
    createUser: async (req, res) => {
        try {
            const newUser = await userService.createUser(req.body);

            res.status(201).json({ message: `User '${newUser.username}' created.` })
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }
}

export default controller;
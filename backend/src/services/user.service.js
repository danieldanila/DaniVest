import { User } from "../models/index.js";

const service = {
    createUser: async (userBody) => {
        const newUser = await User.create(userBody);
        return newUser;
    },
};

export default service;
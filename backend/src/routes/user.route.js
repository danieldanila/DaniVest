import express from "express";
import { UserController as userController } from "../controller/index.js";
import { AuthenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    userController.createUser
);

router.get(
    "/:id",
    AuthenticationMiddleware.protect,
    userController.getUserById
);

router.patch(
    "/passcode",
    AuthenticationMiddleware.protect,
    userController.patchUserPasscode
);

export default router;
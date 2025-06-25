import express from "express";
import { UserController as userController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    userController.createUser
);

router.get("/", authenticationMiddleware.protect, userController.getAllUsers);

router.get(
    "/:id",
    authenticationMiddleware.protect,
    userController.getUserById
);

export default router;
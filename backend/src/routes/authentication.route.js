import express from "express";
import { AuthenticationController as authenticationController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post("/login", authenticationController.login);
router.post("/passcode", authenticationController.passcode);
router.get(
    "/me",
    authenticationMiddleware.protect,
    authenticationController.getCurrentUser
);

export default router;
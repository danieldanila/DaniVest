import express from "express";
import { AuthenticationController as authenticationController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";


const router = express.Router();

router.post("/login", authenticationController.login);
router.post("/passcode", authenticationController.passcode);
router.patch(
    "/passcode",
    authenticationMiddleware.protect,
    authenticationController.patchUserPasscode
);
router.get(
    "/me",
    authenticationMiddleware.protect,
    authenticationController.getCurrentUser
);

router.post("/forgotPassword", authenticationController.forgotPassword);
router.patch("/resetPassword/:token", authenticationController.resetPassword);
router.patch(
    "/updateMyPassword",
    authenticationMiddleware.protect,
    authenticationController.updatePassword
);
router.patch(
    "/updateMyPasscode",
    authenticationMiddleware.protect,
    authenticationController.updatePasscode
);

export default router;
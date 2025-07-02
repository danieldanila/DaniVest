import express from "express";
import { UserController as userController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    userController.createUser
);

router.post(
    "/creates",
    userController.createMultipleUsers
);

router.put(
    "/:id",
    authenticationMiddleware.protect,
    userController.updateUser
);
router.patch(
    "/updateMe",
    authenticationMiddleware.protect,
    userController.updateMe
);

router.get("/", authenticationMiddleware.protect, userController.getAllUsers);

router.get(
    "/:id",
    authenticationMiddleware.protect,
    userController.getUserById
);

router.get("/:id/bank", authenticationMiddleware.protect, userController.getUserBankAccount);

router.get("/:id/bank/other", authenticationMiddleware.protect, userController.getUserOtherBankAccount);

router.get("/:id/bank/other/cardNumber/:cardNumber/cvv/:cvv/expiryDate/:expiryDate", authenticationMiddleware.protect, userController.getUserOtherBankAccountByCardDetails);

router.get("/:id/transactions", authenticationMiddleware.protect, userController.getUserAllTransactions);

export default router;
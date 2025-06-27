import express from "express";
import { BankAccountController as bankAccountController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    bankAccountController.createBankAccount
);

router.get("/", authenticationMiddleware.protect, bankAccountController.getAllBankAccounts);

router.get(
    "/:id",
    authenticationMiddleware.protect,
    bankAccountController.getBankAccountById
);

export default router;
import express from "express";
import { TransactionController as transactionController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    transactionController.createTransaction
);

router.post(
    "/creates",
    authenticationMiddleware.protect,
    transactionController.createMultipleTransactions
);

router.get("/", authenticationMiddleware.protect, transactionController.getAllTransactions);

router.get(
    "/:id",
    authenticationMiddleware.protect,
    transactionController.getTransactionById
);

export default router;
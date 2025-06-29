import express from "express";
import DatabaseRouter from "./database.route.js";
import UserRouter from "./user.route.js";
import AuthenticationRouter from "./authentication.route.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";
import BankAccountRouter from "./bankAccount.route.js";
import TransactionRouter from "./transaction.route..js";
import FriendRouter from "./friend.route.js";
import ConversationRouter from "./conversation.route.js";

const router = express.Router();

router.use(authenticationMiddleware.isLoggedIn);

router.use("/database", DatabaseRouter);
router.use("/user", UserRouter);
router.use("/auth", AuthenticationRouter);
router.use("/bankAccount", BankAccountRouter);
router.use("/transaction", TransactionRouter);
router.use("/friend", FriendRouter);
router.use("/conversation", ConversationRouter);

export default router;
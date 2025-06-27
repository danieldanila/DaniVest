import express from "express";
import DatabaseRouter from "./database.route.js";
import UserRouter from "./user.route.js";
import AuthenticationRouter from "./authentication.route.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";
import BankAccountRouter from "./bankAccount.route.js";

const router = express.Router();

router.use(authenticationMiddleware.isLoggedIn);

router.use("/database", DatabaseRouter);
router.use("/user", UserRouter);
router.use("/auth", AuthenticationRouter);
router.use("/bankAccount", BankAccountRouter);


export default router;
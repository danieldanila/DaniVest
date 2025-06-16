import express from "express";
import DatabaseRouter from "./database.route.js";
import UserRouter from "./user.route.js";
import AuthenticationRouter from "./authentication.route.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.use(authenticationMiddleware.isLoggedIn);

router.use("/database", DatabaseRouter);
router.use("/user", UserRouter);
router.use("/auth", AuthenticationRouter);

export default router;
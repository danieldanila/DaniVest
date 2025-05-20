import express from "express";
import DatabaseRouter from "./database.route.js";
import UserRouter from "./user.route.js";

const router = express.Router();

router.use("/database", DatabaseRouter);
router.use("/user", UserRouter);

export default router;
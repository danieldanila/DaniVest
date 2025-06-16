import express from "express";
import { UserController as userController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    userController.createUser
);

export default router;
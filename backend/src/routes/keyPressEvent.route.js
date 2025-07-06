import express from "express";
import { KeyPressEventController as keyPressEventController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    keyPressEventController.createKeyPressEvent
);


export default router;
import express from "express";
import { TouchEventController as touchEventController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    touchEventController.createTouchEvent
);


export default router;
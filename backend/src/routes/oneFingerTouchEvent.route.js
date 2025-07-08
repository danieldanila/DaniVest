import express from "express";
import { OneFingerTouchEventController as oneFingerTouchEventController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    oneFingerTouchEventController.createOneFingerTouchEvent
);


export default router;
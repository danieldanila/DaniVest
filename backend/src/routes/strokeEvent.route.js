import express from "express";
import { StrokeEventController as strokeEventController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    strokeEventController.createStrokeEvent
);


export default router;
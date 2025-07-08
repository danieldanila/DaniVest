import express from "express";
import { ScrollEventController as scrollEventController } from "../controller/index.js";

const router = express.Router();

router.post(
    "/create",
    scrollEventController.createScrollEvent
);


export default router;
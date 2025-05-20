import express from "express";
import { DatabaseController as databaseController } from "../controller/index.js";

const router = express.Router();

router.get("/sync", databaseController.sync);

export default router;
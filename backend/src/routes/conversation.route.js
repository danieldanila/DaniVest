import express from "express";
import { ConversationController as conversationController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    conversationController.createConversation
);

router.post(
    "/creates",
    authenticationMiddleware.protect,
    conversationController.createMultipleConversations
);

router.get("/", authenticationMiddleware.protect, conversationController.getAllConversations);

router.get(
    "/:userId/friend/:friendId",
    authenticationMiddleware.protect,
    conversationController.getConversationsByCompositeId
);

export default router;
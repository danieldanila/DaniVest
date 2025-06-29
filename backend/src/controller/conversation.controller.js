import { ConversationService as conversationService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createConversation: catchAsync(async (req, res, next) => {
        const newConversation = await conversationService.createConversation(req.body);

        res.status(201).json({ message: `Conversation betwen '${newConversation.userId}' and '${newConversation.friendId}' created.` })

    }),

    createMultipleConversations: catchAsync(async (req, res, next) => {
        await conversationService.createMultipleConversations(req.body);
        res.status(201).json({
            message: `${req.body.length} conversations created.`,
        });
    }),

    getAllConversations: catchAsync(async (req, res, next) => {
        const conversations = await conversationService.getAllConversations();
        res.status(200).json(conversations);
    }),

    getConversationsByCompositeId: catchAsync(async (req, res, next) => {
        const conversations = await conversationService.getConversationsByCompositeId(req.params.userId, req.params.friendId);
        res.status(200).json(conversations);
    }),
}

export default controller;
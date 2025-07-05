import NotFoundError from "../errors/notFoundError.js";
import { Conversation, User } from "../models/index.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import conversationValidation from "../validations/conversation.validation.js";
import userService from "./user.service.js";

const service = {
    createConversation: async (conversationBody) => {
        const existingUsers = await userService.getAllUsers();
        const errors = await conversationValidation.checkConversationsFields(
            conversationBody,
            existingUsers,
            false
        );

        if (errors.length === 0) {
            const newConversation = await Conversation.create(conversationBody);

            const populatedConversation = await Conversation.findOne({
                where: {
                    id: newConversation.id
                },
                include: [
                    {
                        model: User,
                        as: "senderUser",

                    },
                    {
                        model: User,
                        as: "receiverUser",

                    }
                ],
            });

            return populatedConversation;
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    createMultipleConversations: async (arrayOfConversationBodies) => {
        for (const conversationBody of arrayOfConversationBodies) {
            await service.createConversation(conversationBody);
        }
    },

    getAllConversations: async () => {
        const conversations = await Conversation.findAll();
        return conversations;
    },

    getConversationsByCompositeId: async (userId, friendId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);
        validation.idParamaterValidation(friendId, "Friend id", errors);

        const conversations = await Conversation.findAll({
            where: {
                userId: userId,
                friendId: friendId,
            },
        });

        if (conversations) {
            return conversations;
        } else {
            throw new NotFoundError("Conversations not found.");
        }
    },
};

export default service;
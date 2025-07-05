import generalValidation from "./general.validation.js";

const validation = {
    checkConversationsFields: async (
        conversation,
        existingUsers,
        isUpdateRequest
    ) => {
        const errors = [];

        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            conversation.userId,
            "User id",
            errors,
            isUpdateRequest,
            existingUsers
        );
        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            conversation.friendId,
            "Friend id",
            errors,
            isUpdateRequest,
            existingUsers
        );
        generalValidation.validateCompletedField(
            generalValidation.lengthGreaterThanThreeValidation,
            conversation.message,
            "Message",
            errors,
            isUpdateRequest
        );
        generalValidation.validateCompletedField(
            generalValidation.datetimeValidation,
            conversation.datetime,
            "Datetime",
            errors,
            isUpdateRequest
        );

        if (conversation.id) {
            generalValidation.uuidValidation(conversation.id, "Conversation id", errors);
        }

        return errors;
    },
};

export default validation;
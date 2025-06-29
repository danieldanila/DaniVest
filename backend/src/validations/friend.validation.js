import generalValidation from "./general.validation.js";

const validation = {
    checkFriendsFields: async (
        friend,
        existingFriends,
        existingUsers,
        isUpdateRequest
    ) => {
        const errors = [];

        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            friend.userId,
            "User id",
            errors,
            isUpdateRequest,
            existingUsers
        );
        generalValidation.validateCompletedField(
            generalValidation.foreignUuidValidation,
            friend.friendId,
            "Friend id",
            errors,
            isUpdateRequest,
            existingUsers
        );
        generalValidation.validateCompletedField(
            generalValidation.dateValidation,
            friend.since,
            "Since",
            errors,
            isUpdateRequest
        );

        if (existingFriends.length > 0) {
            if (friend.userId || friend.friendId) {
                generalValidation.duplicateCompositeIdValidation(
                    friend.userId,
                    "userId",
                    friend.friendId,
                    "friendId",
                    errors,
                    existingFriends
                );
            }
        }

        return errors;
    },
};

export default validation;
import NotFoundError from "../errors/notFoundError.js";
import { Friend } from "../models/index.js";
import throwValidationErrorWithMessage from "../utils/errorsWrapper.util.js";
import validation from "../validations/general.validation.js";
import friendValidation from "../validations/friend.validation.js";
import userService from "./user.service.js";

const service = {
    createFriend: async (friendBody) => {
        const existingFriends = await service.getAllFriends();
        const existingUsers = await userService.getAllUsers();
        const errors = await friendValidation.checkFriendsFields(
            friendBody,
            existingFriends,
            existingUsers,
            false
        );

        if (errors.length === 0) {
            const newFriend = await Friend.create(friendBody);

            return newFriend;
        } else {
            throwValidationErrorWithMessage(errors);
        }
    },

    createMultipleFriends: async (arrayOfFriendBodies) => {
        for (const friendBody of arrayOfFriendBodies) {
            await service.createFriend(friendBody);
        }
    },

    getAllFriends: async () => {
        const friends = await Friend.findAll();
        return friends;
    },

    getFriendByCompositeId: async (userId, friendId) => {
        const errors = [];

        validation.idParamaterValidation(userId, "User id", errors);
        validation.idParamaterValidation(friendId, "Friend id", errors);

        const friend = await Friend.findOne({
            where: {
                userId: userId,
                friendId: friendId,
            },
        });

        if (friend) {
            return friend;
        } else {
            throw new NotFoundError("Friend not found.");
        }
    },
};

export default service;
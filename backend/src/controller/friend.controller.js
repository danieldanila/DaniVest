import { FriendService as friendService } from "../services/index.js";
import catchAsync from "../utils/catchAsync.util.js";

const controller = {
    createFriend: catchAsync(async (req, res, next) => {
        const newFriend = await friendService.createFriend(req.body);

        res.status(201).json({ message: `Friendship betwen '${newFriend.userId}' and '${newFriend.friendId}' created.` })

    }),

    createMultipleFriends: catchAsync(async (req, res, next) => {
        await friendService.createMultipleFriends(req.body);
        res.status(201).json({
            message: `${req.body.length} friends created.`,
        });
    }),

    getAllFriends: catchAsync(async (req, res, next) => {
        const friends = await friendService.getAllFriends();
        res.status(200).json(friends);
    }),

    getFriendByCompositeId: catchAsync(async (req, res, next) => {
        const friend = await friendService.getFriendByCompositeId(req.params.userId, req.params.friendId);
        res.status(200).json(friend);
    }),
}

export default controller;
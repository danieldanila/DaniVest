import express from "express";
import { FriendController as friendController } from "../controller/index.js";
import { AuthenticationMiddleware as authenticationMiddleware } from "../middlewares/index.js";

const router = express.Router();

router.post(
    "/create",
    friendController.createFriend
);

router.post(
    "/creates",
    authenticationMiddleware.protect,
    friendController.createMultipleFriends
);

router.get("/", authenticationMiddleware.protect, friendController.getAllFriends);

router.get(
    "/:userId/friend/:friendId",
    authenticationMiddleware.protect,
    friendController.getFriendByCompositeId
);

export default router;
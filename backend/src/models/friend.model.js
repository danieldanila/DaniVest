import DataTypes from "sequelize";
import Database from "../configs/database.config.js";
import User from "./user.model.js";

const Friend = Database.define("Friend", {
    userId: {
        type: DataTypes.UUID,
        primaryKey: true,
        unique: "friendCompositeIndex",
        validate: {
            isUUID: 4,
        },
        references: {
            model: User,
            key: "id",
        },
    },
    friendId: {
        type: DataTypes.UUID,
        primaryKey: true,
        unique: "friendCompositeIndex",
        validate: {
            isUUID: 4,
        },
        references: {
            model: User,
            key: "id",
        },
    },
    since: {
        type: DataTypes.DATEONLY,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
},
    {
        underscored: true,
        tableName: "Friends",
        indexes: [
            {
                unique: true,
                fields: ["user_id", "friend_id"],
            },
        ]
    }
);

export default Friend;
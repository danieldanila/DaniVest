import DataTypes from "sequelize";
import Database from "../configs/database.config.js";
import User from "./user.model.js";

const Conversation = Database.define("Conversation", {
    userId: {
        type: DataTypes.UUID,
        allowNull: false,
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
        allowNull: false,
        validate: {
            isUUID: 4,
        },
        references: {
            model: User,
            key: "id",
        },
    },
    message: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    datetime: {
        type: DataTypes.DATE,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
},
    {
        underscored: true,
        tableName: "Conversations",
        indexes: [
            {
                unique: false,
                fields: ["user_id", "friend_id"],
            },
        ]
    }
);

export default Conversation;
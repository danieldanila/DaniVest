import { DataTypes } from "sequelize";
import Database from "../configs/database.config.js";
import User from "./user.model.js";
import BankAccount from "./bankAccount.model.js";
import Transaction from "./transaction.model.js";
import Friend from "./friend.model.js";
import Conversation from "./conversation.model.js";

User.hasMany(BankAccount, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
BankAccount.belongsTo(User, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
BankAccount.hasMany(Transaction, {
    as: "sender",
    foreignKey: {
        name: "senderBankAccountId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
Transaction.belongsTo(BankAccount, {
    as: "sender",
    foreignKey: {
        name: "senderBankAccountId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
BankAccount.hasMany(Transaction, {
    as: "receiver",
    foreignKey: {
        name: "receiverBankAccountId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
Transaction.belongsTo(BankAccount, {
    as: "receiver",
    foreignKey: {
        name: "receiverBankAccountId",
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
            isUUID: 4,
        },
    },
});
User.belongsToMany(User, {
    as: "FriendWith",
    through: Friend,
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
    otherKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
User.belongsToMany(User, {
    as: "FriendedBy",
    through: Friend,
    foreignKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
    otherKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
User.hasMany(Friend, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
Friend.belongsTo(User, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
User.hasMany(Friend, {
    foreignKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
Friend.belongsTo(User, {
    foreignKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
User.hasMany(Conversation, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
Conversation.belongsTo(User, {
    foreignKey: {
        name: "userId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
User.hasMany(Conversation, {
    foreignKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});
Conversation.belongsTo(User, {
    foreignKey: {
        name: "friendId",
        type: DataTypes.UUID,
        validate: {
            isUUID: 4,
        },
    },
});

export {
    User,
    BankAccount,
    Transaction,
    Friend,
    Conversation,
    Database,
}

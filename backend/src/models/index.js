import Database from "../configs/database.config.js";
import User from "./user.model.js";
import BankAccount from "./bankAccount.model.js";
import { DataTypes } from "sequelize";

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


export {
    User,
    BankAccount,
    Database,
}

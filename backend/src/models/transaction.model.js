import database from "../configs/database.config.js";
import DataTypes from "sequelize";

const Transaction = database.bankApplicationDatabase.define("Transaction", {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        validate: {
            notEmpty: true,
            isUUID: 4,
        }
    },
    amount: {
        type: DataTypes.DECIMAL(8, 2).UNSIGNED,
        allowNull: false,
        validate: {
            isDecimal: true,
        },
    },
    datetime: {
        type: DataTypes.DATE,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    details: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    isApproved: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
        allowNull: false,
    }
}, {
    underscored: true,
    tableName: "Transactions",
});

export default Transaction;
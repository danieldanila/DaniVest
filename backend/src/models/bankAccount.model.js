import Database from "../configs/database.config.js";
import DataTypes from "sequelize";

const BankAccount = Database.define("BankAccount", {
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
    iban: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
            notEmpty: true,
        }
    },
    cardNumber: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
            notEmpty: true,
        }
    },
    expiryDate: {
        type: DataTypes.DATEONLY,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    cvv: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    isMain: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: false,
    }
}, {
    underscored: true,
    tableName: "BankAccounts",
});

export default BankAccount;
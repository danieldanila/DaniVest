import Database from "../configs/database.config.js";
import DataTypes from "sequelize";

const KeyPressEvent = Database.define("KeyPressEvent  ", {
    SYSTIME: {
        primaryKey: true,
        type: DataTypes.NUMBER,
        validate: {
            notEmpty: true,
        }
    },
    PRESSTIME: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    ACTIVITYID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    PRESSTYPE: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    KEYID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    PHONE_ORIENTATION: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
}, {
    tableName: "KEYPRESSEVENT",
    createdAt: false,
    updatedAt: false,

});

export default KeyPressEvent;
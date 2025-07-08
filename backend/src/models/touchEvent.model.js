import database from "../configs/database.config.js";
import DataTypes from "sequelize";

const TouchEvent = database.behaviouralBiometricDatabase.define("TouchEvent", {
    SYSTIME: {
        primaryKey: true,
        type: DataTypes.NUMBER,
        validate: {
            notEmpty: true,
        }
    },
    EVENTTIME: {
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
    POINTER_COUNT: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    POINTERID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    ACTIONID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    Y: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    CONTACT_SIZE: {
        type: DataTypes.DECIMAL,
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
    tableName: "TOUCHEVENT",
    createdAt: false,
    updatedAt: false,

});

export default TouchEvent;
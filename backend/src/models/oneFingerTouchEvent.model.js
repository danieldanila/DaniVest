import database from "../configs/database.config.js";
import DataTypes from "sequelize";

const OneFingerTouchEvent = database.behaviouralBiometricDatabase.define("OneFingerTouchEvent  ", {
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
    TAPID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    TAP_TYPE: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    ACTION_TYPE: {
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
    tableName: "ONEFINGERTOUCHEVENT",
    createdAt: false,
    updatedAt: false,

});

export default OneFingerTouchEvent;
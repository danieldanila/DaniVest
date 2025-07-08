import database from "../configs/database.config.js";
import DataTypes from "sequelize";

const ScrollEvent = database.behaviouralBiometricDatabase.define("ScrollEvent", {
    SYSTIME: {
        primaryKey: true,
        type: DataTypes.NUMBER,
        validate: {
            notEmpty: true,
        }
    },
    BEGINTIME: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    CURRENTTIME: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    ACTIVITYID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    SCROLLID: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    START_X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    START_Y: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    START_SIZE: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    CURRENT_X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    CURRENT_Y: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    CURRENT_SIZE: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    DISTANCE_X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    DISTANCE_Y: {
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
    tableName: "SCROLLEVENT",
    createdAt: false,
    updatedAt: false,

});

export default ScrollEvent;
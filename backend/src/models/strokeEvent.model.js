import database from "../configs/database.config.js";
import DataTypes from "sequelize";

const StrokeEvent = database.behaviouralBiometricDatabase.define("StrokeEvent", {
    SYSTIME: {
        primaryKey: true,
        type: DataTypes.NUMBER,
        validate: {
            notEmpty: true,
        }
    },
    BEGIN_TIME: {
        type: DataTypes.NUMBER,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    END_TIME: {
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
    END_X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    END_Y: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    END_SIZE: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    SPEED_X: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    SPEED_Y: {
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
    tableName: "STROKEEVENT",
    createdAt: false,
    updatedAt: false,

});

export default StrokeEvent;
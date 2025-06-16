import Database from "../configs/database.config.js";
import DataTypes from "sequelize";
import bcrypt from "bcrypt"

const User = Database.define("User", {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        validate: {
            notEmpty: true,
            isUUID: 4,
        }
    },
    username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
            notEmpty: true,
        }

    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
            notEmpty: true,
        }
    },
    firstName: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    lastName: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    phoneNumber: {
        type: DataTypes.STRING(12),
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    birthdate: {
        type: DataTypes.DATEONLY,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    profilePicturePath: {
        type: DataTypes.STRING,
        allowNull: true,
        validate: {
            notEmpty: true,
        }
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        }
    },
    passcode: {
        type: DataTypes.STRING,
        allowNull: true,
        validate: {
            notEmpty: true,
        }
    },

}, {
    underscored: true,
    tableName: "Users",
    defaultScope: {
        attributes: {
            exclude: [
                "password",
                "passcode",
                "createdAt",
                "updatedAt"
            ],
        },
    },
    scopes: {
        withPassword: {
            attributes: {
                include: [
                    "password",
                    "passcode",
                    "createdAt",
                    "updatedAt"
                ],
            },
        },
    },
    hooks: {
        beforeSave: async (user) => {
            if (user.changed("password")) {
                const saltRounds = 10;
                const salt = await bcrypt.genSalt(saltRounds);
                const hashedPassword = await bcrypt.hash(user.password, salt);

                user.password = hashedPassword;
            }
        },
    },
});

User.arePasswordsEqual = async (candidatePassword, userPassword) => {
    return await bcrypt.compare(candidatePassword, userPassword);
};

export default User;
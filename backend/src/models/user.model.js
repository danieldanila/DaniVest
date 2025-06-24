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
    hasPasscode: {
        type: DataTypes.VIRTUAL,
        get() {
            return this.getDataValue("passcode") != null;
        }
    },
    passwordResetToken: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    passwordResetExpires: {
        type: DataTypes.DATE,
        allowNull: true,
    }

}, {
    underscored: true,
    tableName: "Users",
    defaultScope: {
        attributes: {
            exclude: [
                "password",
                "passcode",
                "hasPasscode",
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
        witPasscode: {
            attributes: {
                include: [
                    "passcode",
                    "hasPasscode",
                ],
                exclude: [
                    "password",
                    "createdAt",
                    "updatedAt"
                ]
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

            if (user.changed("passcode")) {
                const saltRounds = 10;
                const salt = await bcrypt.genSalt(saltRounds);
                const hashedPasscode = await bcrypt.hash(user.passcode, salt);

                user.passcode = hashedPasscode;
            }
        },
    },
});

User.arePasswordsEqual = async (candidatePassword, userPassword) => {
    return await bcrypt.compare(candidatePassword, userPassword);
};

User.arePasscodesEqual = async (candidatePasscode, userPasscode) => {
    return await bcrypt.compare(candidatePasscode, userPasscode);
};

export default User;
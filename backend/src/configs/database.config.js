import { Sequelize } from "sequelize";

const database = {
    bankApplicationDatabase: new Sequelize(
        process.env.DB_NAME,
        process.env.DB_USER,
        process.env.DB_PASSWORD,
        {
            host: process.env.DB_HOST,
            port: process.env.DB_PORT,
            dialect: process.env.DB_DIALECT,
            charset: "utf8",
            collate: "utf8_general_ci",
        }
    ),

    behaviouralBiometricDatabase: new Sequelize(
        process.env.DB_NAME,
        process.env.DB_USER_BEHAVIOURAL,
        process.env.DB_PASSWORD,
        {
            host: process.env.DB_HOST,
            port: process.env.DB_PORT,
            dialect: process.env.DB_DIALECT,
            charset: "utf8",
            collate: "utf8_general_ci",
        }
    )
}

export default database;
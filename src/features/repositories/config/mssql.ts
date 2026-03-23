// MSSQL database connection
import dotenv from "dotenv";
import sql from "mssql";
dotenv.config();

// MSSQL configuration
const config: sql.config ={
    user: process.env.USER!,
    password: process.env.PASSWORD!,
    server: process.env.SERVER!,
    database: process.env.DATABASE!,
    options: {
        encrypt: false,
        trustServerCertificate: false
    }
};

// MSSQL pool connection
export const database = new sql.ConnectionPool(config);
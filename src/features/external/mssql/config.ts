// MSSQL database connection
import dotenv from "dotenv";
import sql from "mssql";
dotenv.config();

// MSSQL configuration
const config: sql.config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER || "localhost",
  port: Number(process.env.DB_PORT) || 1433,
  database: process.env.DB_NAME || "master",
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

// MSSQL pool connection
export const database = new sql.ConnectionPool(config);
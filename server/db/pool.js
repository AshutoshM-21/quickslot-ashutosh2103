const { Pool } = require("pg");

if (!process.env.DATABASE_URL) {
  console.warn("WARNING: DATABASE_URL is not set. Database queries will fail.");
}

const useSsl =
  process.env.DATABASE_SSL === "true" ||
  process.env.RAILWAY_ENVIRONMENT !== undefined ||
  (process.env.DATABASE_URL || "").includes("sslmode=require");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: useSsl ? { rejectUnauthorized: false } : false,
});

module.exports = pool;

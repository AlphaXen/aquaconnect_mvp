import pg from 'pg';

const { Pool } = pg;

// Railway injects DATABASE_URL automatically once a Postgres plugin is
// attached to this service. Locally, set it in `.env` / the shell before
// running `npm run migrate` / `npm run seed` / `npm start`.
const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error('DATABASE_URL is not set. Attach a Postgres plugin on Railway, or set it locally.');
}

export const pool = new Pool({
  connectionString,
  ssl: connectionString.includes('localhost') ? false : { rejectUnauthorized: false },
});

export const query = (text, params) => pool.query(text, params);

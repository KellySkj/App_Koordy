import pg from "pg";

const { Pool } = pg;

export const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "koordy_test",
  password: "",
  port: 5432,
});
pool
  .connect()
  .then((client) => {
    console.log("Connexion PostgreSQL réussie");
    client.release();
  })
  .catch((err) => {
    console.error("Erreur connexion PostgreSQL :", err);
  });
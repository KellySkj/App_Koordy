import { pool } from "../config/db.js";

export async function inscription(req, res) {
  const { nom, prenom, email, password, birthday } = req.body;

  if (!nom || !prenom || !email || !password || !birthday) {
    return res.status(400).json({ message: "Champs manquants." });
  }

  try {
    const existingUserResult = await pool.query(
      "SELECT id_membre FROM membre WHERE mail_membre = $1",
      [email]
    );

    const existingUser = existingUserResult.rows;

    if (existingUser.length > 0) {
      return res.status(409).json({ message: "Utilisateur déjà existant" });
    }

    const age = new Date().getFullYear() - new Date(birthday).getFullYear();

    const result = await pool.query(
      `INSERT INTO membre
       (nom_membre, prenom_membre, mail_membre, password_membre, date_naissance, age)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id_membre`,
      [nom, prenom, email, password, birthday, age]
    );

    return res.status(201).json({
      message: "Utilisateur créé",
      id: result.rows[0].id_membre,
    });
  } catch (err) {
    console.error("Erreur SQL :", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Champs manquants." });
  }

  try {
    const result = await pool.query(
      "SELECT * FROM membre WHERE mail_membre = $1",
      [email]
    );

    const rows = result.rows;

    if (rows.length === 0) {
      return res
        .status(404)
        .json({ message: "Aucun compte trouvé avec cet email." });
    }

    const user = rows[0];

    if (user.password_membre !== password) {
      return res.status(401).json({ message: "Mot de passe incorrect." });
    }

    const assoResult = await pool.query(
      "SELECT id_association FROM membre_asso WHERE id_membre = $1 LIMIT 1",
      [user.id_membre]
    );

    const assoRows = assoResult.rows;
    const id_association = assoRows.length ? assoRows[0].id_association : null;

    return res.status(200).json({
      message: "Connexion réussie",
      id_membre: user.id_membre,
      nom: user.nom_membre,
      prenom: user.prenom_membre,
      id_association,
    });
  } catch (err) {
    console.error("Erreur SQL :", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}
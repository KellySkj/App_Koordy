import { pool } from "../config/db.js";

export async function getMembreById(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT m.*, ma.role AS role_asso, ma.date_adhesion, e.nom_equipe
       FROM membre m
       LEFT JOIN membre_asso ma ON m.id_membre = ma.id_membre
       LEFT JOIN membre_activite a ON ma.id_membre_asso = a.id_membre_asso
       LEFT JOIN equipe e ON a.id_equipe = e.id_equipe
       WHERE m.id_membre = $1`,
      [id]
    );

    res.json(result.rows[0] || {});
  } catch (err) {
    console.error("Erreur get membre :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function updateMembre(req, res) {
  const id = req.params.id;
  const { nom, prenom, email, birthday } = req.body;

  try {
    let age = null;
    if (birthday) {
      age = new Date().getFullYear() - new Date(birthday).getFullYear();
    }

    const result = await pool.query(
      `UPDATE membre
       SET nom_membre = $1,
           prenom_membre = $2,
           mail_membre = $3,
           date_naissance = $4,
           age = $5
       WHERE id_membre = $6`,
      [nom, prenom, email, birthday, age, id]
    );

    res.json({ message: "Profil mis à jour", result: result.rowCount });
  } catch (err) {
    console.error("Erreur SQL lors du PUT membre :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getMembreEquipes(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT
          e.nom_equipe,
          a.role_activite AS role
       FROM membre_activite a
       JOIN equipe e ON a.id_equipe = e.id_equipe
       JOIN membre_asso ma ON ma.id_membre_asso = a.id_membre_asso
       WHERE ma.id_membre = $1`,
      [id]
    );

    res.json(result.rows);
  } catch (error) {
    console.error("Erreur SQL GET équipes :", error);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getMembreAssociation(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT a.*
       FROM membre_asso ma
       JOIN association a ON ma.id_association = a.id_association
       WHERE ma.id_membre = $1
       LIMIT 1`,
      [id]
    );

    res.json(result.rows[0] || {});
  } catch (err) {
    console.error("Erreur SQL association du membre :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getMembreInvitations(req, res) {
  const { id_membre } = req.params;

  try {
    const result = await pool.query(
      `SELECT
          e.id_evenement,
          e.titre_evenement,
          e.date_debut_event,
          a.nom AS nom_association,
          p.presence
       FROM participation p
       JOIN evenement e ON p.id_evenement = e.id_evenement
       JOIN association a ON e.id_association = a.id_association
       WHERE p.id_membre = $1
       ORDER BY e.date_debut_event ASC`,
      [Number(id_membre)]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur invitations membre :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}
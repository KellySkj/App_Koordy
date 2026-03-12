import { pool } from "../config/db.js";
import { getPermissions } from "../services/permission.service.js";

export async function createNews(req, res) {
  const { id_association, id_auteur, titre, contenu, image_principale } = req.body;

  if (!id_association || !id_auteur || !titre || !contenu) {
    return res.status(400).json({ message: "Champs obligatoires manquants." });
  }

  const { permissions } = await getPermissions(id_association, id_auteur);
  if (!permissions.canCreateNews) {
    return res.status(403).json({ message: "Droits insuffisants pour créer une actualité." });
  }

  try {
    const result = await pool.query(
      `INSERT INTO actualite
       (id_association, id_auteur, type_actualite, titre, contenu, image_principale, statut, date_creation, date_publication)
       VALUES ($1, $2, 'Article', $3, $4, $5, 'Approuve', NOW(), NOW())
       RETURNING id_actualite`,
      [
        Number(id_association),
        Number(id_auteur),
        titre,
        contenu,
        image_principale || null,
      ]
    );

    return res.status(201).json({
      success: true,
      id_actualite: result.rows[0].id_actualite,
    });
  } catch (err) {
    console.error("Erreur création actu:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function approveNews(req, res) {
  const id = req.params.id;

  try {
    await pool.query(
      `UPDATE actualite
       SET statut = 'Approuve', date_publication = NOW()
       WHERE id_actualite = $1`,
      [id]
    );

    res.json({ success: true });
  } catch (err) {
    console.error("Erreur approve news :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function refuseNews(req, res) {
  const id = req.params.id;

  try {
    await pool.query(
      `UPDATE actualite
       SET statut = 'Refuse'
       WHERE id_actualite = $1`,
      [id]
    );

    res.json({ success: true });
  } catch (err) {
    console.error("Erreur refuse news :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}
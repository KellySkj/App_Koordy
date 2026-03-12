import { pool } from "../config/db.js";
import { getPermissions } from "../services/permission.service.js";

const PRESENCE_STATES = ["PRESENT", "ABSENT", "PEUT_ETRE"];

export async function createEvent(req, res) {
  const {
    id_association,
    id_auteur,
    titre_evenement,
    type_evenement,
    description_evenement,
    lieu_event,
    date_debut_event,
    date_fin_event,
  } = req.body;

  if (
    !id_association ||
    !id_auteur ||
    !titre_evenement ||
    !type_evenement ||
    !date_debut_event
  ) {
    return res.status(400).json({ message: "Champs obligatoires manquants." });
  }

  const { permissions } = await getPermissions(id_association, id_auteur);
  if (!permissions.canCreateEvent) {
    return res.status(403).json({ message: "Droits insuffisants pour créer un événement." });
  }

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const evRes = await client.query(
      `INSERT INTO evenement
       (id_association, titre_evenement, type_evenement, description_evenement, lieu_event, date_debut_event, date_fin_event)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id_evenement`,
      [
        Number(id_association),
        titre_evenement,
        type_evenement,
        description_evenement || "",
        lieu_event || "",
        date_debut_event,
        date_fin_event || null,
      ]
    );

    const id_evenement = evRes.rows[0].id_evenement;

    await client.query(
      `INSERT INTO actualite
       (id_association, id_auteur, type_actualite, titre, contenu, date_publication, statut, id_evenement, event_date, image_principale)
       VALUES ($1, $2, 'Evenement', $3, $4, NOW(), 'Approuve', $5, $6, NULL)`,
      [
        Number(id_association),
        Number(id_auteur),
        titre_evenement,
        description_evenement || "",
        id_evenement,
        date_debut_event,
      ]
    );

    await client.query("COMMIT");

    return res.status(201).json({
      success: true,
      id_evenement,
      event: {
        id_evenement,
        id_association: Number(id_association),
        titre_evenement,
        type_evenement,
        description_evenement: description_evenement || "",
        lieu_event: lieu_event || "",
        date_debut_event,
        date_fin_event: date_fin_event || null,
      },
    });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Erreur création event:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  } finally {
    client.release();
  }
}

export async function createConvocations(req, res) {
  const { id_evenement } = req.params;
  const { id_association, id_membre_actor, membres } = req.body;

  if (!id_association || !id_membre_actor || !Array.isArray(membres) || membres.length === 0) {
    return res.status(400).json({ message: "Champs manquants (id_association, id_membre_actor, membres[])." });
  }

  const { permissions } = await getPermissions(id_association, id_membre_actor);
  if (!permissions.canCreateEvent) {
    return res.status(403).json({ message: "Droits insuffisants." });
  }

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const evResult = await client.query(
      `SELECT id_association
       FROM evenement
       WHERE id_evenement = $1
       LIMIT 1`,
      [Number(id_evenement)]
    );

    if (
      !evResult.rows.length ||
      Number(evResult.rows[0].id_association) !== Number(id_association)
    ) {
      await client.query("ROLLBACK");
      return res.status(404).json({ message: "Événement introuvable pour cette association." });
    }

    const ids = [...new Set(membres.map(Number))].filter(Boolean);

    if (ids.length === 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Aucun membre valide." });
    }

    const placeholders = ids.map((_, index) => `$${index + 2}`).join(", ");

    const validResult = await client.query(
      `SELECT id_membre
       FROM membre_asso
       WHERE id_association = $1
         AND id_membre IN (${placeholders})`,
      [Number(id_association), ...ids]
    );

    const validSet = new Set(validResult.rows.map((r) => Number(r.id_membre)));

    for (const id_membre of ids) {
      if (!validSet.has(id_membre)) continue;

      await client.query(
        `INSERT INTO participation (id_evenement, id_membre, presence)
         VALUES ($1, $2, 'EN_ATTENTE')
         ON CONFLICT (id_evenement, id_membre)
         DO NOTHING`,
        [Number(id_evenement), id_membre]
      );
    }

    await client.query("COMMIT");
    return res.json({ success: true });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("convocations error:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  } finally {
    client.release();
  }
}

export async function getEventParticipants(req, res) {
  const { id_evenement } = req.params;

  try {
    const result = await pool.query(
      `SELECT
          m.id_membre,
          m.prenom_membre,
          m.nom_membre,
          p.presence
       FROM participation p
       JOIN membre m ON m.id_membre = p.id_membre
       WHERE p.id_evenement = $1
       ORDER BY m.prenom_membre`,
      [Number(id_evenement)]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur participants événement :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function updatePresence(req, res) {
  const { id_evenement } = req.params;
  const { id_membre, presence } = req.body;

  if (!id_membre || !PRESENCE_STATES.includes(presence)) {
    return res.status(400).json({ message: "Statut invalide." });
  }

  try {
    const result = await pool.query(
      `UPDATE participation
       SET presence = $1
       WHERE id_evenement = $2 AND id_membre = $3`,
      [presence, Number(id_evenement), Number(id_membre)]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Convocation introuvable." });
    }

    res.json({ success: true });
  } catch (err) {
    console.error("Erreur update présence :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}
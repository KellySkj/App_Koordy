import { pool } from "../config/db.js";
import {
  getPermissions,
  getRoleInAssociation,
  normalizeRole,
} from "../services/permission.service.js";

export async function getAssociationById(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      "SELECT * FROM association WHERE id_association = $1",
      [id]
    );

    res.json(result.rows[0] || {});
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getConseilAssociation(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT m.id_membre, m.nom_membre, m.prenom_membre, ma.role, ma.conseil_asso
       FROM membre_asso ma
       JOIN membre m ON ma.id_membre = m.id_membre
       WHERE ma.id_association = $1 AND ma.conseil_asso = 1`,
      [id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur conseil association :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getMembresAssociation(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT m.id_membre, m.nom_membre, m.prenom_membre, ma.role
       FROM membre_asso ma
       JOIN membre m ON ma.id_membre = m.id_membre
       WHERE ma.id_association = $1`,
      [id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur membres association :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getAssociationEvents(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT *
       FROM evenement
       WHERE id_association = $1
       ORDER BY date_debut_event ASC`,
      [id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur événements association :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getAssociationPermissions(req, res) {
  const { id, id_membre } = req.params;

  try {
    const data = await getPermissions(id, id_membre);
    return res.json({
      role: data.role,
      ...data.permissions,
    });
  } catch (err) {
    console.error("Erreur permissions:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function updateMemberRole(req, res) {
  const { id_association, id_membre } = req.params;
  const { role, id_membre_actor } = req.body;

  if (!id_membre_actor) {
    return res.status(400).json({ message: "id_membre_actor manquant." });
  }

  const newRole = normalizeRole(role);

  try {
    const actor = await getPermissions(id_association, id_membre_actor);
    if (!actor.permissions.canEditMemberRole) {
      return res.status(403).json({ message: "Droits insuffisants pour modifier les rôles." });
    }

    const targetRole = await getRoleInAssociation(id_association, id_membre);
    if (!targetRole) {
      return res.status(404).json({ message: "Membre non trouvé dans cette association." });
    }

    if (targetRole === "OWNER" && newRole !== "OWNER") {
      const ownersResult = await pool.query(
        `SELECT COUNT(*) AS c
         FROM membre_asso
         WHERE id_association = $1 AND UPPER(role) = 'OWNER'`,
        [Number(id_association)]
      );

      if (Number(ownersResult.rows[0]?.c || 0) <= 1) {
        return res.status(400).json({ message: "Impossible : il doit rester au moins un OWNER." });
      }
    }

    await pool.query(
      `UPDATE membre_asso
       SET role = $1
       WHERE id_association = $2 AND id_membre = $3`,
      [newRole, Number(id_association), Number(id_membre)]
    );

    return res.json({ message: "Rôle mis à jour", role: newRole });
  } catch (err) {
    console.error("Erreur update role:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function inviteMemberToAssociation(req, res) {
  const { id_association } = req.params;
  const { email, role, id_membre_actor } = req.body;

  if (!id_membre_actor || !email) {
    return res.status(400).json({ message: "Champs manquants (id_membre_actor, email)." });
  }

  try {
    const actor = await getPermissions(id_association, id_membre_actor);
    if (!actor.permissions.canInviteMember) {
      return res.status(403).json({ message: "Droits insuffisants pour inviter des membres." });
    }

    const usersResult = await pool.query(
      `SELECT id_membre
       FROM membre
       WHERE mail_membre = $1
       LIMIT 1`,
      [email.trim()]
    );

    if (!usersResult.rows.length) {
      return res.status(404).json({
        message: "Ce mail n'a pas encore de compte. La personne doit s'inscrire avant d'être ajoutée."
      });
    }

    const id_membre_invite = usersResult.rows[0].id_membre;

    const alreadyInOneResult = await pool.query(
      `SELECT id_association
       FROM membre_asso
       WHERE id_membre = $1
       LIMIT 1`,
      [Number(id_membre_invite)]
    );

    if (alreadyInOneResult.rows.length > 0) {
      return res.status(409).json({
        message: "Ce membre appartient déjà à une association. Il doit d'abord quitter son association actuelle."
      });
    }

    const existsResult = await pool.query(
      `SELECT id_membre_asso
       FROM membre_asso
       WHERE id_association = $1 AND id_membre = $2
       LIMIT 1`,
      [Number(id_association), Number(id_membre_invite)]
    );

    if (existsResult.rows.length) {
      return res.status(409).json({ message: "Ce membre est déjà dans l'association." });
    }

    const invitedRole = normalizeRole(role || "MEMBRE");

    await pool.query(
      `INSERT INTO membre_asso
       (role, date_adhesion, id_association, id_membre, conseil_asso)
       VALUES ($1, CURRENT_DATE, $2, $3, 0)`,
      [invitedRole, Number(id_association), Number(id_membre_invite)]
    );

    return res.json({
      message: "Membre ajouté à l'association.",
      id_membre: id_membre_invite,
      role: invitedRole,
    });
  } catch (err) {
    console.error("Erreur invite:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function getAssociationNews(req, res) {
  const id = req.params.id;

  try {
    const result = await pool.query(
      `SELECT *
       FROM actualite
       WHERE id_association = $1
         AND statut = 'Approuve'
       ORDER BY COALESCE(date_publication, date_creation) DESC`,
      [id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur news:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}

export async function createAssociation(req, res) {
  const {
    id_membre,
    nom,
    type_structure,
    sport,
    adresse,
    adresse_2,
    description,
    date_creation,
    code_postal,
    ville,
    pays,
    image,
  } = req.body;

  if (!id_membre) {
    return res.status(400).json({ message: "id_membre manquant (créateur)." });
  }

  if (
    !nom ||
    !type_structure ||
    !sport ||
    !adresse ||
    !date_creation ||
    !code_postal ||
    !ville ||
    !pays
  ) {
    return res.status(400).json({ message: "Champs requis manquants." });
  }

  const couleur_1 = "#000000";
  const couleur_2 = "#000000";

  const client = await pool.connect();

  try {
    const alreadyResult = await client.query(
      `SELECT id_association
       FROM membre_asso
       WHERE id_membre = $1
       LIMIT 1`,
      [Number(id_membre)]
    );

    if (alreadyResult.rows.length > 0) {
      return res.status(409).json({
        message: "Vous êtes déjà membre d'une association. Quittez-la avant d'en créer une autre."
      });
    }

    await client.query("BEGIN");

    const result = await client.query(
      `INSERT INTO association
       (nom, type_structure, sport, adresse, adresse_2, description, date_creation, image, code_postal, ville, pays, couleur_1, couleur_2)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING id_association`,
      [
        nom,
        type_structure,
        sport,
        adresse,
        adresse_2 || "",
        description || "",
        date_creation,
        image || "",
        code_postal,
        ville,
        pays,
        couleur_1,
        couleur_2,
      ]
    );

    const idAssociation = result.rows[0].id_association;

    await client.query(
      `INSERT INTO membre_asso
       (role, date_adhesion, id_association, id_membre, conseil_asso)
       VALUES ($1, CURRENT_DATE, $2, $3, $4)`,
      ["OWNER", idAssociation, id_membre, 0]
    );

    await client.query("COMMIT");

    return res.status(201).json({
      message: "Informations enregistrées",
      id_association: idAssociation,
    });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Erreur création asso/lien membre_asso:", err);
    return res.status(500).json({ message: "Erreur serveur" });
  } finally {
    client.release();
  }
}

export async function updateAssociationDesign(req, res) {
  const { couleur_1, couleur_2, image } = req.body;
  const id = req.params.id;

  if (!couleur_1 || !couleur_2) {
    return res.status(400).json({ message: "Couleurs manquantes." });
  }

  try {
    await pool.query(
      `UPDATE association
       SET couleur_1 = $1, couleur_2 = $2, image = $3
       WHERE id_association = $4`,
      [couleur_1, couleur_2, image || "", id]
    );

    return res.status(200).json({ message: "Design mis à jour." });
  } catch (err) {
    console.error("Erreur SQL :", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
}

export async function searchAssociation(req, res) {
  const nom = req.query.nom?.trim();

  if (!nom) {
    return res.json([]);
  }

  try {
    const result = await pool.query(
      `SELECT
         id_association,
         nom,
         sport,
         ville,
         type_structure
       FROM association
       WHERE LOWER(nom) LIKE LOWER($1)`,
      [`%${nom}%`]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Erreur recherche association :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
}
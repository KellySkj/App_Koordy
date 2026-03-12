import { pool } from "../config/db.js";

export const ALLOWED_ROLES = [
  "OWNER",
  "PRESIDENT",
  "SECRETAIRE",
  "TRESORIER",
  "MEMBRE",
];

export const ROLE_PERMISSIONS = {
  OWNER: {
    canCreateEvent: true,
    canEditEvent: true,
    canDeleteEvent: true,
    canCreateNews: true,
    canInviteMember: true,
    canApproveMember: true,
    canEditMemberRole: true,
  },
  PRESIDENT: {
    canCreateEvent: true,
    canEditEvent: true,
    canDeleteEvent: true,
    canCreateNews: true,
    canInviteMember: true,
    canApproveMember: true,
    canEditMemberRole: true,
  },
  SECRETAIRE: {
    canCreateEvent: true,
    canEditEvent: true,
    canDeleteEvent: false,
    canCreateNews: true,
    canInviteMember: true,
    canApproveMember: false,
    canEditMemberRole: false,
  },
  TRESORIER: {
    canCreateEvent: true,
    canEditEvent: true,
    canDeleteEvent: false,
    canCreateNews: true,
    canInviteMember: false,
    canApproveMember: false,
    canEditMemberRole: false,
  },
  MEMBRE: {
    canCreateEvent: false,
    canEditEvent: false,
    canDeleteEvent: false,
    canCreateNews: false,
    canInviteMember: false,
    canApproveMember: false,
    canEditMemberRole: false,
  },
};

export function normalizeRole(role) {
  const r = (role || "").toUpperCase().trim();
  return ALLOWED_ROLES.includes(r) ? r : "MEMBRE";
}

export async function getRoleInAssociation(id_association, id_membre) {
  const result = await pool.query(
    `SELECT role FROM membre_asso
     WHERE id_association = $1 AND id_membre = $2
     LIMIT 1`,
    [Number(id_association), Number(id_membre)]
  );

  const rows = result.rows;

  if (!rows.length) return null;
  return normalizeRole(rows[0].role);
}

export async function getPermissions(id_association, id_membre) {
  const role = await getRoleInAssociation(id_association, id_membre);

  if (!role) {
    return {
      role: null,
      permissions: ROLE_PERMISSIONS.MEMBRE,
    };
  }

  return {
    role,
    permissions: ROLE_PERMISSIONS[role] || ROLE_PERMISSIONS.MEMBRE,
  };
}
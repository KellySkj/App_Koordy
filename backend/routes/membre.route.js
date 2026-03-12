import express from "express";
import {
  getMembreById,
  updateMembre,
  getMembreEquipes,
  getMembreAssociation,
  getMembreInvitations,
} from "../controllers/membre.controller.js";

const router = express.Router();

router.get("/membre/:id", getMembreById);
router.put("/membre/:id", updateMembre);
router.get("/membre/:id/equipes", getMembreEquipes);
router.get("/membre/:id/association", getMembreAssociation);
router.get("/membre/:id_membre/invitations", getMembreInvitations);

export default router;
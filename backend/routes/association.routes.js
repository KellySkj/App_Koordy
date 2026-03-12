import express from "express";
import {
  getAssociationById,
  getConseilAssociation,
  getMembresAssociation,
  getAssociationEvents,
  getAssociationPermissions,
  updateMemberRole,
  inviteMemberToAssociation,
  getAssociationNews,
  createAssociation,
  updateAssociationDesign,
  searchAssociation,
} from "../controllers/association.controller.js";

const router = express.Router();

router.get("/associations/:id", getAssociationById);
router.get("/associations/:id/conseil", getConseilAssociation);
router.get("/associations/:id/membres", getMembresAssociation);
router.get("/associations/:id/events", getAssociationEvents);
router.get("/associations/:id/permissions/:id_membre", getAssociationPermissions);
router.put("/associations/:id_association/membres/:id_membre/role", updateMemberRole);
router.post("/associations/:id_association/invite", inviteMemberToAssociation);
router.get("/associations/:id/news", getAssociationNews);

router.post("/association", createAssociation);
router.put("/association/design/:id", updateAssociationDesign);
router.get("/association/search", searchAssociation);

export default router;

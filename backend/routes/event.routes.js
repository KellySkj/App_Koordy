import express from "express";
import {
  createEvent,
  createConvocations,
  getEventParticipants,
  updatePresence,
} from "../controllers/event.controller.js";

const router = express.Router();

router.post("/evenements", createEvent);
router.post("/evenements/:id_evenement/convocations", createConvocations);
router.get("/evenements/:id_evenement/participants", getEventParticipants);
router.patch("/evenements/:id_evenement/presence", updatePresence);

export default router;

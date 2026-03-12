import express from "express";
import { inscription, login } from "../controllers/auth.controller.js";

const router = express.Router();

router.post("/inscription", inscription);
router.post("/login", login);

export default router;
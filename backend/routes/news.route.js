import express from "express";
import {
  createNews,
  approveNews,
  refuseNews,
} from "../controllers/news.controller.js";

const router = express.Router();

router.post("/news", createNews);
router.patch("/news/:id/approve", approveNews);
router.patch("/news/:id/refuse", refuseNews);

export default router;
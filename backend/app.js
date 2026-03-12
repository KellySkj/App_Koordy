import cors from "cors";
import express from "express";

import authRoutes from "./routes/auth.routes.js";
import associationRoutes from "./routes/association.routes.js";
import membreRoutes from "./routes/membre.routes.js";
import eventRoutes from "./routes/event.routes.js";
import newsRoutes from "./routes/news.routes.js";

const app = express();
const port = 8080;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api", authRoutes);
app.use("/api", associationRoutes);
app.use("/api", membreRoutes);
app.use("/api", eventRoutes);
app.use("/api", newsRoutes);

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
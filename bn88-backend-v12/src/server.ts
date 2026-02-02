// src/server.ts
process.on("unhandledRejection", (err) =>
  console.error("[UNHANDLED REJECTION]", err)
);
process.on("uncaughtException", (err) =>
  console.error("[UNCAUGHT EXCEPTION]", err)
);

import dotenv from "dotenv";
dotenv.config();

import express, {
  type Request,
  type Response,
  type NextFunction,
} from "express";
import * as path from "node:path";
import cors from "cors";
import morgan from "morgan";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import compression from "compression";
import { ZodError } from "zod";
import cookieParser from "cookie-parser";

import { config } from "./config";
import { logger } from "./mw/logger";
import { authGuard } from "./mw/auth";
import { sseHandler } from "./live";
import { metricsSseHandler, metricsStreamHandler } from "./routes/metrics.live";

import { startEngagementScheduler } from "./services/engagementScheduler";
import { startCampaignScheduleWorker } from "./queues/campaign.queue";
import { startMessageWorker } from "./queues/message.queue";

/* Core routes */
import health from "./routes/health";
import authRoutes from "./routes/auth";
import casesRoutes from "./routes/cases";
import statsRoutes from "./routes/stats";
import botsRoutes from "./routes/bots";
import botsSummary from "./routes/bots.summary";
import devRoutes from "./routes/dev";
import lineTools from "./routes/tools/line";
import aiAnswerRoute from "./routes/ai/answer";
import events from "./routes/events";

/* Webhooks */
import lineWebhookRouter from "./routes/webhooks/line";
import telegramWebhookRouter from "./routes/webhooks/telegram";
import facebookWebhookRouter from "./routes/webhooks/facebook";

/* Admin */
import adminAuthRoutes from "./routes/admin/auth";
import adminBotsRouter from "./routes/admin/bots";
import adminBotIntentsRouter from "./routes/admin/botIntents";
import adminRouter from "./routes/admin";
import presetsAdmin from "./routes/admin/ai/presets";
import knowledgeAdmin from "./routes/admin/ai/knowledge";
import adminPersonaRoutes from "./routes/admin/personas";
import { chatAdminRouter } from "./routes/admin/chat";
import lepAdminRouter from "./routes/admin/lep";
import { telegramLiveAdminRouter } from "./routes/admin/telegramLive";
import adminRolesRouter from "./routes/admin/roles";
import botAutomationRouter from "./routes/admin/botAutomation";
import adminFaqRouter from "./routes/admin/faq";
import adminUploadsRouter from "./routes/admin/uploads";

const app = express();
app.set("trust proxy", 1);

const webhookBaseUrl = (process.env.WEBHOOK_BASE_URL || "").trim();
if (webhookBaseUrl) {
  const lower = webhookBaseUrl.toLowerCase();
  const isHttp = lower.startsWith("http://");
  const isLocal =
    lower.includes("localhost") ||
    lower.includes("127.0.0.1") ||
    lower.includes("0.0.0.0");
  if (isHttp || isLocal) {
    console.warn(
      `[WARN] LINE webhook requires HTTPS. WEBHOOK_BASE_URL=${webhookBaseUrl} is not public HTTPS. ` +
        "Use a tunnel (cloudflared tunnel --url http://localhost:3000)."
    );
  }
}

/* Workers */
startCampaignScheduleWorker();
startMessageWorker();

/* simple probes */
app.get("/", (_req, res) => res.send("ok"));
app.get("/health", (_req, res) => res.redirect("/api/health"));

/* ✅ Serve uploads (ครั้งเดียวพอ) */
app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));
app.use("/api/uploads", express.static(path.join(process.cwd(), "uploads")));

/* ---------- Body parsers ---------- */
/**
 * ✅ LINE ต้องใช้ raw body เพื่อ verify signature
 * ต้องอยู่ก่อน express.json()
 */
app.use(
  "/api/webhooks/line",
  express.raw({
    type: "application/json",
    verify: (req, _res, buf) => {
      (req as any).rawBody = buf;
    },
  })
);

/* parsers ทั่วไป (ยกเว้น LINE webhook เพื่อคง raw body ไว้) */
app.use((req, res, next) => {
  if (req.path.startsWith("/api/webhooks/line")) return next();
  return express.json({ limit: "1mb" })(req, res, next);
});
app.use((req, res, next) => {
  if (req.path.startsWith("/api/webhooks/line")) return next();
  return express.urlencoded({ extended: false, limit: "200kb" })(
    req,
    res,
    next
  );
});
app.use(cookieParser());

app.use((err: any, _req: Request, res: Response, next: NextFunction) => {
  if (err?.type === "entity.too.large") {
    return res.status(413).json({ ok: false, message: "payload_too_large" });
  }
  if (err?.type === "entity.parse.failed") {
    return res.status(400).json({ ok: false, message: "invalid_json" });
  }
  return next(err);
});

/* Security / CORS / Log */
const allowList = new Set(
  (config.ALLOWED_ORIGINS || "")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)
);

app.use(
  helmet({
    contentSecurityPolicy: false,
    crossOriginResourcePolicy: { policy: "cross-origin" },
  })
);

app.use(
  cors({
    origin: (origin, cb) => {
      if (!origin || allowList.has(origin)) return cb(null, true);
      return cb(null, false);
    },
    credentials: true,
    methods: ["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "x-tenant"],
  })
);

app.use(morgan("dev"));
app.use(logger);

/* Compression (skip SSE) */
app.use(
  compression({
    filter: (req, res) => {
      if (req.path.startsWith("/api/live/")) return false;
      return compression.filter(req, res as any);
    },
  })
);

/* Rate limit (mounted on /api) */
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 300,
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) =>
    req.path.startsWith("/webhooks/") ||
    req.path === "/health" ||
    req.path.startsWith("/live/") ||
    req.path.startsWith("/events") ||
    req.path.startsWith("/admin/chat"),
});
app.use("/api", limiter);

/* Health */
app.use("/api/health", health);
app.get("/api/health", (_req, res) =>
  res.json({
    ok: true,
    time: new Date().toISOString(),
    adminApi: true,
  })
);

/* Dev & tools */
app.use("/api", devRoutes);
app.use("/api", lineTools);
app.use("/api", events);

/* Core */
app.use("/api/auth", authRoutes);
app.use("/api/bots", botsRoutes);
app.use("/api/bots", botsSummary);
app.use("/api/cases", casesRoutes);
app.use("/api/stats", statsRoutes);
app.use("/api/ai/answer", aiAnswerRoute);

/* Realtime */
app.get("/api/live/:tenant", authGuard, sseHandler);
app.get("/api/live/metrics", metricsSseHandler);
app.get("/metrics/stream", metricsStreamHandler);

startEngagementScheduler().catch((err) =>
  console.error("[BOOT] engagement scheduler error", err)
);

/* Webhooks */
app.use("/api/webhooks/line", lineWebhookRouter);
app.use("/api/webhooks/facebook", facebookWebhookRouter);
app.use("/api/webhooks/telegram", telegramWebhookRouter);

/* Admin */
app.use("/api/admin/uploads", adminUploadsRouter);

if (config.ENABLE_ADMIN_API === "1") {
  console.log("[BOOT] Admin API enabled (guarded by JWT)");

  // ✅ public
  app.use("/api/admin/auth", adminAuthRoutes);

  // ✅ guarded
  app.use("/api/admin/faq", authGuard, adminFaqRouter);
  app.use("/api/admin/bots", authGuard, adminBotsRouter);
  app.use("/api/admin/bots", authGuard, adminBotIntentsRouter);
  app.use("/api/admin/chat", authGuard, chatAdminRouter);
  app.use("/api/admin/lep", authGuard, lepAdminRouter);
  app.use("/api/admin/telegram", authGuard, telegramLiveAdminRouter);
  app.use("/api/admin/roles", authGuard, adminRolesRouter);
  app.use("/api/admin/bot", authGuard, botAutomationRouter);

  app.use("/api/admin/ai/presets", authGuard, presetsAdmin);
  app.use("/api/admin/ai/knowledge", authGuard, knowledgeAdmin);
  app.use("/api/admin/ai/personas", authGuard, adminPersonaRoutes);

  // ✅ mount adminRouter ครั้งเดียว
  app.use("/api/admin", authGuard, adminRouter);
}

/* 404 & Errors */
app.use("/api", (_req: Request, res: Response) => {
  res.status(404).json({ ok: false, message: "not_found" });
});

app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof ZodError) {
    return res
      .status(400)
      .json({ ok: false, message: "invalid_input", issues: err.issues });
  }
  if (err?.type === "entity.parse.failed" || err instanceof SyntaxError) {
    return res.status(400).json({ ok: false, message: "invalid_json" });
  }
  console.error("[INTERNAL ERROR]", err);
  return res.status(500).json({ ok: false, message: "internal_error" });
});

const HOST = (process.env.HOST || "0.0.0.0").trim() || "0.0.0.0";
const PORT_ENV = (process.env.PORT || "").trim();
const PORT = Number(PORT_ENV || config.PORT || 3000);
const REDIS_URL =
  process.env.REDIS_URL ||
  (process.env.REDIS_PORT ? `redis://127.0.0.1:${process.env.REDIS_PORT}` : "");
const REDIS_PORT = process.env.REDIS_PORT || "";

app.listen(PORT, HOST, () => {
  console.log(
    `[BOOT] listening on http://${HOST}:${PORT} (PORT env=${PORT_ENV || "n/a"})`
  );
  console.log("[env]", { HOST, PORT, REDIS_URL, REDIS_PORT });
});

export default app;

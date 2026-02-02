import { Router } from "express";
import { createClient } from "redis";
const router = Router();

router.get("/", (_req, res) => {
  res.json({ ok: true, time: new Date().toISOString(), adminApi: process.env.ENABLE_ADMIN_API === "1" });
});

router.get("/redis", async (_req, res) => {
  const redisUrl =
    process.env.REDIS_URL ||
    (process.env.REDIS_PORT ? `redis://127.0.0.1:${process.env.REDIS_PORT}` : "");

  if (!redisUrl) {
    return res.json({
      ok: false,
      enabled: false,
      message: "redis_disabled",
    });
  }

  const startedAt = Date.now();
  const client = createClient({ url: redisUrl });
  try {
    await client.connect();
    await client.quit();
    return res.json({
      ok: true,
      url: redisUrl,
      latencyMs: Date.now() - startedAt,
    });
  } catch (e: any) {
    try {
      await client.quit();
    } catch {
      // ignore
    }
    return res.json({
      ok: false,
      url: redisUrl,
      error: String(e?.message ?? e),
    });
  }
});

export default router;




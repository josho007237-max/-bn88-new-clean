// src/middleware/authGuard.ts
import type { Request, Response, NextFunction } from "express";
import { verifyJwt } from "../lib/jwt";

export type AuthPayload = {
  sub: string;
  email: string;
  roles: string[];
  tokenType?: string;
};

type TokenSource = "header" | "cookie" | "query" | "none";

const QUERY_TOKEN_ALLOWED_PREFIXES = ["/api/live/", "/api/admin/chat/line-content/"];

function isQueryTokenAllowed(req: Request): boolean {
  const url = (req.originalUrl || req.url || "").trim();
  return QUERY_TOKEN_ALLOWED_PREFIXES.some((prefix) => url.startsWith(prefix));
}

function readQueryToken(req: Request): string {
  if (!req.query?.token) return "";
  const queryTokenRaw = req.query.token;
  return typeof queryTokenRaw === "string"
    ? queryTokenRaw.trim()
    : Array.isArray(queryTokenRaw)
    ? String(queryTokenRaw[0] ?? "").trim()
    : "";
}

function readCookieToken(req: Request): string {
  const cookies = (req as any).cookies;
  return typeof cookies?.bn88_token === "string" ? cookies.bn88_token.trim() : "";
}

function getToken(req: Request): {
  token: string;
  raw: string;
  source: TokenSource;
  queryProvided: boolean;
  queryAllowed: boolean;
} {
  const rawHeader = String(req.headers.authorization || req.get("authorization") || "");
  if (rawHeader) {
    const lower = rawHeader.toLowerCase();
    if (lower.startsWith("bearer ")) {
      return {
        token: rawHeader.slice(7).trim(),
        raw: rawHeader.trim(),
        source: "header",
        queryProvided: false,
        queryAllowed: false,
      };
    }
    return {
      token: "",
      raw: rawHeader.trim(),
      source: "header",
      queryProvided: false,
      queryAllowed: false,
    };
  }

  const queryToken = readQueryToken(req);
  const queryProvided = Boolean(queryToken);
  const queryAllowed = queryProvided ? isQueryTokenAllowed(req) : false;
  if (queryToken && queryAllowed) {
    return { token: queryToken, raw: "", source: "query", queryProvided, queryAllowed };
  }

  const cookieToken = readCookieToken(req);
  if (cookieToken) {
    return { token: cookieToken, raw: "", source: "cookie", queryProvided, queryAllowed };
  }

  return { token: "", raw: "", source: "none", queryProvided, queryAllowed };
}

export function authGuard(req: Request, res: Response, next: NextFunction) {
  const route = `${req.method} ${req.originalUrl || req.url}`.trim();
  const tenant = ((req.headers["x-tenant"] as string | undefined) ?? "").trim() || undefined;
  const DEBUG_AUTH_LOG = process.env.DEBUG_AUTH === "1";
  const { token, raw, source, queryProvided, queryAllowed } = getToken(req);
  const hasAuthHeader = source === "header";
  const authHeaderPrefix = hasAuthHeader ? raw.split(/\s+/)[0] : undefined;
  const tokenPartsCount = token ? token.split(".").length : 0;

  const logAuthDebug = (reason: string) => {
    if (!DEBUG_AUTH_LOG) return;
    console.info("[DEBUG_AUTH]", reason, {
      path: route,
      tenant,
      hasAuthHeader,
      authHeaderPrefix,
      tokenPartsCount,
      tokenSource: source,
      queryProvided,
      queryAllowed,
    });
  };

  if (queryProvided && !queryAllowed && source === "none") {
    logAuthDebug("query_token_not_allowed");
  }

  if (!token) {
    logAuthDebug("missing_token");
    return res.status(401).json({ ok: false, error: "invalid_token" });
  }

  if (tokenPartsCount !== 3) {
    logAuthDebug("malformed_token");
    return res
      .status(401)
      .json({ ok: false, error: "invalid_token", reason: "malformed" });
  }

  try {
    const payload = verifyJwt<AuthPayload>(token);
    const session = { ...payload, id: payload.sub } as AuthPayload & { id: string };

    (req as any).auth = session;
    (req as any).admin = session;
    return next();
  } catch (err) {
    logAuthDebug("invalid_signature");
    console.error("authGuard invalid token:", err);
    return res.status(401).json({ ok: false, error: "invalid_token" });
  }
}


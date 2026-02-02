// src/mw/auth.ts
import { authGuard as baseAuthGuard, type AuthPayload } from "../middleware/authGuard";

export type AdminSession = AuthPayload & { id: string };

declare module "express-serve-static-core" {
  interface Request {
    auth?: AdminSession;
    admin?: AdminSession;
  }
}

export { baseAuthGuard as authGuard };
export type { AuthPayload };

# WORKPLAN MASTER

รวบรวมมุมมองสำคัญก่อนลงมือเพิ่มความสเถียรบนโปรเจกต์ BN88-new-clean (bn88-backend-v12 + bn88-frontend-dashboard-v12 + line-engagement-platform) โดยเน้นความเข้าใจโครงสร้างจริงจากไฟล์ที่กำหนดไว้แล้วขึ้นแผนงานตาม Phase 0 → Phase 11

## Table of Contents
1. [Architecture Overview (Inbound / Outbound + Ports)](#architecture-overview)
2. [Work Status (Done / Doing / Blocked)](#work-status)
3. [Master Worklist Phase 0 → Phase 11](#master-worklist-phase-0-→-phase-11)
4. [PowerShell Quick Checks by Phase](#powershell-quick-checks-by-phase)
5. [P0 Critical Files to Modify](#p0-critical-files-to-modify)

## Architecture Overview

### Inbound flows
- **LINE webhook (`POST /api/webhooks/line`, optional `/:tenant/:botId`)** lives in `src/routes/webhooks/line.ts`. It verifies `x-line-signature` via `createLineSignature`, resolves the active `Bot` + `BotSecret`/`BotConfig` (Prisma models), parses events, streams SSE via `sseHub`, stores chat data (ChatSession, ChatMessage, ImageIntake, CaseItem), and replies through the LINE REST API using `channelAccessToken`. The raw body hook is declared in `src/server.ts` before `express.json`.
- **Admin API guard** uses `src/middleware/authGuard.ts` (JWT parsed by `verifyJwt`) and `requirePermission` from `src/middleware/basicAuth.ts` for RBAC (roles → permission map + optional Prisma lookup). These middleware layers protect routes under `src/routes/admin/*` (e.g., `/api/admin/chat`, `/api/admin/bots`, `/api/admin/roles`) and propagate `req.auth` for downstream helpers such as `ChatCenter` SSE and `line-content`.
- **SSE bridge (`GET /api/live/:tenant`)** is implemented in `src/live.ts` + `src/lib/sseHub.ts`, shared between webhook broadcasts and `ChatCenter` (frontend uses `connectEvents` in `src/lib/events.ts`). SSE streams `case:new`, `chat:message:new`, `stats:update`, etc., keyed by tenant.

### Outbound flows
- **Admin chat media**: `/api/admin/chat/line-content/:id` (guarded by `requirePermission`) proxies LINE content using the bot’s `channelAccessToken` and responds with the original headers so the dashboard can render `<img>`/download via `getLineContentBlob` / `getLineContentUrl` in `bn88-frontend-dashboard-v12/src/lib/api.ts`.
- **LINE replies + quick replies**: `buildQuickReplyMenu` (ts) + `lineReply` send outgoing text, while `processActivityImageMessage` may add bot replies after SSE/DB updates.
- **Frontend dashboard**: `ChatCenter.tsx` calls APIs from `src/lib/api.ts` (bots, sessions, SSE). The dashboard enforces token on uploads via `withToken`, attaches `"x-tenant"` from env, and reuses SSE helper `connectEvents` to hit `/api/live/:tenant`. Image downloads use `/api/admin/chat/line-content/:id`.
- **LEP (`line-engagement-platform`)** is expected to answer on port 8080 (health `GET /health`) and is mentioned in runbooks as part of Phase 0 stability checks.

### Port / Endpoint Map
| Port | Endpoint | Purpose | Primary Files |
| --- | --- | --- | --- |
| `3000` (default `config.PORT`) | `/api/webhooks/line[/:tenant/:botId]` | Receive LINE events, verify signature, store ChatSession/ChatMessage/ImageIntake, emit SSE (Inbound). | `src/server.ts`, `src/routes/webhooks/line.ts`, `src/lib/prisma.ts`, `src/lib/sseHub.ts` |
| `3000` | `/api/live/:tenant` | SSE connection for dashboard, reused by webhook broadcasts (Outbound). | `src/live.ts`, `src/lib/sseHub.ts`, `bn88-frontend-dashboard-v12/src/lib/events.ts` |
| `3000` | `/api/admin/...` | Guarded admin REST surface (`/chat`, `/bots`, `/roles`, `/auth`, etc.). | `src/routes/admin/*`, `src/middleware/authGuard.ts`, `src/middleware/basicAuth.ts` |
| `3000` | `/api/admin/chat/line-content/:id` | Fetch LINE image/file via LINE API with token, serve inline Content-Disposition (Outbound). | `src/routes/admin/chat.ts`, `bn88-frontend-dashboard-v12/src/lib/api.ts`, `bn88-backend-v12/src/lib/prisma.ts` |
| `5555` (frontend) | `/` | React dashboard served by `npm run dev` (default Vite, needs `getApiBase`). | `bn88-frontend-dashboard-v12/src/pages/ChatCenter.tsx`, `src/lib/api.ts` |
| `8080` | `/health` | LINE Engagement Platform health probe referenced in runbooks. | `line-engagement-platform` directory (assumed). |
| `config.WEBHOOK_BASE_URL` | external | Used to warn when not HTTPS in `src/server.ts` and for quick reply `APP_BASE_URL` in `routes/webhooks/line.ts`. |

## Work Status

### Done
- Base Express config with cors/helmet/compression/rate limits is wired in `src/server.ts`, raw body hook for LINE is already in place, and SSE hub + workers start on boot. Prisma models for `Bot`, `BotSecret`, `BotConfig`, `ChatSession`, `ChatMessage`, `ImageIntake`, and `CaseItem` are established to support webhook flows.

### Doing
- Align JWT guard (`src/middleware/authGuard.ts`), RBAC (`src/middleware/basicAuth.ts`), and admin routers so each request has a single `req.auth` snapshot. This step touches `routes/admin/*` (e.g., `/chat`, `/bots`, `/roles`) because these all expect `requirePermission`.
- Drive frontend to include tokens on downloads (`bn88-frontend-dashboard-v12/src/lib/api.ts`), keep SSE alive (`ChatCenter.tsx`, `events.ts`), and ensure `/api/live/:tenant` path resolves with `getApiBase`.

### Blocked
1. **Dual auth surfaces:** admin JWT guard vs `requirePermission` create two distinct contexts; missing tokens or mismatched header/cookie sources still return 401 (see `authGuard.ts`, `basicAuth.ts`, and routers requiring `authGuard` + `requirePermission` in `routes/admin/chat.ts`). Need to unify token reading, error responses, and logging so P0 can use the same header for SSE, REST, and downloads.
2. **`/api/admin/chat/line-content/:id` 401:** route requires `requirePermission`, but SSE/ChatCenter or asset tags may not send Authorization or `x-tenant`. Dashboard uses `withToken` + `getLineContentUrl`, but Chrome still reports 401 because the HTML `<img>` request is missing the dashboard token or because the backend rejects due to RBAC. Need to ensure `getLineContentUrl` always appends `token` query, and the backend accepts `token`+`tenant` or fallback to cookie.
3. **LINE tunnel + HTTPS verification:** `src/server.ts` warns if `WEBHOOK_BASE_URL` is not HTTPS, and `routes/webhooks/line.ts` enforces signatures via `createLineSignature`. Until we have TLS/tunnel + valid `channelSecret`, the webhook responds `invalid_signature`. Need to confirm `WEBHOOK_BASE_URL` + `LINE_CHANNEL_SECRET`/`channelAccessToken` are from the correct bot version (P0 objective "LINE tunnel verify").

## Master Worklist Phase 0 → Phase 11
- [ ] **Phase 0 – Environment sanity.**
  - Acceptance: Backend + dashboard + LEP start locally (ports 3000, 5555, 8080) without dependency errors.
- [ ] **Phase 1 – Auth unification (jwt + RBAC).**
  - Acceptance: `authGuard` and `requirePermission` share one parsed payload; hitting any `/api/admin/*` with a valid token (from `login`) never returns 401; logs reference `requestId`.
- [ ] **Phase 2 – SSE/ChatCenter stabilization.**
  - Acceptance: `GET /api/live/:tenant` stays open, heartbeat from `sseHub`, `ChatCenter` receives `case:new` + `chat:message:new` when webhook stores data.
- [ ] **Phase 3 – line-content streaming.**
  - Acceptance: `/api/admin/chat/line-content/:id` returns PNG/JPG with original headers; dashboard loads `getLineContentBlob`/`fetchLineContentObjectUrl` without 401.
- [ ] **Phase 4 – LINE webhook signature + tunnel verification.**
  - Acceptance: `resolveBot` successfully loads `BotSecret`, signature check in `line.ts` passes, and `WEBHOOK_BASE_URL` warns only if config is insecure.
- [ ] **Phase 5 – Image flow + classification.**
  - Acceptance: Incoming `MessageType.IMAGE` triggers `fetchLineMessageContentBuffer`, `classifyImageBuffer`, `imageIntake`, and, when needed, `processActivityImageMessage` pipeline updates `CaseItem`.
- [ ] **Phase 6 – Admin chat payloads & rich replies.**
  - Acceptance: `/api/admin/chat/messages`, `/sessions/:id/messages`, `/rich-message` succeed with `requirePermission`; `ChatCenter` can `replyChatSession` and `sendRichMessage`.
- [ ] **Phase 7 – Bot config + secrets dashboard.**
  - Acceptance: `/api/bots/:id/secrets` returns masked values; UI can `getBots`, toggle `active`, and patch secrets (OpenAI, LINE) through `bn88-backend-v12/src/routes/admin/bots.ts`.
- [ ] **Phase 8 – Stats, metrics, and health.**
  - Acceptance: `/api/stats`, `/api/health`, `/api/admin/health` return 200; SSE emits `stats:update`.
- [ ] **Phase 9 – Engagement scheduler & workers.**
  - Acceptance: `campaign.queue` and `message.queue` workers start (see `src/queues`), `startEngagementScheduler` runs; logs show worker heartbeats.
- [ ] **Phase 10 – Frontend automation + live ops.**
  - Acceptance: `ChatCenter` automation tabs (`EngagementMessage`, `LiveQuestion`, `LivePoll`) query their APIs without 403/401.
- [ ] **Phase 11 – Release readiness / monitoring.**
  - Acceptance: Environment variables (`DATABASE_URL`, `REDIS_URL`, `LINE_CHANNEL_SECRET`, `LINE_CHANNEL_ACCESS_TOKEN`) validated on start; health check + SSE + `"metrics/stream"` accessible.

## PowerShell Quick Checks by Phase
- **Phase 0**
  1. `pwsh -Command 'npm --prefix .\bn88-backend-v12 run dev -- --version'`
  2. `pwsh -Command 'npm --prefix .\bn88-frontend-dashboard-v12 run dev -- --version'`
  3. `pwsh -Command 'curl.exe http://localhost:8080/health'`
- **Phase 1**
  4. `rg -n -F 'verifyJwt' bn88-backend-v12\src\middleware\authGuard.ts -S`
  5. `rg -n -F 'requirePermission' bn88-backend-v12\src\middleware\basicAuth.ts -S`
  6. `rg -n -F 'req.query.token' bn88-backend-v12\src -S | Out-File .\_rg_backend_querytoken.txt`
- **Phase 2**
  7. `pwsh -Command 'curl.exe http://localhost:3000/api/live/bn9 -H \"Accept:text/event-stream\"'`
- **Phase 3**
  8. `pwsh -Command 'Invoke-WebRequest http://localhost:3000/api/admin/chat/line-content/sample -Headers @{Authorization=\"Bearer <token>\"; \"x-tenant\"=\"bn9\"} -UseBasicParsing'`
- **Phase 4**
  9. `rg -n -F 'verifyLineSignature' bn88-backend-v12\src\routes\webhooks\line.ts -S`
 10. `rg -n -F 'WEBHOOK_BASE_URL' bn88-backend-v12\src\server.ts -S`
- **Phase 5**
 11. `rg -n -F 'processActivityImageMessage' bn88-backend-v12\src\services\activity\processActivityImageMessage.js -S`
 12. `rg -n -F 'ChatSession' bn88-backend-v12\src\lib\prisma.ts -S`
- **Phase 6**
 13. `rg -n -F 'getChatMessages' bn88-frontend-dashboard-v12\src\pages\ChatCenter.tsx -S`
 14. `rg -n -F 'getLineContentUrl' bn88-frontend-dashboard-v12\src\lib\api.ts -S`
 15. `rg -n -F 'headers[\"Authorization\"]' bn88-frontend-dashboard-v12\src -S | Out-File .\_rg_frontend_auth.txt`
- **Phase 7**
 16. `rg -n -F 'secrets' bn88-backend-v12\src\routes\admin\bots.ts -S`
 17. `rg -n -F 'manageBots' bn88-backend-v12\src\routes\admin\roles.ts -S`
- **Phase 8**
 18. `pwsh -Command 'curl.exe http://localhost:3000/api/health'`
 19. `pwsh -Command 'curl.exe http://localhost:3000/api/stats'`
- **Phase 11**
 20. `rg -n -F 'DATABASE_URL' bn88-backend-v12\.env -S`

## P0 Critical Files to Modify
- `bn88-backend-v12/src/mw/auth.ts` + `bn88-backend-v12/src/middleware/authGuard.ts`: normalize token read/verify for all admin routes, SSE, and line-content downloads.
- `bn88-backend-v12/src/middleware/basicAuth.ts`: tighten `requirePermission` logs, avoid duplicate lookups, ensure missing `req.auth` does not break pipelines.
- `bn88-backend-v12/src/routes/webhooks/line.ts`: confirm `resolveBot` handles tenant defaults, capture `channelSecret`/`channelAccessToken`, and emit SSE updates (critical for LINE tunnel verification).
- `bn88-backend-v12/src/routes/admin/chat.ts`: ensure `/line-content/:id` accepts token query + `x-tenant`, returns media with `Authorization` fallback and real tenant context.
- `bn88-frontend-dashboard-v12/src/lib/api.ts`: `getLineContentUrl` must append token query+tenant, `API` interceptors keep `Authorization`, and `withToken` handles fragments (helps line-content 401).
- `bn88-frontend-dashboard-v12/src/pages/ChatCenter.tsx` & `src/lib/events.ts`: attach token to SSE and image downloads, surface errors when `/api/live/:tenant` disconnects.
- `bn88-backend-v12/src/server.ts`: raw body placement for LINE is intact but add explicit HTTPS warning handling so `WEBHOOK_BASE_URL` + `LINE_CHANNEL_SECRET` combos can be validated during P0 tunnel verification.

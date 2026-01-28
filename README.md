# BN88-new-clean

## What is here
- `bn88-backend-v12` – Node/Express backend that exposes `/api` and `/api/admin` plus Prisma + migration scripts.
- `bn88-frontend-dashboard-v12` – Vite/React admin dashboard that proxies `/api` and `/api/admin`.
- `line-engagement-platform` – optional LEP service (BullMQ) that the backend can call for LINE campaigns.
- root helpers such as `start-dev.ps1`, `stop-dev.ps1`, and the `RUNBOOK*.md` notes that describe env + networking rules.

## Quick dev loop
1. Copy the env examples for each service before running anything:
   - `cd bn88-backend-v12 && cp .env.example .env`
   - `cd bn88-frontend-dashboard-v12 && cp .env.example .env`
2. Install dependencies for both packages (`npm install` in each folder).
3. Launch the stack with `pwsh start-dev.ps1` (Windows) or run the backend (`npm run dev`) / frontend (`npm run dev`) manually if you prefer a different shell. The script expects the repo path defined at the top of `start-dev.ps1` (`C:\BN88\BN88-new-clean`) so update that variable if you check out the repo elsewhere.
4. Backend listens on `http://localhost:3000` and the dashboard on `http://localhost:5555`; use the frontend proxy so `/api` resolves to the backend.

## Admin access
1. Seed or reset the admin account: within `bn88-backend-v12` run `npm run seed:admin` (or use `BN88-RESET-ADMIN.ps1` for a guided reset + session proof).
2. Default credentials from the seed script are `root@bn9.local` / `bn9@12345` unless you override `ADMIN_EMAIL`/`ADMIN_PASSWORD` in the env file.
3. Login from any client with `x-tenant: bn9` headers:
   ```powershell
   curl -H "Content-Type: application/json" -H "x-tenant: bn9" \
     -d '{"email":"root@bn9.local","password":"bn9@12345"}' \
     http://localhost:3000/api/admin/auth/login
   ```

   - The response contains `token`; send it as `Authorization: Bearer <token>` together with `x-tenant: bn9` for `/api/admin/*` requests.
   - For curl sessions you can alternatively reuse the `bn88_token` cookie that the backend returns.
4. `BN88-RESET-ADMIN.ps1` also shows how to run health checks, start both services, seed the admin, and fetch chat sessions so you can verify the admin token works.

## Environment files & security
- `bn88-backend-v12/.env.example` and `bn88-frontend-dashboard-v12/.env.example` describe the required values. Copy/rename them before running and keep the resulting `.env` files out of git. The repo’s existing `.gitignore` already blocks `node_modules/`, `*.db`, and `.env*` so neither secrets nor generated databases are tracked.
- Populate backend secrets (JWT, `SECRET_ENC_KEY_BN9`, LINE/Telegram tokens, OpenAI API keys, etc.) before booting the stack.

## Additional references
- `RUNBOOK.md`, `RUNBOOK-LOCAL.md`, and `WORKPLAN_MASTER.md` contain longer-form troubleshooting, PORT/redis notes, and rollout plans.
- The `/line-engagement-platform` folder has its own `README.md`/`USAGE.md` if you need the LEP service.

# bn88-new-clean

## Layout overview
- `bn88-backend-v12`: NestJS-style API, Prisma schema, and admin + webhook routes.
- `bn88-frontend-dashboard-v12`: Vite (React) dashboard that proxies `/api` to the backend.
- `line-engagement-platform`: ancillary scripts, managed containers, and migration helpers.
- `tools`: helper scripts used across the projects (smoke tests, automation, etc.).

## Environments
- Copy `bn88-backend-v12/.env.example` → `bn88-backend-v12/.env` before starting the backend.
- Copy `bn88-frontend-dashboard-v12/.env.example` → `bn88-frontend-dashboard-v12/.env` for the dashboard.
- `.env` files are ignored by Git; keep secrets locally and never commit real credentials.

## Running the local stack
1. From the repo root, run `.\start-dev.ps1`. It spawns two PowerShell windows: backend on port 3000 and frontend on port 5555.
2. Both projects share `npm install` in their folders, but `start-dev.ps1` already runs `npm run dev` for each.
3. Visit `http://localhost:5555` to access the dashboard; API requests go through the Vite proxy to the backend on 3000.

## Admin login helpers
- Default admin credentials (see `bn88-backend-v12/.env.example`):
  ```
  EMAIL=root@bn9.local
  PASSWORD=bn9@12345
  TENANT=bn9
  ```
- Use the dashboard at `http://localhost:5555` with the above credentials for the quickest access.
- For API work, log in with `POST http://localhost:3000/api/admin/auth/login` and include `x-tenant: bn9`. Capture the `bn88_token` cookie or `token` field for future requests (example curl commands live in `bn88-backend-v12/README.md`).

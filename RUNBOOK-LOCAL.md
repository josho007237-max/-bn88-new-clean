# RUNBOOK (Local Development)

> Local development guide for BN88 platform

## Table of Contents
- [Prerequisites](#prerequisites)
- [First-Time Setup](#first-time-setup)
- [Daily Development Workflow](#daily-development-workflow)
- [Backend Development](#backend-development)
- [Frontend Development](#frontend-development)
- [Database Development](#database-development)
- [Redis Setup](#redis-setup)
- [LINE Webhook Testing](#line-webhook-testing)
- [Common Tasks](#common-tasks)

## Prerequisites

### Required Tools
- Node.js 18.x (see `.nvmrc`)
- npm 8.x or higher
- PowerShell 5.1 or PowerShell Core 7+
- Git

### Optional Tools
- Docker Desktop (for Redis, PostgreSQL)
- cloudflared (for LINE webhook testing)
- Visual Studio Code (recommended IDE)

### Verify Prerequisites

```powershell
# Check Node.js
node --version  # Should show v18.x

# Check npm
npm --version   # Should show 8.x or higher

# Check PowerShell
$PSVersionTable.PSVersion

# Check Docker (optional)
docker --version

# Run smoke test
.\smoke.ps1
```

## First-Time Setup

### 1. Clone Repository

```powershell
git clone <repository-url>
cd -bn88-new-clean
```

### 2. Create Environment Files

```powershell
# Backend
Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env

# Frontend
Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env

# LINE Platform (optional)
Copy-Item .\line-engagement-platform\.env.example .\line-engagement-platform\.env
```

### 3. Install Dependencies

```powershell
# Backend
cd .\bn88-backend-v12
npm install
cd ..

# Frontend
cd .\bn88-frontend-dashboard-v12
npm install
cd ..

# LINE Platform (optional)
cd .\line-engagement-platform
npm install
cd ..
```

### 4. Setup Database

```powershell
cd .\bn88-backend-v12

# Generate Prisma client
npx prisma generate

# Create database tables
npx prisma db push

# Seed initial data (admin user, default tenant)
npm run seed:dev

cd ..
```

### 5. Verify Setup

```powershell
# Run smoke test
.\smoke.ps1

# Should show all green checkmarks
```

## Daily Development Workflow

### Start Development Environment

```powershell
# Option 1: Use automation script (recommended)
.\start-dev.ps1

# Option 2: Manual start
# Terminal 1 - Backend
cd .\bn88-backend-v12
npm run dev

# Terminal 2 - Frontend
cd .\bn88-frontend-dashboard-v12
npm run dev
```

### Access the Application

- **Frontend Dashboard:** http://localhost:5555
- **Backend API:** http://localhost:3000
- **Login Credentials:**
  - Email: `root@bn9.local`
  - Password: `bn9@12345`
  - Tenant: `bn9`

### Stop Development Environment

```powershell
# Use stop script
.\stop-dev.ps1

# Or manually: Ctrl+C in each terminal
```

## Backend Development

### Running Backend

```powershell
cd .\bn88-backend-v12

# Development mode (hot reload with tsx watch)
npm run dev

# Development with full preparation
npm run dev:full  # Runs prisma generate, migrate, seed, then dev

# Production mode
npm start
```

### Health Check

```powershell
# Check if backend is running
curl http://localhost:3000/api/health

# Expected response: {"status":"ok"}
```

### API Testing

```powershell
# Test login endpoint
$body = @{
    email = "root@bn9.local"
    password = "bn9@12345"
} | ConvertTo-Json

$response = Invoke-RestMethod -Method Post `
    -Uri "http://localhost:3000/api/admin/auth/login" `
    -ContentType "application/json" `
    -Body $body `
    -Headers @{"x-tenant" = "bn9"}

# Get token
$token = $response.token
Write-Host "Token: $token"

# Test authenticated endpoint
Invoke-RestMethod -Uri "http://localhost:3000/api/admin/bots" `
    -Headers @{
        "Authorization" = "Bearer $token"
        "x-tenant" = "bn9"
    }
```

### Database Management

```powershell
cd .\bn88-backend-v12

# Open Prisma Studio (visual database editor)
npm run studio
# Opens http://localhost:5556

# View database content
npx prisma studio

# Reset database (deletes all data!)
npx prisma migrate reset --force
npm run seed:dev
```

### Schema Changes

```powershell
cd .\bn88-backend-v12

# After modifying prisma/schema.prisma:

# 1. Push changes to database (dev)
npx prisma db push

# 2. Generate Prisma client
npx prisma generate

# 3. Or create a migration (recommended)
npx prisma migrate dev --name <migration-name>
```

### Backend Scripts

```powershell
cd .\bn88-backend-v12

# Development checks
npm run dev:check           # Check backend status
npm run check:all           # Full system check
npm run check:extended      # Extended validation

# Port management
npm run port:3000           # Check port 3000
npm run port:3000:kill      # Kill process on port 3000

# Database operations
npm run seed:dev            # Seed all dev data
npm run seed:admin          # Seed admin user only
npm run seed:bot            # Seed bot data only

# Quality checks
npm run typecheck           # TypeScript type checking
npm run build               # Build for production
```

## Frontend Development

### Running Frontend

```powershell
cd .\bn88-frontend-dashboard-v12

# Development mode (port 5555)
npm run dev

# Preview production build
npm run build
npm run preview
```

### Development Tasks

```powershell
cd .\bn88-frontend-dashboard-v12

# Code quality
npm run lint                # Run ESLint
npm run lint:fix            # Fix linting issues
npm run format              # Format with Prettier
npm run format:check        # Check formatting

# Type checking
npm run typecheck

# Testing
npm test
```

### Proxy Configuration

The frontend uses Vite's proxy to forward API requests to the backend.

Configuration in `vite.config.ts`:
```typescript
server: {
  port: 5555,
  proxy: {
    "/api": {
      target: "http://127.0.0.1:3000",
      changeOrigin: true,
    },
  },
}
```

This means:
- Frontend runs on http://localhost:5555
- API calls to `/api/*` are proxied to http://localhost:3000/api/*

## Database Development

### SQLite (Default for Development)

The backend uses SQLite by default for easy local development.

**Database file location:** `bn88-backend-v12/prisma/dev.db`

### Backup Database

```powershell
# Automated backup script
pwsh -File .\bn88-backend-v12\scripts\backup-dev.ps1

# Backup saved to: bn88-backend-v12/backups/db-<timestamp>.sqlite
```

### Restore Database

```powershell
# Restore from backup
pwsh -File .\bn88-backend-v12\scripts\restore-dev.ps1 `
    -BackupFile .\bn88-backend-v12\backups\db-<timestamp>.sqlite
```

### Manual Database Operations

```powershell
cd .\bn88-backend-v12

# View schema
npx prisma db pull

# Reset and recreate
Remove-Item .\prisma\dev.db -ErrorAction SilentlyContinue
npx prisma db push
npm run seed:dev
```

### PostgreSQL (Optional)

To use PostgreSQL instead of SQLite:

1. Start PostgreSQL:
   ```powershell
   docker-compose up -d db
   ```

2. Update `DATABASE_URL` in `.env`:
   ```env
   DATABASE_URL=postgresql://admin:password@localhost:5432/bn88?schema=public
   ```

3. Run migrations:
   ```powershell
   npx prisma migrate dev
   npm run seed:dev
   ```

## Redis Setup

### Why Redis?

Redis is used for:
- Rate limiting
- Queue management (BullMQ)
- Caching
- Session storage

### Start Redis

**Option 1: Docker (Recommended)**

```powershell
# Quick start (foreground, logs visible)
docker run --rm -p 6380:6379 redis:7-alpine

# Background with docker-compose
docker-compose up -d redis

# Check status
docker-compose ps
```

**Option 2: Disable Redis**

If you don't need Redis features:

```powershell
# Edit bn88-backend-v12/.env
DISABLE_REDIS=1
# or
ENABLE_REDIS=0
```

### Redis Configuration

In `bn88-backend-v12/.env`:
```env
REDIS_URL=redis://127.0.0.1:6380
REDIS_PORT=6380
ENABLE_REDIS=1
```

**Note:** Port 6380 is used to avoid conflicts with default Redis (6379).

### Test Redis Connection

```powershell
# Using Docker
docker exec -it <container-name> redis-cli ping
# Expected: PONG

# Or with redis-cli (if installed locally)
redis-cli -p 6380 ping
```

## LINE Webhook Testing

### Why HTTPS is Required

LINE Platform requires HTTPS for webhook endpoints. You cannot use:
- ❌ http://localhost:3000
- ❌ http://127.0.0.1:3000

You must use:
- ✅ https://<tunnel-url>/api/webhooks/line/bn9/dev-bot

### Setup Cloudflare Tunnel

1. **Install cloudflared:**
   - Download from: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/

2. **Start tunnel:**
   ```powershell
   # Basic tunnel
   cloudflared tunnel --url http://localhost:3000
   
   # With specific protocol (recommended)
   cloudflared tunnel --protocol http2 --url http://localhost:3000
   ```

3. **Copy the public URL:**
   ```
   Tunnel created at: https://abc-def-123.trycloudflare.com
   ```

### Configure LINE Webhook

1. Go to [LINE Developers Console](https://developers.line.biz/)
2. Select your channel
3. Go to "Messaging API" tab
4. Update webhook URL:
   ```
   https://<tunnel-url>/api/webhooks/line/bn9/dev-bot
   ```

### Verify Webhook

```powershell
# 1. Check local endpoint works
curl http://localhost:3000/api/health

# 2. Check tunnel endpoint works
curl https://<tunnel-url>/api/health

# 3. Test webhook endpoint
curl https://<tunnel-url>/api/webhooks/line/bn9/dev-bot
```

### Disable Signature Verification (Development Only)

For easier testing, you can skip LINE signature verification:

```powershell
# In bn88-backend-v12/.env
LINE_DEV_SKIP_VERIFY=1
```

**⚠️ Never use this in production!**

### Troubleshooting Cloudflared

**Problem: Tunnel shows errors**

1. Check origin is accessible:
   ```powershell
   curl http://localhost:3000/api/health
   ```

2. Try different protocol:
   ```powershell
   cloudflared tunnel --protocol http2 --url http://localhost:3000
   ```

3. Enable debug logs:
   ```powershell
   cloudflared tunnel --loglevel debug --url http://localhost:3000
   ```

4. Look for error keywords:
   - "origin connection refused" → Backend not running
   - "handshake" → Protocol mismatch
   - "disconnect" → Backend crashed

## Common Tasks

### Reset Everything

```powershell
# 1. Stop all services
.\stop-dev.ps1

# 2. Clean backend
cd .\bn88-backend-v12
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item .\prisma\dev.db* -ErrorAction SilentlyContinue
npm install
npx prisma generate
npx prisma db push
npm run seed:dev
cd ..

# 3. Clean frontend
cd .\bn88-frontend-dashboard-v12
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
npm install
cd ..

# 4. Start fresh
.\start-dev.ps1
```

### Update Dependencies

```powershell
# Backend
cd .\bn88-backend-v12
npm update
npm install

# Frontend
cd .\bn88-frontend-dashboard-v12
npm update
npm install
```

### Port Conflicts

```powershell
# Check what's using ports
Get-NetTCPConnection -LocalPort 3000,5555,6380 -State Listen

# Kill specific process
$conn = Get-NetTCPConnection -LocalPort 3000 -State Listen
Stop-Process -Id $conn.OwningProcess -Force

# Or use stop script
.\stop-dev.ps1
```

### Clear Browser Cache

If you see stale data:
1. Open browser DevTools (F12)
2. Right-click refresh button
3. Select "Empty Cache and Hard Reload"
4. Clear cookies for localhost

## PowerShell Best Practices

### Variable Naming

**⚠️ Important:** Use `$procId` instead of `$pid`

```powershell
# ✅ Correct
$procId = $connection.OwningProcess
Stop-Process -Id $procId -Force

# ❌ Wrong - $PID is a built-in automatic variable
$pid = $connection.OwningProcess
Stop-Process -Id $pid -Force
```

**Why?** `$PID` is a PowerShell automatic variable that contains the current process ID. Using it as a variable name will not work as expected.

### Execution Policy

If scripts won't run:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set for current user (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for single script
pwsh -ExecutionPolicy Bypass -File .\start-dev.ps1
```

## Tips & Tricks

### Fast Refresh

```powershell
# Backend: Just save the file - tsx watch auto-reloads
# Frontend: Vite HMR auto-refreshes browser
```

### View Logs

```powershell
# Backend logs appear in the PowerShell window where npm run dev is running
# Frontend logs appear in browser console (F12)
```

### Debug Mode

```powershell
# Backend: Use console.log or debugger
# Check logs in PowerShell window

# Frontend: Use browser DevTools
# Network tab for API calls
# Console for errors
```

### Multiple Tenants

To test multiple tenants:

1. Create tenant in database
2. Update `x-tenant` header in API calls
3. Use different login credentials per tenant

## Additional Resources

- [README.md](./README.md) - Project overview
- [RUNBOOK.md](./RUNBOOK.md) - Operational guide
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Troubleshooting guide
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Contributing guidelines

## Quick Reference

```powershell
# Start everything
.\start-dev.ps1

# Stop everything
.\stop-dev.ps1

# Check health
.\smoke.ps1

# Reset database
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev

# Start Redis
docker run --rm -p 6380:6379 redis:7-alpine

# Start tunnel
cloudflared tunnel --protocol http2 --url http://localhost:3000

# Open Prisma Studio
cd bn88-backend-v12
npm run studio
```

## Default Credentials

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

## Ports

| Service | Port | Access |
|---------|------|--------|
| Backend | 3000 | http://localhost:3000 |
| Frontend | 5555 | http://localhost:5555 |
| LINE Platform | 8080 | http://localhost:8080 |
| Redis | 6380 | redis://localhost:6380 |
| Prisma Studio | 5556 | http://localhost:5556 |
- disconnect

```powershell
cloudflared tunnel --url http://localhost:3000 --protocol http2 --loglevel debug
```

## Checklist: trycloudflare ได้ 404 แต่ localhost ใช้งานได้ (Windows)

1. เคลียร์ cloudflared ที่รันค้างทั้งหมด

```powershell
Get-Process cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force
```

2. รัน cloudflared ใหม่ (http2 + debug)

```powershell
cloudflared tunnel --protocol http2 --url http://127.0.0.1:3000 --loglevel debug
```

3. เทส public ด้วย iwr (ดู StatusCode + headers)

```powershell
$r = iwr "https://<trycloudflare>/" -SkipHttpErrorCheck
$r.StatusCode
$r.Headers["server"]
$r.Headers["cf-ray"]
```

4. เงื่อนไขตัดสิน

- ถ้า backend ไม่มี log เมื่อยิง public => request ไม่ถึง origin

## Dashboard (bn88-frontend-dashboard-v12)

```powershell
cd .\bn88-frontend-dashboard-v12
npm i
npm run dev
```

URL:

```
http://localhost:5173
```

## Ports

- 3000 (backend)
- 6380 (redis) — set `REDIS_URL=redis://127.0.0.1:6380` or `REDIS_PORT=6380` to enable workers
- 5555 (prisma studio, if used)

## Quick checks

```powershell
netstat -ano | findstr ":3000"
netstat -ano | findstr ":6380"
netstat -ano | findstr ":5555"

git status -sb

cd .\bn88-backend-v12
npx prisma validate
```

## Safe config search (Windows + rg)

บางเครื่อง/PowerShell จะ error เมื่อใช้ regex มี `|`. ให้แยกค้นทีละคำ:

```powershell
rg -n "REDIS_URL" bn88-backend-v12
rg -n "REDIS_PORT" bn88-backend-v12
rg -n "redis://127.0.0.1" bn88-backend-v12
rg -n "DISABLE_REDIS" bn88-backend-v12
rg -n "ENABLE_REDIS" bn88-backend-v12
```

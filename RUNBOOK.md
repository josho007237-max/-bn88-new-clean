# RUNBOOK

> Operational guide for running the BN88 platform

## Table of Contents
- [Quick Reference](#quick-reference)
- [Backend Operations](#backend-operations)
- [Frontend Operations](#frontend-operations)
- [Database Operations](#database-operations)
- [Redis Operations](#redis-operations)
- [LINE Webhook](#line-webhook)
- [Troubleshooting](#troubleshooting)

## Quick Reference

### Start Everything

```powershell
# From project root
.\start-dev.ps1
```

### Stop Everything

```powershell
# From project root
.\stop-dev.ps1
```

### Health Check

```powershell
# Backend
curl http://localhost:3000/api/health

# Frontend
curl http://localhost:5555
```

## Backend Operations

### Initial Setup

```powershell
cd .\bn88-backend-v12

# Install dependencies
npm install

# Setup environment
Copy-Item .env.example .env

# Generate Prisma client
npx prisma generate

# Create database
npx prisma db push

# Seed initial data
npm run seed:dev
```

### Running

```powershell
cd .\bn88-backend-v12

# Development mode (with hot reload)
npm run dev

# Development with preparation (migrate + seed)
npm run dev:full

# Production mode
npm start
```

### Database Management

```powershell
cd .\bn88-backend-v12

# Open Prisma Studio (database GUI)
npm run studio

# Run migrations
npm run prisma:migrate

# Reset database (WARNING: deletes all data)
npm run prisma:reset

# Seed data
npm run seed:dev        # All development data
npm run seed:admin      # Admin user only
npm run seed:bot        # Bot data only
```

### Development Scripts

```powershell
cd .\bn88-backend-v12

# Check backend status
npm run dev:check

# Check port 3000 usage
npm run port:3000

# Kill process on port 3000
npm run port:3000:kill

# Extended health check
npm run check:extended

# Type checking
npm run typecheck

# Build for production
npm run build
```

## Frontend Operations

### Initial Setup

```powershell
cd .\bn88-frontend-dashboard-v12

# Install dependencies
npm install

# Setup environment
Copy-Item .env.example .env
```

### Running

```powershell
cd .\bn88-frontend-dashboard-v12

# Development mode (port 5555)
npm run dev

# Preview production build
npm run preview
```

### Development Tasks

```powershell
cd .\bn88-frontend-dashboard-v12

# Type checking
npm run typecheck

# Linting
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Build for production
npm run build
```

## Database Operations

### Backup

```powershell
# Backup SQLite database and media
pwsh -File .\bn88-backend-v12\scripts\backup-dev.ps1
```

Backup files are saved to: `bn88-backend-v12/backups/`

### Restore

```powershell
# Restore from a specific backup
pwsh -File .\bn88-backend-v12\scripts\restore-dev.ps1 -BackupFile .\bn88-backend-v12\backups\db-<timestamp>.sqlite
```

### Migration

```powershell
cd .\bn88-backend-v12

# Create a new migration
npx prisma migrate dev --name <migration-name>

# Apply migrations (production)
npm run migrate:deploy

# Reset and reapply all migrations
npx prisma migrate reset
```

## Redis Operations

### Start Redis (Docker)

```powershell
# Quick start (foreground)
docker run --rm -p 6380:6379 redis:7-alpine

# Using docker-compose (background)
docker-compose up -d redis

# Check status
docker-compose ps redis
```

### Stop Redis

```powershell
# Stop docker-compose service
docker-compose stop redis

# Remove container
docker-compose down redis
```

### Redis CLI

```powershell
# Connect to Redis
docker exec -it <container-id> redis-cli

# Or if running locally
redis-cli -p 6380
```

### Disable Redis

If Redis is not available, disable it in backend `.env`:

```env
DISABLE_REDIS=1
# or
ENABLE_REDIS=0
```

## LINE Webhook

### Setup Tunnel

LINE webhooks require HTTPS. Use cloudflared for local testing:

```powershell
# Start tunnel
cloudflared tunnel --url http://localhost:3000

# With specific protocol
cloudflared tunnel --protocol http2 --url http://localhost:3000
```

### Webhook URL Format

```
https://<tunnel-url>/api/webhooks/line/<tenant>/<bot-id>
```

Example:
```
https://abc-def-123.trycloudflare.com/api/webhooks/line/bn9/dev-bot
```

### Verify Webhook

```powershell
# Check local endpoint
curl http://localhost:3000/api/health

# Check public endpoint
curl https://<tunnel-url>/api/health
```

### Debug Webhook

```powershell
# Enable LINE dev mode (skip signature verification)
# In bn88-backend-v12/.env
LINE_DEV_SKIP_VERIFY=1

# Check webhook logs in backend console
```

## Troubleshooting

### Backend Won't Start

1. **Check port 3000:**
   ```powershell
   Get-NetTCPConnection -LocalPort 3000 -State Listen
   ```

2. **Kill process if needed:**
   ```powershell
   .\stop-dev.ps1
   ```

3. **Check .env file exists:**
   ```powershell
   Test-Path .\bn88-backend-v12\.env
   ```

### Database Issues

```powershell
cd .\bn88-backend-v12

# Reset database
npx prisma migrate reset --force

# Regenerate Prisma client
npx prisma generate

# Recreate tables
npx prisma db push

# Seed data
npm run seed:dev
```

### Redis Connection Errors

```powershell
# Option 1: Start Redis
docker run --rm -p 6380:6379 redis:7-alpine

# Option 2: Disable Redis
# Edit bn88-backend-v12/.env
DISABLE_REDIS=1
```

### Can't Login

```powershell
cd .\bn88-backend-v12

# Reseed admin user
npm run seed:admin

# Verify credentials in .env
# ADMIN_EMAIL=root@bn9.local
# ADMIN_PASSWORD=bn9@12345
```

### Frontend API Errors

1. **Check backend is running:**
   ```powershell
   curl http://localhost:3000/api/health
   ```

2. **Check CORS settings:**
   ```powershell
   # In bn88-backend-v12/.env
   ALLOWED_ORIGINS=http://localhost:5555,http://localhost:5173
   ```

3. **Restart both services:**
   ```powershell
   .\stop-dev.ps1
   .\start-dev.ps1
   ```

### Cloudflared Tunnel Issues

1. **Check origin is accessible:**
   ```powershell
   curl http://localhost:3000/api/health
   ```

2. **Try different protocol:**
   ```powershell
   cloudflared tunnel --protocol http2 --url http://localhost:3000
   ```

3. **Enable debug logs:**
   ```powershell
   cloudflared tunnel --loglevel debug --url http://localhost:3000
   ```

4. **Look for errors:**
   - "origin connection refused" - backend not running
   - "handshake" - protocol mismatch
   - "disconnect" - backend crashed

## PowerShell Best Practices

**⚠️ Important:** Use `$procId` instead of `$pid`

```powershell
# ✅ Correct
$procId = $connection.OwningProcess
Stop-Process -Id $procId -Force

# ❌ Wrong - $PID is a built-in variable
$pid = $connection.OwningProcess
```

`$PID` is a PowerShell automatic variable representing the current process ID.

## Additional Resources

- [README.md](./README.md) - Project overview
- [RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md) - Local development guide
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Detailed troubleshooting
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Contributing guidelines

## Default Credentials

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

**⚠️ Change these in production!**

## Ports Reference

| Service | Port | URL |
|---------|------|-----|
| Backend | 3000 | http://localhost:3000 |
| Frontend | 5555 | http://localhost:5555 |
| LINE Platform | 8080 | http://localhost:8080 |
| Redis | 6380 | redis://localhost:6380 |
| Prisma Studio | 5556 | http://localhost:5556 |

## Quick Commands Reference

```powershell
# Start everything
.\start-dev.ps1

# Stop everything
.\stop-dev.ps1

# Pre-flight check
.\smoke.ps1

# Deep validation
.\deep-validation.ps1

# Reset database
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev

# Start Redis
docker run --rm -p 6380:6379 redis:7-alpine

# Backup database
pwsh .\bn88-backend-v12\scripts\backup-dev.ps1

# Open Prisma Studio
cd bn88-backend-v12
npm run studio
```
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

## Ports + netstat

- 3000 (backend)
- 5173 (dashboard)
- 6380 (redis) — set `REDIS_URL=redis://127.0.0.1:6380` or `REDIS_PORT=6380` to enable workers

```powershell
netstat -ano | findstr ":3000"
netstat -ano | findstr ":5173"
netstat -ano | findstr ":6380"
```

## E2E test (sample webhook -> dashboard event)

1. Send sample webhook:

```powershell
curl -X POST http://localhost:3000/webhooks/line -H "Content-Type: application/json" -d @sample-webhook.json
```

2. Open dashboard at http://localhost:5173 and confirm the event appears.

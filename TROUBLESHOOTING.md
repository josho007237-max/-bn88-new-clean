# Troubleshooting Guide

## Table of Contents
- [Installation Issues](#installation-issues)
- [Backend Issues](#backend-issues)
- [Frontend Issues](#frontend-issues)
- [Database Issues](#database-issues)
- [Redis Issues](#redis-issues)
- [Port Conflicts](#port-conflicts)
- [LINE Webhook Issues](#line-webhook-issues)
- [PowerShell Script Issues](#powershell-script-issues)

## Installation Issues

### Node.js Version Mismatch

**Problem:** Wrong Node.js version installed

**Solution:**
```powershell
# Check required version
cat .nvmrc

# Install and use correct version (if using nvm)
nvm install 18
nvm use 18

# Verify
node --version
```

### npm install fails

**Problem:** Dependencies installation fails

**Solution:**
```powershell
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# Reinstall
npm install
```

## Backend Issues

### Backend won't start

**Problem:** `npm run dev` fails or exits immediately

**Checklist:**
1. ✅ Check if .env file exists
   ```powershell
   Test-Path .\bn88-backend-v12\.env
   ```

2. ✅ Copy from example if missing
   ```powershell
   Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env
   ```

3. ✅ Verify DATABASE_URL in .env
   ```
   DATABASE_URL=file:./prisma/dev.db
   ```

4. ✅ Run Prisma setup
   ```powershell
   cd bn88-backend-v12
   npx prisma generate
   npx prisma db push
   npm run seed:dev
   ```

5. ✅ Check for port conflicts (port 3000)
   ```powershell
   Get-NetTCPConnection -LocalPort 3000 -State Listen
   ```

### Cannot login with default credentials

**Problem:** Login fails with `root@bn9.local / bn9@12345`

**Solution:**
```powershell
cd bn88-backend-v12

# Re-run seed script
npm run seed:dev

# Or manually seed admin
npm run seed:admin
```

### JWT Token errors

**Problem:** "Invalid token" or "Token expired" errors

**Solution:**
Check `.env` file has correct JWT configuration:
```
JWT_SECRET=bn9_dev_secret
JWT_EXPIRE=7d
```

### Database connection errors

**Problem:** "Cannot connect to database"

**Solution:**
```powershell
# For SQLite (default dev setup)
# Ensure DATABASE_URL points to local file
DATABASE_URL=file:./prisma/dev.db

# Reset database if corrupted
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev
```

## Frontend Issues

### Frontend won't start

**Problem:** `npm run dev` fails in frontend

**Checklist:**
1. ✅ Check .env file
   ```powershell
   Test-Path .\bn88-frontend-dashboard-v12\.env
   ```

2. ✅ Copy from example
   ```powershell
   Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env
   ```

3. ✅ Verify VITE_API_BASE
   ```
   VITE_API_BASE=http://127.0.0.1:3000/api
   ```

### API calls fail (CORS errors)

**Problem:** Browser console shows CORS errors

**Solution:**
1. Check backend .env has correct ALLOWED_ORIGINS:
   ```
   ALLOWED_ORIGINS=http://localhost:5555,http://localhost:5173
   ```

2. Restart both backend and frontend

### Login redirects don't work

**Problem:** After login, stays on login page

**Solution:**
1. Clear browser cookies for localhost
2. Check browser console for errors
3. Verify backend is running on port 3000
4. Check Vite proxy configuration in `vite.config.ts`

## Database Issues

### Prisma migration fails

**Problem:** `npx prisma migrate dev` fails

**Solution:**
```powershell
cd bn88-backend-v12

# Reset database (WARNING: loses data)
npx prisma migrate reset --force

# Generate Prisma client
npx prisma generate

# Push schema
npx prisma db push

# Seed data
npm run seed:dev
```

### Database is locked

**Problem:** "Database is locked" error

**Solution:**
```powershell
# Close all connections to database
# Stop backend server
# Delete database file and recreate

cd bn88-backend-v12
Remove-Item .\prisma\dev.db -ErrorAction SilentlyContinue
npx prisma db push
npm run seed:dev
```

## Redis Issues

### Redis connection fails

**Problem:** Backend logs show Redis connection errors

**Solution Option 1 - Disable Redis:**
```
# In bn88-backend-v12/.env
DISABLE_REDIS=1
```

**Solution Option 2 - Start Redis:**
```powershell
# Using Docker
docker run --rm -p 6380:6379 redis:7-alpine

# Or using docker-compose
docker-compose up -d redis
```

**Solution Option 3 - Fix Redis URL:**
```
# In bn88-backend-v12/.env
REDIS_URL=redis://127.0.0.1:6380
REDIS_PORT=6380
```

## Port Conflicts

### Port already in use

**Problem:** Error: "Port 3000 (or 5555) already in use"

**Find what's using the port:**
```powershell
Get-NetTCPConnection -LocalPort 3000 -State Listen | Select-Object -ExpandProperty OwningProcess
Get-Process -Id <PID>
```

**Kill the process:**
```powershell
Stop-Process -Id <PID> -Force
```

**Or use the stop script:**
```powershell
.\stop-dev.ps1
```

## LINE Webhook Issues

### Webhook returns 404

**Problem:** LINE webhook URL returns 404

**Solution:**
1. Ensure backend is running
2. Check webhook URL format:
   ```
   https://your-tunnel-url/api/webhooks/line/bn9/dev-bot
   ```
3. Verify bot exists in database
4. Check tenant code matches (bn9)

### Tunnel not working

**Problem:** cloudflared tunnel shows errors

**Solution:**
```powershell
# Try with explicit protocol
cloudflared tunnel --protocol http2 --url http://localhost:3000

# Check local endpoint first
curl http://localhost:3000/api/health

# Check public endpoint
curl https://your-tunnel-url/api/health
```

### Webhook signature verification fails

**Problem:** "Invalid signature" errors

**Solution:**
1. Disable signature verification for testing:
   ```
   # In bn88-backend-v12/.env
   LINE_DEV_SKIP_VERIFY=1
   ```

2. For production, ensure LINE_CHANNEL_SECRET is correct

## PowerShell Script Issues

### Execution policy error

**Problem:** "Cannot run script because execution policy"

**Solution:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for single script
pwsh -ExecutionPolicy Bypass -File .\start-dev.ps1
```

### start-dev.ps1 fails

**Problem:** Script doesn't start services

**Solution:**
1. Check you're in project root directory
2. Ensure .env files exist
3. Run smoke test first:
   ```powershell
   .\smoke.ps1
   ```

### stop-dev.ps1 doesn't stop services

**Problem:** Processes keep running

**Solution:**
```powershell
# Manually kill processes on ports
Get-NetTCPConnection -LocalPort 3000,5555 -State Listen | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force
}
```

## General Tips

### Clean restart

**Complete clean restart procedure:**
```powershell
# 1. Stop all services
.\stop-dev.ps1

# 2. Clean backend
cd bn88-backend-v12
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force dist -ErrorAction SilentlyContinue
Remove-Item .\prisma\dev.db* -ErrorAction SilentlyContinue
npm install
npx prisma generate
npx prisma db push
npm run seed:dev

# 3. Clean frontend
cd ..\bn88-frontend-dashboard-v12
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force dist -ErrorAction SilentlyContinue
npm install

# 4. Start services
cd ..
.\start-dev.ps1
```

### Check logs

**View detailed logs:**
```powershell
# Backend logs are in the PowerShell window
# Or run directly to see all output
cd bn88-backend-v12
npm run dev

# Frontend logs
cd bn88-frontend-dashboard-v12
npm run dev
```

### Get help

If none of these solutions work:
1. Check the main README.md for setup instructions
2. Review RUNBOOK.md for operational procedures
3. Check GitHub issues for similar problems
4. Create a new issue with:
   - Node.js version (`node --version`)
   - npm version (`npm --version`)
   - Operating System
   - Complete error message
   - Steps to reproduce

## Additional Resources

- [README.md](./README.md) - Main documentation
- [RUNBOOK.md](./RUNBOOK.md) - Operational procedures
- [RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md) - Local development guide
- [CONTRIBUTING.md](./CONTRIBUTING.md) - How to contribute

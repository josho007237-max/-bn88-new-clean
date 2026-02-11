# Quick Start Guide

> Get BN88 up and running in 5 minutes ⚡

## Prerequisites

- **Node.js 18.x** - [Download](https://nodejs.org/)
- **Git** - [Download](https://git-scm.com/)
- **PowerShell** (Windows) or **pwsh** (cross-platform)

## Step 1: Clone the Repository

```bash
git clone <repository-url>
cd -bn88-new-clean
```

## Step 2: Run Setup Script

```powershell
.\setup.ps1
```

This automated script will:
- ✅ Create `.env` files from examples
- ✅ Install dependencies for backend and frontend
- ✅ Generate Prisma database client
- ✅ Create and seed the database
- ✅ Verify everything is ready to run

**Time:** ~2-3 minutes (depending on internet speed)

## Step 3: Start Development Environment

```powershell
.\start-dev.ps1
```

This will open two PowerShell windows:
- **Backend** running on http://localhost:3000
- **Frontend** running on http://localhost:5555

## Step 4: Open Your Browser

Navigate to: **http://localhost:5555**

### Login Credentials

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

## ✅ You're Done!

The dashboard should now be accessible and you can start exploring the features.

---

## Optional: Enable Redis

For queue management and caching features:

```powershell
docker run --rm -p 6380:6379 redis:7-alpine
```

Or to disable Redis, edit `bn88-backend-v12/.env`:
```env
DISABLE_REDIS=1
```

---

## Troubleshooting

### Port Already in Use

```powershell
.\stop-dev.ps1
```

### Can't Login / No Admin User

```powershell
cd bn88-backend-v12
npm run seed:admin
```

### Database Errors

```powershell
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev
```

### More Help

- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Detailed troubleshooting guide
- [README.md](./README.md) - Full documentation
- [RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md) - Development guide

---

## Manual Setup (Alternative)

If you prefer manual setup or the script doesn't work:

### 1. Setup Backend

```powershell
cd bn88-backend-v12
Copy-Item .env.example .env
npm install
npx prisma generate
npx prisma db push
npm run seed:dev
cd ..
```

### 2. Setup Frontend

```powershell
cd bn88-frontend-dashboard-v12
Copy-Item .env.example .env
npm install
cd ..
```

### 3. Start Services

```powershell
# Terminal 1: Backend
cd bn88-backend-v12
npm run dev

# Terminal 2: Frontend
cd bn88-frontend-dashboard-v12
npm run dev
```

---

## What's Next?

- 📖 Read the [README.md](./README.md) for full documentation
- 🛠️ Check [RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md) for development workflows
- 🤝 See [CONTRIBUTING.md](./CONTRIBUTING.md) to contribute
- 🔧 Review [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues

---

## Project Structure

```
-bn88-new-clean/
├── bn88-backend-v12/           # Backend API (NestJS-style + Prisma)
├── bn88-frontend-dashboard-v12/  # Frontend Dashboard (React + Vite)
├── line-engagement-platform/   # LINE Integration Services
├── setup.ps1                   # Automated setup script
├── start-dev.ps1               # Start development environment
├── stop-dev.ps1                # Stop all services
└── smoke.ps1                   # Pre-flight checks
```

---

## Key Features

- 🔐 Multi-tenant authentication with JWT
- 💬 LINE bot integration and webhook handling
- 📊 Real-time dashboard with Server-Sent Events (SSE)
- 🗄️ SQLite (dev) / PostgreSQL (prod) with Prisma ORM
- 📨 Message queue with BullMQ + Redis
- 🎨 Modern React UI with Tailwind CSS
- ⚡ Fast development with Vite and hot reload

---

## Support

Need help? Check these resources:

1. **Documentation** - Start with README.md
2. **Troubleshooting** - See TROUBLESHOOTING.md
3. **Issues** - Create a GitHub issue
4. **Community** - Join discussions

---

**Happy coding! 🎉**

# bn88-new-clean

> A multi-tenant LINE bot management platform with admin dashboard, webhook handling, and engagement tools.

**🚀 [Quick Start Guide](./QUICKSTART.md)** - Get started in 5 minutes!

## 🎯 Overview

BN88 is a comprehensive platform for managing LINE bots with:
- **Backend API** (NestJS-style) - Multi-tenant admin API with Prisma ORM
- **Frontend Dashboard** (React + Vite) - Admin interface with real-time updates
- **LINE Engagement Platform** - Advanced LINE messaging features, campaigns, and analytics
- **PowerShell Automation** - Development and deployment scripts

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Running the Application](#-running-the-application)
- [Environment Configuration](#-environment-configuration)
- [Default Credentials](#-default-credentials)
- [Development Tools](#-development-tools)
- [Documentation](#-documentation)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## 🚀 Quick Start

**New to the project?** Follow the [Quick Start Guide](./QUICKSTART.md) for a 5-minute setup!

### Automated Setup (Recommended)

```powershell
# 1. Clone the repository
git clone <repo-url>
cd -bn88-new-clean

# 2. Run automated setup
.\setup.ps1

# 3. Start development environment
.\start-dev.ps1

# 4. Open browser
# http://localhost:5555
# Login: root@bn9.local / bn9@12345
```

### Manual Setup

```powershell
# 1. Clone the repository
git clone <repo-url>
cd -bn88-new-clean

# 2. Setup environment files
Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env
Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env

# 3. Install dependencies
cd bn88-backend-v12
npm install
cd ..\bn88-frontend-dashboard-v12
npm install
cd ..

# 4. Initialize database
cd bn88-backend-v12
npx prisma generate
npx prisma db push
npm run seed:dev
cd ..

# 5. Start the application
.\start-dev.ps1

# 6. Open browser
# Frontend: http://localhost:5555
# Backend API: http://localhost:3000
# Login: root@bn9.local / bn9@12345
```

## 📁 Project Structure

```
-bn88-new-clean/
├── bn88-backend-v12/              # Backend API Server
│   ├── src/                       # Source code
│   │   ├── routes/                # API routes
│   │   ├── services/              # Business logic
│   │   ├── middleware/            # Express middleware
│   │   └── scripts/               # Database seeds & utilities
│   ├── prisma/                    # Database schema & migrations
│   │   └── schema.prisma          # Prisma schema definition
│   └── tests/                     # Test files
│
├── bn88-frontend-dashboard-v12/   # Frontend Dashboard
│   ├── src/                       # React source code
│   │   ├── components/            # Reusable components
│   │   ├── pages/                 # Page components
│   │   └── utils/                 # Utility functions
│   └── vite.config.ts             # Vite configuration
│
├── line-engagement-platform/      # LINE Integration Services
│   ├── src/                       # LINE bot logic
│   ├── prisma/                    # Separate database schema
│   └── docker-compose.yml         # LEP-specific services
│
├── tools/                         # Helper scripts
├── docs/                          # Additional documentation
├── docker-compose.yml             # Main Docker services
├── start-dev.ps1                  # Start development servers
├── stop-dev.ps1                   # Stop development servers
└── smoke.ps1                      # Pre-flight checks
```

## 📋 Prerequisites

### Required

- **Node.js** 18.x (see `.nvmrc`)
- **npm** 8.x or higher
- **Git**
- **PowerShell** (for scripts)

### Optional

- **Docker** (for Redis, PostgreSQL)
- **cloudflared** (for LINE webhook testing)

### Verify Installation

```powershell
# Check Node.js version
node --version  # Should show v18.x

# Check npm version
npm --version

# Run smoke test
.\smoke.ps1
```

## 💻 Installation

### 1. Install Node.js

If using nvm (Node Version Manager):
```powershell
nvm install 18
nvm use 18
```

Or download from [nodejs.org](https://nodejs.org/)

### 2. Clone Repository

```bash
git clone <repository-url>
cd -bn88-new-clean
```

### 3. Set Up Environment Files

```powershell
# Backend
Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env

# Frontend
Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env

# LINE Platform (optional)
Copy-Item .\line-engagement-platform\.env.example .\line-engagement-platform\.env
```

### 4. Install Dependencies

```powershell
# Backend
cd bn88-backend-v12
npm install

# Frontend
cd ..\bn88-frontend-dashboard-v12
npm install

# LINE Platform (optional)
cd ..\line-engagement-platform
npm install

cd ..
```

### 5. Initialize Database

```powershell
cd bn88-backend-v12

# Generate Prisma client
npx prisma generate

# Create database and tables
npx prisma db push

# Seed initial data (admin user, default tenant)
npm run seed:dev

cd ..
```

## ▶️ Running the Application

### Development Mode (Recommended)

```powershell
# Start both backend and frontend
.\start-dev.ps1
```

This opens two PowerShell windows:
- **Backend** on `http://localhost:3000`
- **Frontend** on `http://localhost:5555`

### Manual Start

```powershell
# Terminal 1: Backend
cd bn88-backend-v12
npm run dev

# Terminal 2: Frontend
cd bn88-frontend-dashboard-v12
npm run dev
```

### Docker Compose (Full Stack)

```powershell
# Start all services (backend, frontend, databases, redis)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Stop Services

```powershell
# Stop all development services
.\stop-dev.ps1
```

## 🔧 Environment Configuration

### Backend (.env)

Key configurations in `bn88-backend-v12/.env`:

```env
# Server
NODE_ENV=development
PORT=3000

# Database (SQLite for dev, PostgreSQL for prod)
DATABASE_URL=file:./prisma/dev.db

# JWT Authentication
JWT_SECRET=bn9_dev_secret
JWT_EXPIRE=7d

# Multi-tenant
TENANT_DEFAULT=bn9

# CORS
ALLOWED_ORIGINS=http://localhost:5555,http://localhost:5173

# Redis (optional)
REDIS_URL=redis://127.0.0.1:6380
ENABLE_REDIS=1

# Admin Credentials
ADMIN_EMAIL=root@bn9.local
ADMIN_PASSWORD=bn9@12345
```

### Frontend (.env)

Key configurations in `bn88-frontend-dashboard-v12/.env`:

```env
# API Endpoints
VITE_API_BASE=http://127.0.0.1:3000/api
VITE_ADMIN_API_BASE=http://127.0.0.1:3000/api

# Tenant
VITE_TENANT=bn9
VITE_DEFAULT_TENANT=bn9
```

## 🔑 Default Credentials

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

**⚠️ Change these credentials in production!**

## 🛠️ Development Tools

### Scripts

```powershell
# Start development environment
.\start-dev.ps1

# Stop all services
.\stop-dev.ps1

# Run pre-flight checks
.\smoke.ps1

# Deep validation (API tests)
.\deep-validation.ps1
```

### Backend Commands

```powershell
cd bn88-backend-v12

# Development
npm run dev                  # Start dev server with hot reload
npm run dev:prep             # Generate Prisma + migrate + seed

# Database
npx prisma studio            # Open Prisma Studio (GUI)
npx prisma migrate dev       # Run migrations
npx prisma db push           # Push schema changes
npm run seed:dev             # Seed development data

# Testing & Quality
npm run typecheck            # TypeScript type checking
npm test                     # Run tests
npm run build                # Build for production
```

### Frontend Commands

```powershell
cd bn88-frontend-dashboard-v12

# Development
npm run dev                  # Start dev server (port 5555)

# Testing & Quality
npm run typecheck            # TypeScript type checking
npm run lint                 # Run ESLint
npm run format               # Format with Prettier
npm test                     # Run tests

# Build
npm run build                # Build for production
npm run preview              # Preview production build
```

## 📚 Documentation

- **[README.md](./README.md)** - This file (overview and quick start)
- **[RUNBOOK.md](./RUNBOOK.md)** - Operational procedures and commands
- **[RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md)** - Local development guide
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Common issues and solutions
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - How to contribute
- **[bn88-backend-v12/README.md](./bn88-backend-v12/README.md)** - Backend-specific docs
- **[line-engagement-platform/README.md](./line-engagement-platform/README.md)** - LINE platform docs

## 🐛 Troubleshooting

### Common Issues

**Port already in use:**
```powershell
.\stop-dev.ps1
```

**Database errors:**
```powershell
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev
```

**Can't login:**
```powershell
cd bn88-backend-v12
npm run seed:admin
```

**Redis connection fails:**
```env
# In bn88-backend-v12/.env
DISABLE_REDIS=1
```

For detailed troubleshooting, see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

## 🎨 Tech Stack

### Backend
- **Runtime:** Node.js 18.x
- **Framework:** Express (NestJS-style)
- **Language:** TypeScript
- **Database:** SQLite (dev) / PostgreSQL (prod)
- **ORM:** Prisma
- **Queue:** BullMQ + Redis
- **Auth:** JWT
- **API:** RESTful + Server-Sent Events (SSE)

### Frontend
- **Framework:** React 18
- **Build Tool:** Vite
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **Routing:** React Router
- **State:** React Hooks
- **HTTP:** Axios

### LINE Platform
- **SDK:** @line/bot-sdk
- **Features:** Messaging, Login, Pay, Ads
- **Queue:** BullMQ
- **Database:** PostgreSQL

## 🌐 Ports

| Service | Port | Description |
|---------|------|-------------|
| Backend | 3000 | Main API server |
| Frontend | 5555 | Dashboard UI |
| LINE Platform | 8080 | LINE integration services |
| Redis | 6380 | Cache & message queue |
| PostgreSQL | 5432 | Production database |
| Prisma Studio | 5556 | Database GUI |

## 🔒 Security Notes

### Development
- Never commit `.env` files (already in `.gitignore`)
- Use strong passwords in production
- Rotate JWT secrets regularly
- Keep dependencies updated

### Production
- Change default admin credentials
- Use environment variables for secrets
- Enable HTTPS
- Configure proper CORS origins
- Use strong encryption keys
- Enable rate limiting
- Regular security audits

## 📝 PowerShell Best Practices

**Important:** Use `$procId` instead of `$pid`

```powershell
# ✅ Good
$procId = $connection.OwningProcess
Stop-Process -Id $procId

# ❌ Bad
$pid = $connection.OwningProcess  # $PID is automatic variable
```

`$PID` is a built-in PowerShell automatic variable for the current process ID.

## 🤝 Contributing

We welcome contributions! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for:
- Code of conduct
- Development workflow
- Coding standards
- Commit guidelines
- Pull request process

## 📄 License

[Add license information]

## 👥 Authors

[Add author information]

## 🆘 Support

- **Issues:** [GitHub Issues](../../issues)
- **Discussions:** [GitHub Discussions](../../discussions)
- **Documentation:** [docs/](./docs/)

## 🎯 Roadmap

- [ ] Add comprehensive test coverage
- [ ] Implement CI/CD pipeline
- [ ] Add multi-language support
- [ ] Enhance security features
- [ ] Performance optimizations
- [ ] Mobile-responsive dashboard
- [ ] API documentation (Swagger)

---

Made with ❤️ by the BN88 team

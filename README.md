copilot/fix-bn88-project-issues
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
=======
# 🎯 BN88 New Clean - Complete Development Platform

A comprehensive multi-tenant platform for LINE messaging, customer engagement, and admin dashboard management.

## 📋 Table of Contents

- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Development](#development)
- [API Documentation](#api-documentation)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## 🔍 Overview

BN88 is a modern, multi-tenant platform built with:

- **Backend**: NestJS-style API with Prisma ORM, Express, and TypeScript
- **Frontend**: React + Vite dashboard with TypeScript
- **Database**: SQLite (dev) / PostgreSQL (production)
- **Cache**: Redis for rate limiting and queues
- **Messaging**: LINE Messaging API integration
- **Container**: Docker and Docker Compose for deployment

### Key Features

- 🔐 Multi-tenant architecture with tenant isolation
- 👥 Role-based admin authentication and authorization
- 💬 LINE messaging webhook integration
- 📊 Real-time dashboard with analytics
- 🔄 Background job processing with BullMQ
- 🚀 Development and production-ready configurations

---

## 💻 System Requirements

### Required Software

- **Node.js**: Version 18.x (as specified in `.nvmrc`)
- **npm**: Version 9.x or higher
- **PowerShell**: 7.x or higher (for development scripts)
- **Git**: Latest stable version

### Optional (for production deployment)

- **Docker**: Version 20.x or higher
- **Docker Compose**: Version 2.x or higher
- **PostgreSQL**: Version 15 or higher
- **Redis**: Version 7 or higher

### Operating Systems

- Windows 10/11 (PowerShell scripts included)
- macOS 12+ (Unix-compatible)
- Linux (Ubuntu 20.04+, Debian 11+)

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/josho007237-max/-bn88-new-clean.git
cd -bn88-new-clean
```

### 2. Check Node Version

Ensure you're using the correct Node.js version:

```bash
node --version  # Should be v18.x
```

If using `nvm` (Node Version Manager):

```bash
nvm use
# or
nvm install
```

### 3. Setup Environment Files

The `start-dev.ps1` script will automatically create `.env` files from `.env.example` if they don't exist.

Alternatively, create them manually:

```powershell
# Backend environment
cd bn88-backend-v12
copy .env.example .env

# Frontend environment
cd ../bn88-frontend-dashboard-v12
copy .env.example .env
cd ..
 main
```

### 4. Install Dependencies

```powershell
# Backend
cd bn88-backend-v12
npm install

# Frontend
 copilot/fix-bn88-project-issues
cd ..\bn88-frontend-dashboard-v12
npm install

# LINE Platform (optional)
cd ..\line-engagement-platform
npm install

=======
cd ../bn88-frontend-dashboard-v12
npm install
main
cd ..
```

### 5. Initialize Database

```powershell
cd bn88-backend-v12

# Generate Prisma client
npx prisma generate

 copilot/fix-bn88-project-issues
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

For a complete production-like environment with PostgreSQL and Redis:

```powershell
# 1. Create root .env file
Copy-Item .env.example .env

# 2. Ensure backend and frontend .env files exist
Copy-Item .\bn88-backend-v12\.env.example .\bn88-backend-v12\.env
Copy-Item .\bn88-frontend-dashboard-v12\.env.example .\bn88-frontend-dashboard-v12\.env

# 3. Update DATABASE_URL in backend .env for PostgreSQL
# DATABASE_URL=postgresql://admin:password@db:5432/bn88?schema=public

# 4. Start all services
docker-compose up -d

# 5. View logs
docker-compose logs -f

# 6. Stop all services
docker-compose down
```

**Services started:**
- PostgreSQL (port 5432)
- Redis (port 6380)
- Backend (port 3000)
- Frontend (port 5555)
- LINE Platform (port 8080)

### Stop Services

```powershell
# Stop all development services
.\stop-dev.ps1

# Or stop Docker Compose
docker-compose down
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

- **[QUICKSTART.md](./QUICKSTART.md)** - 5-minute setup guide (start here!)
- **[README.md](./README.md)** - This file (overview and setup)
- **[RUNBOOK.md](./RUNBOOK.md)** - Operational procedures and commands
- **[RUNBOOK-LOCAL.md](./RUNBOOK-LOCAL.md)** - Local development guide
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Common issues and solutions
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - How to contribute
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Production deployment guide
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and changes
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
=======
# Run migrations
npx prisma migrate dev

# Seed admin user and initial data
npm run seed:dev
```

### 6. Start Development Servers

From the repository root:

```powershell
.\start-dev.ps1
```

This will open two terminal windows:
- **Backend** on `http://localhost:3000`
- **Frontend** on `http://localhost:5555`

### 7. Access the Application

- **Dashboard**: http://localhost:5555
- **Backend API**: http://localhost:3000/api
- **Health Check**: http://localhost:3000/api/health

### 8. Login

Use the default admin credentials:

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

⚠️ **Change these credentials in production!**

### 9. Run Smoke Tests

```powershell
.\smoke.ps1
```

This validates that all services are running correctly.

### 10. Stop Development Servers

```powershell
.\stop-dev.ps1
```

---

## 📁 Project Structure

```
-bn88-new-clean/
├── bn88-backend-v12/           # Backend API server
│   ├── src/
│   │   ├── server.ts           # Main entry point
│   │   ├── routes/             # API routes
│   │   ├── middleware/         # Express middleware
│   │   └── scripts/            # Seed and utility scripts
│   ├── prisma/
│   │   ├── schema.prisma       # Database schema
│   │   └── migrations/         # Database migrations
│   ├── .env.example            # Backend environment template
│   └── package.json
│
├── bn88-frontend-dashboard-v12/ # Frontend dashboard
│   ├── src/
│   │   ├── main.tsx            # React entry point
│   │   ├── App.tsx             # Main app component
│   │   ├── pages/              # Page components
│   │   ├── components/         # Reusable components
│   │   └── lib/                # API client and utilities
│   ├── .env.example            # Frontend environment template
│   ├── vite.config.ts          # Vite configuration
│   └── package.json
│
├── line-engagement-platform/   # LINE integration platform
│   └── ...
│
├── docker-compose.yml          # Docker services configuration
├── start-dev.ps1               # Start development servers
├── stop-dev.ps1                # Stop development servers
├── smoke.ps1                   # Health check tests
├── README.md                   # This file
├── RUNBOOK.md                  # Operations guide
└── .nvmrc                      # Node version specification

```

---

## ⚙️ Configuration

### Backend Environment Variables

Located in `bn88-backend-v12/.env`:

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `development` | Environment mode |
| `PORT` | `3000` | Backend server port |
| `DATABASE_URL` | `file:./prisma/dev.db` | Database connection string |
| `JWT_SECRET` | `bn9_dev_secret...` | JWT signing secret |
| `JWT_EXPIRE` | `7d` | JWT token expiration |
| `REDIS_URL` | `redis://127.0.0.1:6380` | Redis connection URL |
| `ADMIN_EMAIL` | `root@bn9.local` | Default admin email |
| `ADMIN_PASSWORD` | `bn9@12345` | Default admin password |
| `TENANT_DEFAULT` | `bn9` | Default tenant code |

See `bn88-backend-v12/.env.example` for all available options.

### Frontend Environment Variables

Located in `bn88-frontend-dashboard-v12/.env`:

| Variable | Default | Description |
|----------|---------|-------------|
| `VITE_API_BASE` | `http://127.0.0.1:3000/api` | Backend API URL |
| `VITE_TENANT` | `bn9` | Default tenant |
| `VITE_APP_VERSION` | `dev` | Application version |

See `bn88-frontend-dashboard-v12/.env.example` for all available options.

---

## 🛠️ Development

### Available Scripts

#### Root Level

```powershell
# Start both backend and frontend
.\start-dev.ps1

# Stop all development servers
.\stop-dev.ps1

# Run health checks and smoke tests
.\smoke.ps1

# Run health checks with verbose output
.\smoke.ps1 -Verbose

# Skip API tests during health checks
.\smoke.ps1 -SkipAPI
```

#### Backend (`bn88-backend-v12`)

```bash
# Start development server with hot reload
npm run dev

# Generate Prisma client
npx prisma generate

# Run database migrations
npx prisma migrate dev

# Reset database (WARNING: deletes all data)
npx prisma migrate reset

# Open Prisma Studio (database GUI)
npm run studio

# Seed admin user
npm run seed:admin

# Seed development data
npm run seed:dev

# Type check
npm run typecheck

# Build for production
npm run build
```

#### Frontend (`bn88-frontend-dashboard-v12`)

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Type check
npm run typecheck

# Lint code
npm run lint

# Format code
npm run format
```

### Database Management

#### View Database with Prisma Studio

```bash
cd bn88-backend-v12
npm run studio
```

This opens Prisma Studio at `http://localhost:5556`.

#### Create a New Migration

```bash
cd bn88-backend-v12
npx prisma migrate dev --name your_migration_name
```

#### Reset Database

```bash
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev
```

---

## 📡 API Documentation

### Base URLs

- Development: `http://localhost:3000/api`
- Production: (configured in deployment)

### Authentication

Most endpoints require JWT authentication. Include the token in requests:

**Header:**
```
Authorization: Bearer <your_jwt_token>
```

**Cookie:**
```
bn88_token=<your_jwt_token>
```

**Query Parameter (limited endpoints):**
```
?token=<your_jwt_token>
```

### Multi-Tenant Header

All admin API requests require the tenant header:

```
x-tenant: bn9
```

### Key Endpoints

#### Health Check

```http
GET /api/health
```

Response:
```json
{
  "ok": true,
  "time": "2026-02-11T01:00:00.000Z",
  "adminApi": true
}
```

#### Admin Login

```http
POST /api/admin/auth/login
Headers:
  Content-Type: application/json
  x-tenant: bn9

Body:
{
  "email": "root@bn9.local",
  "password": "bn9@12345"
}
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "admin": {
    "id": "...",
    "email": "root@bn9.local"
  }
}
```

#### Get Current Admin User

```http
GET /api/admin/me
Headers:
  Authorization: Bearer <token>
  x-tenant: bn9
```

For more API endpoints, see:
- `bn88-backend-v12/src/routes/` - Route implementations
- `RUNBOOK.md` - Operational procedures

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Port Already in Use

**Error**: `EADDRINUSE: address already in use`

**Solution**:
```powershell
.\stop-dev.ps1
.\start-dev.ps1
```

#### 2. Prisma Client Not Generated

**Error**: `@prisma/client did not initialize yet`

**Solution**:
```bash
cd bn88-backend-v12
npx prisma generate
```

#### 3. Database Migration Failed

**Error**: Migration errors during `prisma migrate dev`

**Solution**:
```bash
cd bn88-backend-v12
npx prisma migrate reset --force
npx prisma migrate dev
npm run seed:dev
```

#### 4. Redis Connection Failed

**Error**: `Redis connection refused`

**Solution**:

Redis is optional for basic development. To disable:
```env
# In bn88-backend-v12/.env
ENABLE_REDIS=0
DISABLE_REDIS=1
```

Or start Redis with Docker:
```bash
docker run -d -p 6380:6379 redis:7-alpine
```

#### 5. Frontend Can't Connect to Backend

**Error**: API calls fail from frontend

**Solution**:
1. Verify backend is running on port 3000
2. Check `VITE_API_BASE` in `bn88-frontend-dashboard-v12/.env`
3. Verify Vite proxy configuration in `vite.config.ts`

#### 6. Login Fails with 401

**Error**: Login returns 401 Unauthorized

**Solution**:
1. Verify tenant header: `x-tenant: bn9`
2. Check admin user exists:
   ```bash
   cd bn88-backend-v12
   npm run seed:admin
   ```
3. Use correct credentials: `root@bn9.local` / `bn9@12345`

#### 7. TypeScript Errors

**Error**: TypeScript compilation errors

**Solution**:
```bash
# Backend
cd bn88-backend-v12
npm run typecheck

# Frontend
cd bn88-frontend-dashboard-v12
npm run typecheck
```

### Getting Help

1. Check the logs in the terminal windows
2. Run smoke tests: `.\smoke.ps1 -Verbose`
3. Review `RUNBOOK.md` for operational procedures
4. Check GitHub issues: [Issues](https://github.com/josho007237-max/-bn88-new-clean/issues)

---

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Run tests and linters
5. Commit with clear messages
6. Push to your fork
7. Create a Pull Request

### Code Style

- **Backend**: Follow TypeScript best practices
- **Frontend**: Use React hooks and functional components
- **Formatting**: Run `npm run format` before committing
- **Linting**: Run `npm run lint` to check for issues

### Commit Messages

Use clear, descriptive commit messages:

```
feat: Add user profile page
fix: Resolve login token expiration issue
docs: Update API documentation
refactor: Simplify authentication middleware
```

---

## 📄 License

This project is private and proprietary. Unauthorized copying or distribution is prohibited.

---

## 👥 Team & Support

- **Repository**: [josho007237-max/-bn88-new-clean](https://github.com/josho007237-max/-bn88-new-clean)
- **Documentation**: See `docs/` folder for additional guides
- **Operations**: See `RUNBOOK.md` for deployment and operations

---

## 📝 Additional Documentation

- [RUNBOOK.md](RUNBOOK.md) - Operations and deployment guide
- [RUNBOOK-LOCAL.md](RUNBOOK-LOCAL.md) - Local development guide
- [WORKPLAN_MASTER.md](WORKPLAN_MASTER.md) - Development roadmap

---

**Made with ❤️ by the BN88 Team**
 main

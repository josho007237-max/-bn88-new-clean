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
```

### 4. Install Dependencies

```powershell
# Backend
cd bn88-backend-v12
npm install

# Frontend
cd ../bn88-frontend-dashboard-v12
npm install
cd ..
```

### 5. Initialize Database

```powershell
cd bn88-backend-v12

# Generate Prisma client
npx prisma generate

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

 copilot/fix-and-improve-bn88-project
# bn88-new-clean

A full-stack LINE messaging platform with admin dashboard, built with Express, React, and Prisma.

## 📁 Project Structure

- **`bn88-backend-v12`**: Express API server with Prisma ORM, admin authentication, and LINE webhook routes
- **`bn88-frontend-dashboard-v12`**: Vite + React dashboard with TypeScript, proxies `/api` requests to backend
- **`line-engagement-platform`**: Docker-based LINE engagement platform with campaigns, Bull queue, and PostgreSQL
- **`tools`**: Helper scripts for automation and testing

## 🚀 Quick Start

### Prerequisites

- Node.js 18.x (check `.nvmrc`)
- npm or yarn
- PowerShell (for Windows scripts)
- Docker & Docker Compose (optional, for LINE platform)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd ./-bn88-new-clean
   ```

2. **Setup Backend**
   ```bash
   cd bn88-backend-v12
   cp .env.example .env
   npm install
   npx prisma generate
   npx prisma db push
   npm run seed:dev
   ```

3. **Setup Frontend**
   ```bash
   cd ../bn88-frontend-dashboard-v12
   cp .env.example .env
   npm install
   ```

4. **Start Development Stack**
   ```powershell
   # From repository root
   .\start-dev.ps1
   ```

   This will start:
   - Backend API on `http://localhost:3000`
   - Frontend Dashboard on `http://localhost:5555`

5. **Access the Application**
   - Open your browser to `http://localhost:5555`
   - Login with default credentials:
     - **Email**: `root@bn9.local`
     - **Password**: `bn9@12345`
     - **Tenant**: `bn9`

### LINE Engagement Platform (Optional)

If you need the LINE engagement platform:

```bash
cd line-engagement-platform
cp .env.example .env
# Edit .env and add your LINE credentials
docker compose up --build
```

Platform will be available at `http://localhost:8080`

## 🛠️ Available Scripts

### Root Directory

- **`.\start-dev.ps1`** - Start backend and frontend in separate windows
- **`.\stop-dev.ps1`** - Stop all services on ports 3000, 5555-5566
- **`.\smoke.ps1`** - Run smoke tests to verify services are running
- **`.\deep-validation.ps1`** - Comprehensive validation of all features

### Backend (`bn88-backend-v12`)

- **`npm run dev`** - Start development server with hot reload
- **`npm run seed:dev`** - Seed database with development data
- **`npm run prisma:migrate`** - Run Prisma migrations
- **`npm run prisma:studio`** - Open Prisma Studio (database GUI)
- **`npm run build`** - Build for production

### Frontend (`bn88-frontend-dashboard-v12`)

- **`npm run dev`** - Start Vite dev server (port 5555)
- **`npm run build`** - Build for production
- **`npm run preview`** - Preview production build
- **`npm run lint`** - Run ESLint
- **`npm run typecheck`** - Run TypeScript type checking

## 🔧 Configuration

### Environment Variables

All projects use `.env` files for configuration. Copy `.env.example` to `.env` and customize:

#### Backend Key Variables
- `PORT=3000` - Server port
- `DATABASE_URL` - Prisma database connection
- `JWT_SECRET` - Secret for JWT tokens
- `REDIS_URL` - Redis connection (optional)
- `ADMIN_EMAIL` / `ADMIN_PASSWORD` - Default admin credentials

#### Frontend Key Variables
- `VITE_API_BASE` - Backend API URL (default: http://127.0.0.1:3000/api)
- `VITE_TENANT` - Default tenant name (default: bn9)

#### LINE Platform Key Variables
- `LINE_CHANNEL_SECRET` - LINE Messaging API channel secret
- `LINE_CHANNEL_ACCESS_TOKEN` - LINE Messaging API access token
- `DATABASE_URL` - PostgreSQL connection string

### PowerShell Best Practices

⚠️ **Important**: Use `$procId` instead of `$pid` in PowerShell scripts
- `$PID` is an automatic PowerShell variable
- Use `$procId` for custom process ID variables

## 🌐 API Endpoints

### Backend API (`http://localhost:3000`)

- **`GET /api/health`** - Health check
- **`GET /api/stats`** - Service statistics
- **`POST /api/admin/auth/login`** - Admin login
- **`GET /api/admin/bots`** - List bots (requires auth)
- **`GET /api/live/:tenant`** - Server-Sent Events stream

For detailed API documentation, see `bn88-backend-v12/README.md`

## 🔍 Troubleshooting

### Backend won't start

1. Check if port 3000 is already in use:
   ```powershell
   Get-NetTCPConnection -LocalPort 3000 -State Listen
   ```

2. Kill the process:
   ```powershell
   .\stop-dev.ps1
   ```

3. Check database connection:
   ```bash
   cd bn88-backend-v12
   npx prisma studio
   ```

### Frontend can't connect to backend

1. Verify backend is running at `http://localhost:3000/api/health`
2. Check proxy configuration in `bn88-frontend-dashboard-v12/vite.config.ts`
3. Ensure `VITE_API_BASE` in `.env` matches backend URL

### Prisma errors

1. Regenerate Prisma client:
   ```bash
   cd bn88-backend-v12
   npx prisma generate
   ```

2. Reset database (⚠️ deletes all data):
   ```bash
   npx prisma migrate reset --force
   ```

### Port conflicts

If you get port conflicts, use `stop-dev.ps1` to kill processes on ports:
- 3000 (backend)
- 5555 (frontend)
- 5556-5566 (additional services)

## 📚 Additional Resources

- **RUNBOOK.md** - Production deployment guide
- **RUNBOOK-LOCAL.md** - Local development detailed guide
- **WORKPLAN_MASTER.md** - Project planning and roadmap

## 🔐 Security Notes

- **Never commit `.env` files** - They contain sensitive credentials
- Default admin credentials are for development only
- Change `JWT_SECRET` and admin password in production
- Keep LINE API credentials secure

## 📝 License

Private - All rights reserved

## 🤝 Contributing

For development guidelines, see backend and frontend README files.
=======
copilot/fix-bn88-project-issues-again
# 🚀 BN88 New Clean

A comprehensive LINE bot platform with admin dashboard, featuring multi-tenant support, AI-powered chat, knowledge management, and marketing campaign tools.

## 📖 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Default Credentials](#default-credentials)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

BN88 New Clean is a full-stack platform for building and managing LINE chatbots with:
- **Multi-tenant architecture** - Support multiple organizations/brands
- **Admin Dashboard** - React-based web interface for bot management
- **AI-Powered Chat** - Integration with OpenAI for intelligent responses
- **Knowledge Base** - Document management for bot training
- **Marketing Platform** - LINE engagement campaigns and analytics
- **Webhook Support** - LINE, Facebook, and Telegram integrations

## ✨ Features

### 🤖 Bot Management
- Create and configure multiple bots
- Intent-based conversation flows
- Rich message support (templates, carousels, quick replies)
- Fallback handling with AI assistance

### 💬 Chat Center
- Real-time chat sessions
- Message history and analytics
- Multi-channel support (LINE, Facebook, Telegram)
- Rich media messaging

### 📚 Knowledge Management
- Document upload and indexing
- Vector-based search with OpenAI embeddings
- FAQ management
- Context-aware responses

### 📊 Marketing & Engagement
- Campaign creation and scheduling
- Audience segmentation
- Broadcast messaging
- Analytics and reporting

### 🔐 Security
- JWT-based authentication
- Role-based access control (RBAC)
- Multi-tenant isolation
- Rate limiting and request validation

## 🛠 Tech Stack

### Backend
- **Runtime:** Node.js 18+
- **Framework:** NestJS-style Express
- **Database:** PostgreSQL (with SQLite option for development)
- **ORM:** Prisma
- **Cache:** Redis (optional)
- **Queue:** BullMQ
- **Language:** TypeScript

### Frontend
- **Framework:** React 18
- **Build Tool:** Vite
- **Router:** React Router v7
- **Styling:** Tailwind CSS
- **HTTP Client:** Axios
- **Language:** TypeScript

### Infrastructure
- **Container:** Docker & Docker Compose
- **Proxy:** Nginx (production)
- **Process Manager:** PM2 (production)

## ⚡ Quick Start

### Prerequisites

- Node.js 18+ (check `.nvmrc` for exact version)
- npm 9+
- PowerShell 7+ (for Windows)
- Docker Desktop (optional, for PostgreSQL/Redis)

### Installation

```powershell
# 1. Clone the repository
git clone https://github.com/josho007237-max/-bn88-new-clean.git
cd -bn88-new-clean

# 2. Install backend dependencies
cd bn88-backend-v12
npm install

# 3. Install frontend dependencies
cd ../bn88-frontend-dashboard-v12
npm install
cd ..

# 4. Setup environment files
cd bn88-backend-v12
copy .env.example .env
cd ../bn88-frontend-dashboard-v12
copy .env.example .env
cd ..

# 5. Initialize database (choose one option)

# Option A: SQLite (quickest, no Docker)
# Edit bn88-backend-v12/.env: DATABASE_URL=file:./prisma/dev.db

# Option B: PostgreSQL with Docker (recommended)
docker-compose up -d db redis

# Option C: Use your own PostgreSQL
# Edit bn88-backend-v12/.env with your DATABASE_URL

# 6. Setup database schema
cd bn88-backend-v12
npx prisma db push
npm run seed:dev
cd ..

# 7. Start development servers
.\start-dev.ps1

# 8. Run smoke tests (optional)
.\smoke.ps1
```

### Access the Application

- **Frontend Dashboard:** http://localhost:5555
- **Backend API:** http://localhost:3000
- **API Health Check:** http://localhost:3000/api/health
- **Prisma Studio:** `cd bn88-backend-v12 && npm run studio` → http://localhost:5556
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
copilot/fix-bn88-project-issues-again
├── bn88-backend-v12/           # Backend API (NestJS-style Express)
│   ├── src/
│   │   ├── server.ts           # Main entry point
│   │   ├── routes/             # API routes
│   │   ├── services/           # Business logic
│   │   ├── mw/                 # Middleware (auth, validation)
│   │   ├── config/             # Configuration
│   │   └── scripts/            # Utility scripts (seeding, etc.)
│   ├── prisma/
│   │   ├── schema.prisma       # Database schema
│   │   └── migrations/         # Database migrations
│   ├── .env.example            # Environment template
│   └── package.json
│
├── bn88-frontend-dashboard-v12/ # Frontend Dashboard (React + Vite)
│   ├── src/
│   │   ├── main.tsx            # Entry point
│   │   ├── pages/              # Page components
│   │   ├── components/         # Reusable components
│   │   ├── lib/                # API client, utilities
│   │   └── types.ts            # TypeScript types
│   ├── vite.config.ts          # Vite configuration
│   ├── .env.example            # Environment template
│   └── package.json
│
├── line-engagement-platform/   # LINE marketing platform
│   ├── src/                    # Campaign management
│   └── prisma/                 # Separate database schema
│
├── docs/                       # Additional documentation
├── tools/                      # Development tools
│
├── start-dev.ps1              # Start development stack
├── stop-dev.ps1               # Stop development stack
├── smoke.ps1                  # Smoke test suite
├── docker-compose.yml         # Docker services configuration
│
├── README.md                  # This file
├── SETUP.md                   # Detailed setup guide
├── CONTRIBUTING.md            # Contribution guidelines
├── RUNBOOK.md                 # Operations guide
└── RUNBOOK-LOCAL.md           # Local development guide
```

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - First-time setup guide with troubleshooting
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute to this project
- **[RUNBOOK.md](RUNBOOK.md)** - Operational guide for production
- **[RUNBOOK-LOCAL.md](RUNBOOK-LOCAL.md)** - Local development guide

## 🔑 Default Credentials

For development/testing:

```
Email:    root@bn9.local
Password: bn9@12345
Tenant:   bn9
```

⚠️ **Security Warning:** Change these credentials before deploying to production!

## 💻 Development

### Start Development Environment
=======
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
main

```powershell
# Start both backend and frontend
.\start-dev.ps1

 copilot/fix-bn88-project-issues-again
# Or start individually:
# Backend
cd bn88-backend-v12
npm run dev

# Frontend (in another terminal)
cd bn88-frontend-dashboard-v12
npm run dev
```

### Stop Development Environment

```powershell
.\stop-dev.ps1
```

### Run Tests

```powershell
# Backend
cd bn88-backend-v12
npm test
npm run typecheck

# Frontend
cd bn88-frontend-dashboard-v12
npm test
npm run typecheck

# Smoke tests
.\smoke.ps1
=======
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
 main
```

### Database Management

 copilot/fix-bn88-project-issues-again
```powershell
cd bn88-backend-v12

# Open Prisma Studio (database GUI)
npm run studio

# Create a migration
npx prisma migrate dev --name your-migration-name

# Apply migrations
npx prisma migrate deploy

# Reset database (⚠️ deletes all data)
npx prisma migrate reset

# Seed database
npm run seed:dev
```

### Useful Scripts

```powershell
# Backend (from bn88-backend-v12/)
npm run dev              # Start dev server
npm run build            # Build for production
npm run typecheck        # Check TypeScript types
npm run seed:dev         # Seed database
npm run seed:admin       # Create admin user only
npm run prisma:studio    # Open Prisma Studio

# Frontend (from bn88-frontend-dashboard-v12/)
npm run dev              # Start dev server
npm run build            # Build for production
npm run preview          # Preview production build
npm run typecheck        # Check TypeScript types
npm run lint             # Run ESLint
npm run lint:fix         # Fix ESLint errors
```

## 🚀 Deployment

### Using Docker Compose

```powershell
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Environment Variables

See `.env.example` files for all available options. Key variables:

**Backend:**
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - Secret for JWT token signing
- `REDIS_URL` - Redis connection string
- `LINE_CHANNEL_SECRET` - LINE bot credentials
- `OPENAI_API_KEY` - OpenAI API key (optional)

**Frontend:**
- `VITE_API_BASE` - Backend API URL
- `VITE_TENANT` - Default tenant ID

### Production Checklist

- [ ] Change all default passwords
- [ ] Set strong `JWT_SECRET`
- [ ] Configure production `DATABASE_URL`
- [ ] Setup Redis for caching/queues
- [ ] Configure CORS `ALLOWED_ORIGINS`
- [ ] Add LINE bot credentials
- [ ] Setup SSL/TLS certificates
- [ ] Configure environment variables
- [ ] Run database migrations
- [ ] Setup monitoring and logging
- [ ] Configure backups

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Code of conduct
- Development workflow
- Coding standards
- Commit guidelines
- Pull request process

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/josho007237-max/-bn88-new-clean/issues)
- **Documentation:** Check `/docs` directory
- **Email:** [Your contact email]

## 📋 System Requirements

### Development
- **OS:** Windows 10/11, macOS, Linux
- **Node.js:** 18.x or higher
- **RAM:** 4GB minimum, 8GB recommended
- **Disk:** 2GB free space

### Production
- **Node.js:** 18.x LTS
- **PostgreSQL:** 15+
- **Redis:** 7+ (optional but recommended)
- **RAM:** 2GB minimum, 4GB+ recommended
- **CPU:** 2 cores minimum

## 🔄 Version History

See [CHANGELOG.md](CHANGELOG.md) for release notes.

## 📄 License

[Your License Here - e.g., MIT, Apache 2.0]

## 🙏 Acknowledgments

- LINE Messaging API
- OpenAI API
- Prisma ORM
- React & Vite teams
- All contributors

---

**Made with ❤️ by the BN88 team**

For detailed setup instructions, see [SETUP.md](SETUP.md)

=======
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
 main

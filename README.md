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

## 📁 Project Structure

```
-bn88-new-clean/
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

```powershell
# Start both backend and frontend
.\start-dev.ps1

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
```

### Database Management

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


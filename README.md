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

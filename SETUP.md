copilot/fix-bn88-project-issues-again
# 🚀 BN88 New Clean - First-Time Setup Guide

This guide will walk you through setting up the BN88 project from scratch.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Node.js** (version 18 or higher)
   - Check version: `node --version`
   - Download from: https://nodejs.org/
   - Recommended: Use the version specified in `.nvmrc` file (v18)

2. **npm** (comes with Node.js)
   - Check version: `npm --version`
   - Should be v9 or higher

3. **PowerShell** (for Windows users)
   - PowerShell 7+ recommended
   - Download from: https://github.com/PowerShell/PowerShell

4. **Git**
   - Check version: `git --version`
   - Download from: https://git-scm.com/

### Optional Software (for full stack)

5. **Docker Desktop** (for PostgreSQL and Redis)
   - Download from: https://www.docker.com/products/docker-desktop
   - Alternative: Install PostgreSQL and Redis separately

6. **PostgreSQL** (if not using Docker)
   - Version 15 or higher recommended
   - Download from: https://www.postgresql.org/download/

7. **Redis** (if not using Docker)
   - Version 7 or higher recommended
   - Download from: https://redis.io/download

## 🔧 Step-by-Step Setup

### 1. Clone the Repository

```powershell
# Clone the repository
=======
# 🚀 BN88 First-Time Setup Guide

This guide will walk you through setting up the BN88 platform for the first time.

## 📋 Prerequisites Checklist

Before you begin, ensure you have the following installed:

- [ ] **Node.js 18.x** - [Download](https://nodejs.org/)
- [ ] **npm 9.x+** - Comes with Node.js
- [ ] **Git** - [Download](https://git-scm.com/)
- [ ] **PowerShell 7+** (Windows) - [Download](https://github.com/PowerShell/PowerShell)
- [ ] **Code Editor** - VS Code recommended

### Optional (for production)

- [ ] **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
- [ ] **PostgreSQL 15+** - [Download](https://www.postgresql.org/download/)
- [ ] **Redis 7+** - [Download](https://redis.io/download)

---

## 🔧 Step-by-Step Setup

### Step 1: Verify Node.js Installation

Open a terminal and run:

```bash
node --version
```

You should see `v18.x.x`. If not, install the correct version:

**Using nvm (recommended):**

```bash
# Install nvm first if you don't have it
# Windows: https://github.com/coreybutler/nvm-windows
# macOS/Linux: https://github.com/nvm-sh/nvm

# Install Node.js 18
nvm install 18
nvm use 18
```

### Step 2: Clone the Repository

```bash
main
git clone https://github.com/josho007237-max/-bn88-new-clean.git
cd -bn88-new-clean
```

copilot/fix-bn88-project-issues-again
### 2. Check Node Version

```powershell
# Check if you have the correct Node version
node --version
# Should be v18.x.x (check .nvmrc file for exact version)

# If you're using nvm (Node Version Manager):
nvm install 18
nvm use 18
```

### 3. Install Dependencies

#### Backend Dependencies

```powershell
cd bn88-backend-v12
npm install
```

This will:
- Install all Node.js packages
- Run `prisma generate` automatically (via postinstall script)

#### Frontend Dependencies

```powershell
cd ../bn88-frontend-dashboard-v12
npm install
```

### 4. Setup Environment Files

#### Backend Environment

```powershell
# Go to backend directory
cd ../bn88-backend-v12

# Copy the example file
copy .env.example .env

# Edit .env file and configure:
# - DATABASE_URL (see database options below)
# - JWT_SECRET (change from default in production!)
# - REDIS_URL (if using Redis)
```

**Database Options:**

**Option A: SQLite (Quickest - No Docker needed)**
```env
DATABASE_URL=file:./prisma/dev.db
```

**Option B: PostgreSQL with Docker (Recommended)**
```env
DATABASE_URL=postgresql://admin:password@localhost:5432/bn88?schema=public
```

Then run:
```powershell
# From repository root
docker-compose up -d db
```

**Option C: Your Own PostgreSQL Server**
```env
DATABASE_URL=postgresql://YOUR_USER:YOUR_PASSWORD@YOUR_HOST:5432/bn88?schema=public
```

#### Frontend Environment

```powershell
cd ../bn88-frontend-dashboard-v12

# Copy the example file
copy .env.example .env

# The defaults should work fine for local development
# No changes needed unless you modified backend ports
```

### 5. Initialize the Database

```powershell
cd ../bn88-backend-v12

# Generate Prisma client (should already be done via npm install)
npx prisma generate

# Push database schema (for development)
npx prisma db push

# Seed the database with default admin user
npm run seed:dev
```

This creates the default admin account:
- **Email:** `root@bn9.local`
- **Password:** `bn9@12345`
- **Tenant:** `bn9`

### 6. Start the Development Servers

#### Option A: Use PowerShell Script (Recommended)
=======
### Step 3: Use Correct Node Version

The project includes a `.nvmrc` file specifying the required Node version:

```bash
# If using nvm
nvm use

# Verify
node --version  # Should show v18.x.x
```

### Step 4: Setup Environment Files

#### Option A: Automatic Setup (Recommended)

The `start-dev.ps1` script will automatically create `.env` files from templates.

#### Option B: Manual Setup

**Backend:**

```powershell
cd bn88-backend-v12
copy .env.example .env
```

**Frontend:**

```powershell
cd bn88-frontend-dashboard-v12
copy .env.example .env
```

### Step 5: Review Environment Variables

#### Backend (`bn88-backend-v12/.env`)

Open the file and review the configuration. Default values are suitable for development, but you may want to change:

```env
# Change these in production!
JWT_SECRET=your_secure_random_string_here
ADMIN_PASSWORD=your_secure_password_here
```

#### Frontend (`bn88-frontend-dashboard-v12/.env`)

Default values should work as-is for local development.

### Step 6: Install Backend Dependencies

```bash
cd bn88-backend-v12
npm install
```

**What this does:**
- Installs all Node.js dependencies
- Automatically runs `prisma generate` (via postinstall script)

**Expected output:**
- No errors
- "✓ Prisma Client generated" message

**If you see errors:**
- Clear cache: `npm cache clean --force`
- Delete `node_modules` and `package-lock.json`, then retry
- Check Node.js version

### Step 7: Setup Database

```bash
# Still in bn88-backend-v12 directory

# Run database migrations
npx prisma migrate dev

# You'll be prompted to name the migration
# Enter: "initial_setup" or press Enter for default
```

**What this does:**
- Creates the SQLite database file (`prisma/dev.db`)
- Runs all migrations to create tables
- Generates Prisma Client

### Step 8: Seed Initial Data

```bash
# Still in bn88-backend-v12 directory

npm run seed:dev
```

**What this does:**
- Creates the default admin user (`root@bn9.local`)
- Creates the default tenant (`bn9`)
- Seeds any initial data

**Expected output:**
```
✓ Admin user created: root@bn9.local
✓ Tenant created: bn9
✓ Seed completed successfully
```

### Step 9: Install Frontend Dependencies

```bash
cd ../bn88-frontend-dashboard-v12
npm install
```

**Expected output:**
- No errors
- All dependencies installed successfully

### Step 10: Test Backend Individually

```bash
# In bn88-backend-v12 directory
npm run dev
```

**You should see:**
```
🚀 Server running on http://localhost:3000
📊 Prisma connected to SQLite
✓ Admin API enabled
```

**Test it:**
Open http://localhost:3000/api/health in your browser.

**Expected response:**
```json
{
  "ok": true,
  "time": "2026-02-11T...",
  "adminApi": true
}
```

**Stop the server:** Press `Ctrl+C`

### Step 11: Test Frontend Individually

```bash
# In bn88-frontend-dashboard-v12 directory
npm run dev
```

**You should see:**
```
VITE v5.x.x  ready in 500 ms
➜  Local:   http://localhost:5555/
```

**Test it:**
Open http://localhost:5555 in your browser.

**You should see:** The login page

**Stop the server:** Press `Ctrl+C`

### Step 12: Start Both Servers Together
 main

From the repository root:

```powershell
 copilot/fix-bn88-project-issues-again
.\start-dev.ps1
```

This will:
- Open two PowerShell windows
- Start backend on port 3000
- Start frontend on port 5555
- Show you the URLs to access

#### Option B: Start Manually

**Terminal 1 - Backend:**
```powershell
cd bn88-backend-v12
npm run dev
```

**Terminal 2 - Frontend:**
```powershell
cd bn88-frontend-dashboard-v12
npm run dev
```

### 7. Verify Everything Works

#### Run Smoke Tests

```powershell
# From repository root
.\smoke.ps1
```

This will test:
- ✅ Port availability (3000, 5555)
- ✅ Backend health endpoint
- ✅ Frontend accessibility
- ✅ API authentication endpoint

#### Manual Testing

1. **Open Frontend:** http://localhost:5555
2. **Login with:**
   - Email: `root@bn9.local`
   - Password: `bn9@12345`
   - Tenant: `bn9`
3. **Check Backend API:** http://localhost:3000/api/health

You should see:
```json
{
  "ok": true,
  "time": "2024-XX-XXTXX:XX:XX.XXXZ",
  "adminApi": true
}
```

## 🎯 Quick Reference

### Useful Commands

```powershell
# Start development stack
.\start-dev.ps1

# Stop development stack
.\stop-dev.ps1

# Run smoke tests
.\smoke.ps1

# Backend commands (from bn88-backend-v12/)
npm run dev              # Start backend server
npm run seed:dev         # Seed database with test data
npm run prisma:studio    # Open Prisma Studio (database GUI)
npx prisma migrate dev   # Create and apply migrations
npx prisma db push       # Push schema changes (dev only)

# Frontend commands (from bn88-frontend-dashboard-v12/)
npm run dev              # Start frontend server
npm run build            # Build for production
npm run preview          # Preview production build
npm run typecheck        # Check TypeScript types
```

### Default Ports

| Service | Port | URL |
|---------|------|-----|
| Frontend Dashboard | 5555 | http://localhost:5555 |
| Backend API | 3000 | http://localhost:3000 |
| Backend Health | 3000 | http://localhost:3000/api/health |
| Redis (Docker) | 6380 | redis://localhost:6380 |
| PostgreSQL (Docker) | 5432 | postgresql://localhost:5432 |
| Prisma Studio | 5556 | http://localhost:5556 |
| LINE Platform | 8080 | http://localhost:8080 |

## 🔒 Security Notes

### Development Defaults

The `.env.example` files contain **default development values** that are:
- ✅ Safe to commit to Git
- ⚠️ **NOT safe for production**
- ⚠️ Should be changed before deploying

### Before Production

Change these values:
- `JWT_SECRET` - Use a strong random string
- `SECRET_ENC_KEY_BN9` - Use a 32-character hex string
- `ADMIN_PASSWORD` - Use a strong password
- Database credentials
- LINE API credentials (if using)
- OpenAI API keys (if using)

## 🐛 Troubleshooting

### Common Issues

#### "Port 3000 is already in use"

```powershell
# Kill processes on ports
.\stop-dev.ps1

# Or manually check what's using the port
Get-NetTCPConnection -LocalPort 3000 -State Listen
```

#### "Cannot find module 'xyz'"

```powershell
# Reinstall dependencies
cd bn88-backend-v12
rm -r node_modules
npm install

# Or use npm clean install
npm ci
```

#### "Prisma Client did not initialize"

```powershell
cd bn88-backend-v12
npx prisma generate
```

#### "Database connection failed"

1. Check `DATABASE_URL` in `.env`
2. If using Docker, ensure container is running:
   ```powershell
   docker-compose up -d db
   ```
3. Test connection:
   ```powershell
   npx prisma db push
   ```

#### "Frontend can't connect to backend"

1. Check backend is running on port 3000
2. Check `vite.config.ts` proxy settings
3. Check CORS settings in backend `.env` (`ALLOWED_ORIGINS`)

### Getting Help

1. Check existing issues: https://github.com/josho007237-max/-bn88-new-clean/issues
2. Run smoke tests: `.\smoke.ps1`
3. Check backend logs in the PowerShell window
4. Check browser console for frontend errors

## 📚 Next Steps

After setup, you might want to:

1. **Read the Documentation:**
   - `README.md` - Project overview
   - `RUNBOOK.md` - Operational guide
   - `RUNBOOK-LOCAL.md` - Local development guide

2. **Explore the Code:**
   - Backend: `bn88-backend-v12/src/`
   - Frontend: `bn88-frontend-dashboard-v12/src/`
   - Database Schema: `bn88-backend-v12/prisma/schema.prisma`

3. **Try the Features:**
   - Create a bot
   - Setup chat automation
   - Configure knowledge base
   - Create marketing campaigns

4. **Customize:**
   - Add your LINE credentials
   - Connect your database
   - Setup your own tenant

## 🤝 Contributing

See `CONTRIBUTING.md` for guidelines on contributing to this project.

## 📞 Support

For support and questions:
- GitHub Issues: https://github.com/josho007237-max/-bn88-new-clean/issues
- Documentation: Check the `/docs` directory
- Runbook: `RUNBOOK.md` and `RUNBOOK-LOCAL.md`
=======
cd ..  # Back to root if you're in a subdirectory
.\start-dev.ps1
```

**What this does:**
- Opens two PowerShell windows
- Starts backend on port 3000
- Starts frontend on port 5555

### Step 13: Access the Application

1. Open your browser to http://localhost:5555
2. You should see the login page
3. Enter the default credentials:
   - **Email:** `root@bn9.local`
   - **Password:** `bn9@12345`
   - **Tenant:** `bn9` (usually auto-filled)
4. Click "Login"

**Expected result:** You should see the dashboard!

### Step 14: Run Smoke Tests

Open a new PowerShell window and run:

```powershell
.\smoke.ps1
```

**Expected output:**
```
===============================================
  BN88 Smoke Test Suite
===============================================

Phase 1: Port Availability
  ✓ PASS - Backend API
  ✓ PASS - Frontend Dashboard

Phase 2: Backend Health Checks
  ✓ PASS - Backend Health (API)

...

All tests passed! ✓
```

### Step 15: Stop the Servers

When you're done:

```powershell
.\stop-dev.ps1
```

---

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Backend runs on http://localhost:3000
- [ ] Frontend runs on http://localhost:5555
- [ ] Health endpoint responds: http://localhost:3000/api/health
- [ ] Login page loads at http://localhost:5555
- [ ] Can login with `root@bn9.local` / `bn9@12345`
- [ ] Dashboard loads after login
- [ ] All smoke tests pass

---

## 🎯 Next Steps

Now that your environment is set up:

1. **Explore the Dashboard**
   - Navigate through different pages
   - Check out the admin features

2. **Review the Code**
   - Backend: `bn88-backend-v12/src/`
   - Frontend: `bn88-frontend-dashboard-v12/src/`

3. **Read the Documentation**
   - `README.md` - Main documentation
   - `RUNBOOK.md` - Operations guide
   - `RUNBOOK-LOCAL.md` - Local development tips

4. **Customize Your Setup**
   - Change admin password
   - Configure LINE integration (if needed)
   - Add custom features

---

## 🔧 Troubleshooting

### Issue: "Port already in use"

**Solution:**
```powershell
.\stop-dev.ps1
.\start-dev.ps1
```

### Issue: "Prisma Client not found"

**Solution:**
```bash
cd bn88-backend-v12
npx prisma generate
```

### Issue: "Cannot find module"

**Solution:**
```bash
# Delete and reinstall
cd bn88-backend-v12
rm -rf node_modules package-lock.json
npm install

cd ../bn88-frontend-dashboard-v12
rm -rf node_modules package-lock.json
npm install
```

### Issue: "Database migration failed"

**Solution:**
```bash
cd bn88-backend-v12
npx prisma migrate reset --force
npm run seed:dev
```

### Issue: "Login fails with 401"

**Checklist:**
- [ ] Backend is running (check http://localhost:3000/api/health)
- [ ] Using correct credentials: `root@bn9.local` / `bn9@12345`
- [ ] Database was seeded: `npm run seed:dev`
- [ ] Check browser console for errors

### Issue: "npm install fails"

**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Verify Node version
node --version  # Should be v18.x.x

# Try again
npm install
```

---

## 🆘 Getting Help

If you encounter issues not covered here:

1. **Check the logs** in the terminal windows
2. **Run verbose smoke tests:** `.\smoke.ps1 -Verbose`
3. **Review error messages** carefully
4. **Search GitHub Issues:** [Issues](https://github.com/josho007237-max/-bn88-new-clean/issues)
5. **Ask for help** in the team chat or create an issue

---

## 📚 Additional Resources

- [Node.js Documentation](https://nodejs.org/docs/)
- [Prisma Documentation](https://www.prisma.io/docs/)
- [Vite Documentation](https://vitejs.dev/)
- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

---

**🎉 Congratulations! You've successfully set up BN88!**

Happy coding! 🚀
 main

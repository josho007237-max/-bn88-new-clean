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
git clone https://github.com/josho007237-max/-bn88-new-clean.git
cd -bn88-new-clean
```

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

From the repository root:

```powershell
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

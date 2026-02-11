#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup script for BN88 project - first-time installation
.DESCRIPTION
    This script automates the initial setup process for the BN88 project:
    - Creates .env files from examples
    - Installs dependencies for all projects
    - Sets up the database
    - Seeds initial data
.EXAMPLE
    .\setup.ps1
#>

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 BN88 Project Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to print section header
function Write-Section {
    param([string]$title)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host "▶ $title" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
}

# Function to check if command exists
function Test-Command {
    param([string]$command)
    try {
        if (Get-Command $command -ErrorAction SilentlyContinue) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

# Check prerequisites
Write-Section "Checking Prerequisites"

# Check Node.js
if (Test-Command "node") {
    $nodeVersion = node --version
    Write-Host "  ✅ Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ Node.js: Not found" -ForegroundColor Red
    Write-Host "  Please install Node.js 18.x from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check npm
if (Test-Command "npm") {
    $npmVersion = npm --version
    Write-Host "  ✅ npm: $npmVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ npm: Not found" -ForegroundColor Red
    exit 1
}

# Check .nvmrc
$nvmrcPath = Join-Path $root ".nvmrc"
if (Test-Path $nvmrcPath) {
    $requiredVersion = (Get-Content $nvmrcPath).Trim()
    Write-Host "  ℹ️  Required Node.js version: $requiredVersion" -ForegroundColor Blue
}

# Setup Backend
Write-Section "Setting Up Backend (bn88-backend-v12)"

$backendPath = Join-Path $root "bn88-backend-v12"
Set-Location $backendPath

# Create .env file
$envExample = Join-Path $backendPath ".env.example"
$envFile = Join-Path $backendPath ".env"

if (Test-Path $envFile) {
    Write-Host "  ⚠️  .env file already exists, skipping..." -ForegroundColor Yellow
} else {
    Copy-Item $envExample $envFile
    Write-Host "  ✅ Created .env file from .env.example" -ForegroundColor Green
}

# Install dependencies
Write-Host "  📦 Installing dependencies..." -ForegroundColor Cyan
npm install --legacy-peer-deps | Out-Null
Write-Host "  ✅ Dependencies installed" -ForegroundColor Green

# Setup Prisma
Write-Host "  🔨 Generating Prisma client..." -ForegroundColor Cyan
npx prisma generate | Out-Null
Write-Host "  ✅ Prisma client generated" -ForegroundColor Green

Write-Host "  🔨 Creating database..." -ForegroundColor Cyan
npx prisma db push | Out-Null
Write-Host "  ✅ Database created" -ForegroundColor Green

Write-Host "  🌱 Seeding database..." -ForegroundColor Cyan
npm run seed:dev | Out-Null
Write-Host "  ✅ Database seeded" -ForegroundColor Green

# Setup Frontend
Write-Section "Setting Up Frontend (bn88-frontend-dashboard-v12)"

$frontendPath = Join-Path $root "bn88-frontend-dashboard-v12"
Set-Location $frontendPath

# Create .env file
$envExample = Join-Path $frontendPath ".env.example"
$envFile = Join-Path $frontendPath ".env"

if (Test-Path $envFile) {
    Write-Host "  ⚠️  .env file already exists, skipping..." -ForegroundColor Yellow
} else {
    Copy-Item $envExample $envFile
    Write-Host "  ✅ Created .env file from .env.example" -ForegroundColor Green
}

# Install dependencies
Write-Host "  📦 Installing dependencies..." -ForegroundColor Cyan
npm install | Out-Null
Write-Host "  ✅ Dependencies installed" -ForegroundColor Green

# Optional: Setup LINE Engagement Platform
Write-Section "Setting Up LINE Engagement Platform (Optional)"

$lepPath = Join-Path $root "line-engagement-platform"
Set-Location $lepPath

$envExample = Join-Path $lepPath ".env.example"
$envFile = Join-Path $lepPath ".env"

if (Test-Path $envFile) {
    Write-Host "  ⚠️  .env file already exists, skipping..." -ForegroundColor Yellow
} else {
    Copy-Item $envExample $envFile
    Write-Host "  ✅ Created .env file from .env.example" -ForegroundColor Green
    Write-Host "  ℹ️  Edit .env to add LINE credentials" -ForegroundColor Blue
}

Write-Host "  ⏭️  Skipping npm install for LINE platform (optional component)" -ForegroundColor Yellow
Write-Host "  💡 Run 'cd line-engagement-platform && npm install' when needed" -ForegroundColor Blue

# Return to root
Set-Location $root

# Final Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Start the development environment:" -ForegroundColor White
Write-Host "   .\start-dev.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Open your browser:" -ForegroundColor White
Write-Host "   Frontend: http://localhost:5555" -ForegroundColor Yellow
Write-Host "   Backend:  http://localhost:3000" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Login with default credentials:" -ForegroundColor White
Write-Host "   Email:    root@bn9.local" -ForegroundColor Yellow
Write-Host "   Password: bn9@12345" -ForegroundColor Yellow
Write-Host "   Tenant:   bn9" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. (Optional) Start Redis for queue/cache features:" -ForegroundColor White
Write-Host "   docker run --rm -p 6380:6379 redis:7-alpine" -ForegroundColor Yellow
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "   README.md - Project overview" -ForegroundColor Gray
Write-Host "   RUNBOOK-LOCAL.md - Development guide" -ForegroundColor Gray
Write-Host "   TROUBLESHOOTING.md - Common issues" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  Remember to change default credentials in production!" -ForegroundColor Yellow
Write-Host ""

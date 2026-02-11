 copilot/fix-bn88-project-issues-again
# BN88 start-dev.ps1
copilot/fix-and-improve-bn88-project
# Get the script's directory as the root (works cross-platform)
$root = $PSScriptRoot

Write-Host "Starting BN88 dev stack..." -ForegroundColor Cyan
Write-Host "Root directory: $root" -ForegroundColor Gray
=======
# Dynamically determine the repository root directory
$root = Split-Path -Parent $PSCommandPath

Write-Host "Starting BN88 dev stack..." -ForegroundColor Cyan
Write-Host "Repository root: $root" -ForegroundColor Gray

# Check if directories exist
$backendPath = Join-Path $root "bn88-backend-v12"
$frontendPath = Join-Path $root "bn88-frontend-dashboard-v12"

if (-not (Test-Path $backendPath)) {
    Write-Host "ERROR: Backend directory not found: $backendPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $frontendPath)) {
    Write-Host "ERROR: Frontend directory not found: $frontendPath" -ForegroundColor Red
    exit 1
}

# Check if .env files exist
$backendEnv = Join-Path $backendPath ".env"
$frontendEnv = Join-Path $frontendPath ".env"

if (-not (Test-Path $backendEnv)) {
    Write-Host "WARNING: Backend .env not found. Copy .env.example to .env" -ForegroundColor Yellow
    Write-Host "  Run: copy `"$backendPath\.env.example`" `"$backendEnv`"" -ForegroundColor Yellow
}

if (-not (Test-Path $frontendEnv)) {
    Write-Host "WARNING: Frontend .env not found. Copy .env.example to .env" -ForegroundColor Yellow
    Write-Host "  Run: copy `"$frontendPath\.env.example`" `"$frontendEnv`"" -ForegroundColor Yellow
}

Write-Host "`nStarting backend and frontend in separate windows..." -ForegroundColor Cyan
 main

# Backend
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$backendPath`"; Write-Host 'Backend starting on port 3000...' -ForegroundColor Cyan; npm run dev"

# Wait a moment before starting frontend
Start-Sleep -Seconds 2

# Frontend
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$frontendPath`"; Write-Host 'Frontend starting on port 5555...' -ForegroundColor Cyan; npm run dev"

Write-Host "`n✓ Started: backend(3000), frontend(5555)" -ForegroundColor Green
Write-Host "✓ Open: http://localhost:5555" -ForegroundColor Green
Write-Host "✓ API Health: http://localhost:3000/api/health" -ForegroundColor Green
Write-Host "`nDefault credentials:" -ForegroundColor Cyan
Write-Host "  Email: root@bn9.local" -ForegroundColor Gray
Write-Host "  Password: bn9@12345" -ForegroundColor Gray
Write-Host "  Tenant: bn9" -ForegroundColor Gray
=======
# ===============================================
# BN88 Development Server Startup Script
# ===============================================
# Starts both backend and frontend in separate terminal windows
# ===============================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BN88 Development Stack Startup" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Get the absolute path of the script directory
$scriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Write-Host "Project root: $scriptRoot" -ForegroundColor Gray

# Define project paths
$backendPath = Join-Path $scriptRoot "bn88-backend-v12"
$frontendPath = Join-Path $scriptRoot "bn88-frontend-dashboard-v12"

# Verify paths exist
if (-not (Test-Path $backendPath)) {
    Write-Host "ERROR: Backend directory not found at: $backendPath" -ForegroundColor Red
    Write-Host "Please run this script from the repository root directory." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $frontendPath)) {
    Write-Host "ERROR: Frontend directory not found at: $frontendPath" -ForegroundColor Red
    Write-Host "Please run this script from the repository root directory." -ForegroundColor Red
    exit 1
}

Write-Host "Checking environment files..." -ForegroundColor Yellow

# Check for .env files
$backendEnv = Join-Path $backendPath ".env"
$frontendEnv = Join-Path $frontendPath ".env"

if (-not (Test-Path $backendEnv)) {
    Write-Host "WARNING: Backend .env file not found!" -ForegroundColor Yellow
    Write-Host "  Creating from .env.example..." -ForegroundColor Yellow
    $backendEnvExample = Join-Path $backendPath ".env.example"
    if (Test-Path $backendEnvExample) {
        Copy-Item $backendEnvExample $backendEnv
        Write-Host "  ✓ Created $backendEnv" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: .env.example not found in backend!" -ForegroundColor Red
    }
}

if (-not (Test-Path $frontendEnv)) {
    Write-Host "WARNING: Frontend .env file not found!" -ForegroundColor Yellow
    Write-Host "  Creating from .env.example..." -ForegroundColor Yellow
    $frontendEnvExample = Join-Path $frontendPath ".env.example"
    if (Test-Path $frontendEnvExample) {
        Copy-Item $frontendEnvExample $frontendEnv
        Write-Host "  ✓ Created $frontendEnv" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: .env.example not found in frontend!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Starting development servers..." -ForegroundColor Cyan
Write-Host ""

# Start Backend Server
Write-Host "Starting Backend Server (Port 3000)..." -ForegroundColor Green
$backendCommand = "cd `"$backendPath`"; Write-Host '=== BN88 Backend Server ===' -ForegroundColor Cyan; Write-Host 'Port: 3000' -ForegroundColor Green; Write-Host ''; npm run dev"
Start-Process pwsh -ArgumentList "-NoExit", "-Command", $backendCommand

Start-Sleep -Seconds 2

# Start Frontend Server
Write-Host "Starting Frontend Server (Port 5555)..." -ForegroundColor Green
$frontendCommand = "cd `"$frontendPath`"; Write-Host '=== BN88 Frontend Dashboard ===' -ForegroundColor Cyan; Write-Host 'Port: 5555' -ForegroundColor Green; Write-Host ''; npm run dev"
Start-Process pwsh -ArgumentList "-NoExit", "-Command", $frontendCommand

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "  Development servers started successfully!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Backend:  http://localhost:3000" -ForegroundColor Yellow
Write-Host "Frontend: http://localhost:5555" -ForegroundColor Yellow
Write-Host "Health:   http://localhost:3000/api/health" -ForegroundColor Yellow
Write-Host ""
Write-Host "Default Login Credentials:" -ForegroundColor Cyan
Write-Host "  Email:    root@bn9.local" -ForegroundColor White
Write-Host "  Password: bn9@12345" -ForegroundColor White
Write-Host "  Tenant:   bn9" -ForegroundColor White
Write-Host ""
Write-Host "To stop all services, run: .\stop-dev.ps1" -ForegroundColor Gray
Write-Host "===============================================" -ForegroundColor Green
 main

# BN88 start-dev.ps1
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

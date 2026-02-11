# BN88 start-dev.ps1
# Auto-detect project root (script directory)
$root = $PSScriptRoot

Write-Host "Starting BN88 dev stack..." -ForegroundColor Cyan
Write-Host "Project root: $root" -ForegroundColor Gray

# Backend
Write-Host "Starting backend on port 3000..." -ForegroundColor Cyan
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$root\bn88-backend-v12`"; npm run dev"

# Frontend
Write-Host "Starting frontend on port 5555..." -ForegroundColor Cyan
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$root\bn88-frontend-dashboard-v12`"; npm run dev"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Started: backend(3000), frontend(5555)" -ForegroundColor Green
Write-Host "🌐 Open: http://localhost:5555" -ForegroundColor Green
Write-Host "🔑 Login: root@bn9.local / bn9@12345" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

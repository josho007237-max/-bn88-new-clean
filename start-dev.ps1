# BN88 start-dev.ps1
$root = "C:\BN88\BN88-new-clean"

Write-Host "Starting BN88 dev stack..." -ForegroundColor Cyan

# Backend
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$root\bn88-backend-v12`"; npm run dev"

# Frontend
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$root\bn88-frontend-dashboard-v12`"; npm run dev"

Write-Host "Started: backend(3000), frontend(5555)" -ForegroundColor Green
Write-Host "Open: http://localhost:5555" -ForegroundColor Green

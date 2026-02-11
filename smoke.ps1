#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Smoke test script for BN88 project
.DESCRIPTION
    Performs basic smoke tests to verify the project is set up correctly
#>

$ErrorActionPreference = "SilentlyContinue"
$root = $PSScriptRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🔍 BN88 Project Smoke Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Cyan
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "  ✅ Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ Node.js: Not found" -ForegroundColor Red
    $allPassed = $false
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Cyan
$npmVersion = npm --version 2>$null
if ($npmVersion) {
    Write-Host "  ✅ npm: $npmVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ npm: Not found" -ForegroundColor Red
    $allPassed = $false
}

# Check .nvmrc
Write-Host "Checking .nvmrc..." -ForegroundColor Cyan
$nvmrcPath = Join-Path $root ".nvmrc"
if (Test-Path $nvmrcPath) {
    $requiredVersion = Get-Content $nvmrcPath -Raw
    $requiredVersion = $requiredVersion.Trim()
    Write-Host "  ✅ .nvmrc: Node $requiredVersion required" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  .nvmrc: Not found" -ForegroundColor Yellow
}

# Check backend .env
Write-Host "Checking backend .env..." -ForegroundColor Cyan
$backendEnvExample = Join-Path $root "bn88-backend-v12\.env.example"
$backendEnv = Join-Path $root "bn88-backend-v12\.env"
if (Test-Path $backendEnv) {
    Write-Host "  ✅ Backend .env exists" -ForegroundColor Green
} else {
    if (Test-Path $backendEnvExample) {
        Write-Host "  ⚠️  Backend .env missing (copy from .env.example)" -ForegroundColor Yellow
    } else {
        Write-Host "  ❌ Backend .env and .env.example missing" -ForegroundColor Red
        $allPassed = $false
    }
}

# Check frontend .env
Write-Host "Checking frontend .env..." -ForegroundColor Cyan
$frontendEnvExample = Join-Path $root "bn88-frontend-dashboard-v12\.env.example"
$frontendEnv = Join-Path $root "bn88-frontend-dashboard-v12\.env"
if (Test-Path $frontendEnv) {
    Write-Host "  ✅ Frontend .env exists" -ForegroundColor Green
} else {
    if (Test-Path $frontendEnvExample) {
        Write-Host "  ⚠️  Frontend .env missing (copy from .env.example)" -ForegroundColor Yellow
    } else {
        Write-Host "  ❌ Frontend .env and .env.example missing" -ForegroundColor Red
        $allPassed = $false
    }
}

# Check backend node_modules
Write-Host "Checking backend dependencies..." -ForegroundColor Cyan
$backendNodeModules = Join-Path $root "bn88-backend-v12\node_modules"
if (Test-Path $backendNodeModules) {
    Write-Host "  ✅ Backend node_modules exists" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Backend node_modules missing (run 'npm install')" -ForegroundColor Yellow
}

# Check frontend node_modules
Write-Host "Checking frontend dependencies..." -ForegroundColor Cyan
$frontendNodeModules = Join-Path $root "bn88-frontend-dashboard-v12\node_modules"
if (Test-Path $frontendNodeModules) {
    Write-Host "  ✅ Frontend node_modules exists" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Frontend node_modules missing (run 'npm install')" -ForegroundColor Yellow
}

# Check for Docker
Write-Host "Checking Docker..." -ForegroundColor Cyan
$dockerVersion = docker --version 2>$null
if ($dockerVersion) {
    Write-Host "  ✅ Docker: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Docker: Not found (optional for Redis)" -ForegroundColor Yellow
}

# Check if ports are available
Write-Host "Checking port availability..." -ForegroundColor Cyan
$ports = @(3000, 5555, 6380, 8080)
foreach ($port in $ports) {
    $connection = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($connection) {
        $procId = $connection.OwningProcess
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        Write-Host "  ⚠️  Port $port is in use by $($proc.ProcessName) (PID: $procId)" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ Port $port is available" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "✅ Smoke test PASSED" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Copy .env.example to .env in backend and frontend" -ForegroundColor White
    Write-Host "2. Run 'npm install' in both directories" -ForegroundColor White
    Write-Host "3. Run '.\start-dev.ps1' to start the project" -ForegroundColor White
} else {
    Write-Host "❌ Smoke test FAILED" -ForegroundColor Red
    Write-Host "Please fix the issues above before proceeding." -ForegroundColor Yellow
    exit 1
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

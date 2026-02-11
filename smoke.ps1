copilot/fix-bn88-project-issues
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
=======
# ===============================================
# BN88 Smoke Test Script
# ===============================================
# Performs health checks and basic API tests to verify
# that the development environment is running correctly
# ===============================================

param(
    [switch]$Verbose,
    [switch]$SkipAPI
)

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BN88 Smoke Test Suite" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$script:testsPassed = 0
$script:testsFailed = 0
$script:testsSkipped = 0

# Helper function to test HTTP endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Url,
        [int]$ExpectedStatus = 200,
        [hashtable]$Headers = @{},
        [string]$Method = "GET",
        [object]$Body = $null
    )
    
    Write-Host "Testing: $Name" -ForegroundColor Yellow
    Write-Host "  URL: $Url" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            TimeoutSec = 10
            UseBasicParsing = $true
        }
        
        if ($Headers.Count -gt 0) {
            $params.Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-WebRequest @params -ErrorAction Stop
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "  ✓ PASS" -ForegroundColor Green
            Write-Host "    Status: $($response.StatusCode)" -ForegroundColor Gray
            if ($Verbose -and $response.Content) {
                Write-Host "    Response: $($response.Content.Substring(0, [Math]::Min(200, $response.Content.Length)))" -ForegroundColor Gray
            }
            $script:testsPassed++
            return $true
        } else {
            Write-Host "  ✗ FAIL" -ForegroundColor Red
            Write-Host "    Expected: $ExpectedStatus, Got: $($response.StatusCode)" -ForegroundColor Red
            $script:testsFailed++
            return $false
        }
    }
    catch {
        Write-Host "  ✗ FAIL" -ForegroundColor Red
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
        $script:testsFailed++
        return $false
    }
}

# Helper function to test port availability
function Test-Port {
    param(
        [string]$Name,
        [string]$Host = "127.0.0.1",
        [int]$Port
    )
    
    Write-Host "Testing: $Name (Port $Port)" -ForegroundColor Yellow
    
    try {
        $connection = Test-NetConnection -ComputerName $Host -Port $Port -WarningAction SilentlyContinue
        
        if ($connection.TcpTestSucceeded) {
            Write-Host "  ✓ PASS - Port $Port is listening" -ForegroundColor Green
            $script:testsPassed++
            return $true
        } else {
            Write-Host "  ✗ FAIL - Port $Port is not listening" -ForegroundColor Red
            $script:testsFailed++
            return $false
        }
    }
    catch {
        Write-Host "  ✗ FAIL - Error checking port: $($_.Exception.Message)" -ForegroundColor Red
        $script:testsFailed++
        return $false
    }
}

# -----------------------------------------------
# Phase 1: Port Checks
# -----------------------------------------------
Write-Host ""
Write-Host "Phase 1: Port Availability" -ForegroundColor Cyan
Write-Host "-----------------------------------------------" -ForegroundColor Gray

Test-Port -Name "Backend API" -Port 3000
Test-Port -Name "Frontend Dashboard" -Port 5555

# Check optional ports
$redisPort = Test-Port -Name "Redis (Optional)" -Port 6380
if (-not $redisPort) {
    Write-Host "  Note: Redis is optional for basic development" -ForegroundColor Gray
}

# -----------------------------------------------
# Phase 2: Backend Health Checks
# -----------------------------------------------
Write-Host ""
Write-Host "Phase 2: Backend Health Checks" -ForegroundColor Cyan
Write-Host "-----------------------------------------------" -ForegroundColor Gray

Test-Endpoint -Name "Backend Root" -Url "http://localhost:3000/"
Test-Endpoint -Name "Backend Health (API)" -Url "http://localhost:3000/api/health"
Test-Endpoint -Name "Backend Health (Redirect)" -Url "http://localhost:3000/health"

# Test Redis health if Redis is running
if ($redisPort) {
    Test-Endpoint -Name "Backend Redis Health" -Url "http://localhost:3000/api/health/redis"
}

# -----------------------------------------------
# Phase 3: Frontend Health Checks
# -----------------------------------------------
Write-Host ""
Write-Host "Phase 3: Frontend Health Checks" -ForegroundColor Cyan
Write-Host "-----------------------------------------------" -ForegroundColor Gray

Test-Endpoint -Name "Frontend Dashboard" -Url "http://localhost:5555/"

# -----------------------------------------------
# Phase 4: API Tests (Optional)
# -----------------------------------------------
if (-not $SkipAPI) {
    Write-Host ""
    Write-Host "Phase 4: API Integration Tests" -ForegroundColor Cyan
    Write-Host "-----------------------------------------------" -ForegroundColor Gray
    
    # Test admin login endpoint (should return 400 or 401 without credentials)
    Write-Host "Testing: Admin Login Endpoint" -ForegroundColor Yellow
    Write-Host "  URL: http://localhost:3000/api/admin/auth/login" -ForegroundColor Gray
    
    try {
        $loginBody = @{
            email = "test@example.com"
            password = "wrongpassword"
        } | ConvertTo-Json
        
        $headers = @{
            "Content-Type" = "application/json"
            "x-tenant" = "bn9"
        }
        
        $response = Invoke-WebRequest -Uri "http://localhost:3000/api/admin/auth/login" `
            -Method POST `
            -Body $loginBody `
            -Headers $headers `
            -TimeoutSec 10 `
            -UseBasicParsing `
            -ErrorAction SilentlyContinue
            
        Write-Host "  ✓ PASS - Login endpoint is responding" -ForegroundColor Green
        $script:testsPassed++
    }
    catch {
        # 400/401 are expected for invalid credentials
        if ($_.Exception.Response.StatusCode -eq 400 -or $_.Exception.Response.StatusCode -eq 401) {
            Write-Host "  ✓ PASS - Login endpoint is responding (rejected invalid credentials)" -ForegroundColor Green
            $script:testsPassed++
        } else {
            Write-Host "  ✗ FAIL - Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
            $script:testsFailed++
        }
    }
} else {
    Write-Host ""
    Write-Host "Phase 4: Skipped (use -SkipAPI parameter)" -ForegroundColor Gray
}

# -----------------------------------------------
# Test Summary
# -----------------------------------------------
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Test Results Summary" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Passed:  $script:testsPassed" -ForegroundColor Green
Write-Host "  Failed:  $script:testsFailed" -ForegroundColor $(if ($script:testsFailed -gt 0) { "Red" } else { "Gray" })
Write-Host "  Skipped: $script:testsSkipped" -ForegroundColor Gray
Write-Host ""

if ($script:testsFailed -eq 0) {
    Write-Host "All tests passed! ✓" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your development environment is ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Quick Links:" -ForegroundColor Cyan
    Write-Host "  - Frontend Dashboard: http://localhost:5555" -ForegroundColor White
    Write-Host "  - Backend API:        http://localhost:3000/api" -ForegroundColor White
    Write-Host "  - API Health:         http://localhost:3000/api/health" -ForegroundColor White
    Write-Host ""
    Write-Host "Default Login:" -ForegroundColor Cyan
    Write-Host "  Email:    root@bn9.local" -ForegroundColor White
    Write-Host "  Password: bn9@12345" -ForegroundColor White
    Write-Host "  Tenant:   bn9" -ForegroundColor White
    Write-Host ""
    exit 0
} else {
    Write-Host "Some tests failed. Please check the output above." -ForegroundColor Red
    Write-Host ""
    Write-Host "Common Issues:" -ForegroundColor Yellow
    Write-Host "  1. Servers not running - Run: .\start-dev.ps1" -ForegroundColor White
    Write-Host "  2. Port conflicts - Run: .\stop-dev.ps1 then .\start-dev.ps1" -ForegroundColor White
    Write-Host "  3. Missing dependencies - Run: npm install in backend and frontend" -ForegroundColor White
    Write-Host "  4. Missing .env files - Check .env.example in backend and frontend" -ForegroundColor White
    Write-Host ""
    exit 1
}
 main

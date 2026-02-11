# BN88 smoke.ps1 - Smoke Test Suite
# Tests basic functionality of the BN88 stack

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BN88 Smoke Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsFailed = 0

# Helper function to test HTTP endpoint
function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Name,
        [int]$ExpectedStatus = 200
    )
    
    Write-Host "Testing: $Name" -ForegroundColor Yellow
    Write-Host "  URL: $Url" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "  ✓ PASS - Status: $($response.StatusCode)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  ✗ FAIL - Status: $($response.StatusCode), Expected: $ExpectedStatus" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "  ✗ FAIL - Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Helper function to test port
function Test-Port {
    param(
        [int]$Port,
        [string]$Service
    )
    
    Write-Host "Testing: $Service on port $Port" -ForegroundColor Yellow
    
    try {
        $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
        if ($connection) {
            Write-Host "  ✓ PASS - Port $Port is listening" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  ✗ FAIL - Port $Port is not listening" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "  ✗ FAIL - Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "1. PORT CHECKS" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan

# Test Backend Port
if (Test-Port -Port 3000 -Service "Backend API") {
    $testsPassed++
} else {
    $testsFailed++
    Write-Host "  Hint: Run 'npm run dev' in bn88-backend-v12/" -ForegroundColor Yellow
}

# Test Frontend Port
if (Test-Port -Port 5555 -Service "Frontend Dashboard") {
    $testsPassed++
} else {
    $testsFailed++
    Write-Host "  Hint: Run 'npm run dev' in bn88-frontend-dashboard-v12/" -ForegroundColor Yellow
}

# Test Redis Port (optional)
Write-Host "Testing: Redis on port 6380 (optional)" -ForegroundColor Yellow
$redisRunning = Test-NetConnection -ComputerName localhost -Port 6380 -WarningAction SilentlyContinue -InformationLevel Quiet
if ($redisRunning) {
    Write-Host "  ✓ PASS - Redis is running" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  ⚠ SKIP - Redis not running (optional for development)" -ForegroundColor Yellow
    Write-Host "  Hint: Run 'docker-compose up redis' to start Redis" -ForegroundColor Gray
}

Write-Host ""
Write-Host "2. HEALTH CHECK ENDPOINTS" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan

# Test Backend Health Endpoint
if (Test-Endpoint -Url "http://localhost:3000/api/health" -Name "Backend Health Check") {
    $testsPassed++
} else {
    $testsFailed++
}

# Test Frontend (basic connectivity)
if (Test-Endpoint -Url "http://localhost:5555" -Name "Frontend Homepage") {
    $testsPassed++
} else {
    $testsFailed++
}

Write-Host ""
Write-Host "3. API TESTS" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan

# Test Backend Auth Endpoint (should return 400/401 without credentials)
Write-Host "Testing: Backend Auth Endpoint" -ForegroundColor Yellow
Write-Host "  URL: http://localhost:3000/api/admin/auth/login" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/admin/auth/login" -Method POST -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host "  ✗ FAIL - Expected error response, got: $($response.StatusCode)" -ForegroundColor Red
    $testsFailed++
} catch {
    # Expected to fail (400/401) without credentials
    if ($_.Exception.Response.StatusCode -in @(400, 401)) {
        Write-Host "  ✓ PASS - Auth endpoint responding correctly (401/400 without credentials)" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "  ✗ FAIL - Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
        $testsFailed++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "✓ All tests passed! The stack is healthy." -ForegroundColor Green
    Write-Host ""
    Write-Host "Quick Start:" -ForegroundColor Cyan
    Write-Host "  1. Open http://localhost:5555" -ForegroundColor Gray
    Write-Host "  2. Login with:" -ForegroundColor Gray
    Write-Host "     Email: root@bn9.local" -ForegroundColor Gray
    Write-Host "     Password: bn9@12345" -ForegroundColor Gray
    Write-Host "     Tenant: bn9" -ForegroundColor Gray
    exit 0
} else {
    Write-Host "✗ Some tests failed. Please check the errors above." -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Make sure you ran: .\start-dev.ps1" -ForegroundColor Gray
    Write-Host "  - Check that .env files exist in backend and frontend folders" -ForegroundColor Gray
    Write-Host "  - Run 'npm install' in both backend and frontend folders" -ForegroundColor Gray
    Write-Host "  - Check logs in the PowerShell windows" -ForegroundColor Gray
    exit 1
}
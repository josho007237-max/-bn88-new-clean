#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Smoke tests for BN88 stack

.DESCRIPTION
    Basic smoke tests to verify that backend and frontend are responding
    Run this after starting the development stack with start-dev.ps1

.EXAMPLE
    .\smoke.ps1
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "🔥 BN88 Smoke Tests" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host ""

$backendUrl = "http://localhost:3000"
$frontendUrl = "http://localhost:5555"
$results = @()

# Test 1: Backend Health Check
Write-Host "1️⃣  Testing Backend Health..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "$backendUrl/api/health" -Method Get -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host " ✅ PASS" -ForegroundColor Green
        $results += "Backend Health: PASS"
    } else {
        Write-Host " ❌ FAIL (Status: $($response.StatusCode))" -ForegroundColor Red
        $results += "Backend Health: FAIL"
    }
} catch {
    Write-Host " ❌ FAIL (Error: $($_.Exception.Message))" -ForegroundColor Red
    $results += "Backend Health: FAIL"
}

# Test 2: Backend Stats Endpoint
Write-Host "2️⃣  Testing Backend Stats..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "$backendUrl/api/stats" -Method Get -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host " ✅ PASS" -ForegroundColor Green
        $results += "Backend Stats: PASS"
    } else {
        Write-Host " ❌ FAIL (Status: $($response.StatusCode))" -ForegroundColor Red
        $results += "Backend Stats: FAIL"
    }
} catch {
    Write-Host " ❌ FAIL (Error: $($_.Exception.Message))" -ForegroundColor Red
    $results += "Backend Stats: FAIL"
}

# Test 3: Frontend Accessibility
Write-Host "3️⃣  Testing Frontend..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri $frontendUrl -Method Get -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host " ✅ PASS" -ForegroundColor Green
        $results += "Frontend: PASS"
    } else {
        Write-Host " ❌ FAIL (Status: $($response.StatusCode))" -ForegroundColor Red
        $results += "Frontend: FAIL"
    }
} catch {
    Write-Host " ❌ FAIL (Error: $($_.Exception.Message))" -ForegroundColor Red
    $results += "Frontend: FAIL"
}

# Test 4: Port Availability Check
Write-Host "4️⃣  Testing Port Availability..." -NoNewline
$ports = @(3000, 5555)
$portsOk = $true
foreach ($port in $ports) {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if (-not $conn) {
        $portsOk = $false
        Write-Host ""
        Write-Host "   ⚠️  Port $port is not listening" -ForegroundColor Yellow
    }
}
if ($portsOk) {
    Write-Host " ✅ PASS" -ForegroundColor Green
    $results += "Port Availability: PASS"
} else {
    Write-Host " ❌ FAIL" -ForegroundColor Red
    $results += "Port Availability: FAIL"
}

# Summary
Write-Host ""
Write-Host "===================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
foreach ($result in $results) {
    if ($result -match "PASS") {
        Write-Host "✅ $result" -ForegroundColor Green
    } else {
        Write-Host "❌ $result" -ForegroundColor Red
    }
}

Write-Host ""
$passCount = ($results | Where-Object { $_ -match "PASS" }).Count
$totalCount = $results.Count

if ($passCount -eq $totalCount) {
    Write-Host "🎉 All tests passed! ($passCount/$totalCount)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️  Some tests failed! ($passCount/$totalCount passed)" -ForegroundColor Yellow
    exit 1
}

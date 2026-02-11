# ===============================================
# BN88 Development Server Shutdown Script
# ===============================================
# Stops all development servers by killing processes on specific ports
# ===============================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BN88 Development Stack Shutdown" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Define ports to check and kill
# 3000: Backend API
# 5555: Frontend Dashboard
# 5556-5566: Additional ports (Prisma Studio, etc.)
$ports = @(3000, 5555) + (5556..5566)

$killedCount = 0

foreach ($p in $ports) {
    Write-Host "Checking port $p..." -ForegroundColor Gray
    
    # Get TCP connections listening on this port
    $conns = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
    
    foreach ($c in $conns) {
        # Use $procId instead of $pid to avoid PowerShell reserved variable
        $procId = $c.OwningProcess
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue

        if ($proc) {
            Write-Host "  → Killing PID=$procId ($($proc.ProcessName)) on port $p" -ForegroundColor Yellow
            Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
            $killedCount++
        }
    }
}

Write-Host ""
if ($killedCount -eq 0) {
    Write-Host "No processes found on the specified ports." -ForegroundColor Gray
} else {
    Write-Host "Successfully stopped $killedCount process(es)." -ForegroundColor Green
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "  All development servers stopped." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

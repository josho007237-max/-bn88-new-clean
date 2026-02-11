 copilot/fix-bn88-project-issues-again
# BN88 stop-dev.ps1
Write-Host "Stopping BN88 dev stack..." -ForegroundColor Cyan

=======
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
 main
$ports = @(3000, 5555) + (5556..5566)
$stoppedCount = 0

$killedCount = 0

foreach ($p in $ports) {
    Write-Host "Checking port $p..." -ForegroundColor Gray
    
    # Get TCP connections listening on this port
    $conns = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
    
    foreach ($c in $conns) {
        # Use $procId instead of $pid to avoid PowerShell reserved variable
        $procId = $c.OwningProcess
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue

 copilot/fix-bn88-project-issues-again
    if ($proc) {
      Write-Host "Killing PID=$procId ($($proc.ProcessName)) on port $p" -ForegroundColor Yellow
      Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
      $stoppedCount++
=======
        if ($proc) {
            Write-Host "  → Killing PID=$procId ($($proc.ProcessName)) on port $p" -ForegroundColor Yellow
            Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
            $killedCount++
        }
main
    }
}

 copilot/fix-bn88-project-issues-again
if ($stoppedCount -eq 0) {
    Write-Host "No processes found on monitored ports." -ForegroundColor Gray
} else {
    Write-Host "Stopped $stoppedCount process(es)." -ForegroundColor Green
}

Write-Host "✓ Done." -ForegroundColor Green
=======
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
 main

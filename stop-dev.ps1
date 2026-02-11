# BN88 stop-dev.ps1
Write-Host "Stopping BN88 dev stack..." -ForegroundColor Cyan

$ports = @(3000, 5555) + (5556..5566)
$stoppedCount = 0

foreach ($p in $ports) {
  $conns = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
  foreach ($c in $conns) {
    $procId = $c.OwningProcess
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue

    if ($proc) {
      Write-Host "Killing PID=$procId ($($proc.ProcessName)) on port $p" -ForegroundColor Yellow
      Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
      $stoppedCount++
    }
  }
}

if ($stoppedCount -eq 0) {
    Write-Host "No processes found on monitored ports." -ForegroundColor Gray
} else {
    Write-Host "Stopped $stoppedCount process(es)." -ForegroundColor Green
}

Write-Host "✓ Done." -ForegroundColor Green

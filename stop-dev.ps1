# BN88 stop-dev.ps1
$ports = @(3000, 5555) + (5556..5566)

foreach ($p in $ports) {
  $conns = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
  foreach ($c in $conns) {
    $procId = $c.OwningProcess
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue

    if ($proc) {
      Write-Host "Killing PID=$procId ($($proc.ProcessName)) on port $p" -ForegroundColor Yellow
      Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
    }
  }
}

Write-Host "Stopped." -ForegroundColor Green

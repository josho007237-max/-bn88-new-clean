param()

$listenPid = $null

try {
  $line = netstat -ano | Select-String -Pattern "LISTENING" | Select-String -Pattern ":3000\s"
  if ($line) {
    $parts = ($line | Select-Object -First 1).ToString() -split "\s+"
    $listenPid = $parts[-1]
  }
} catch {
  $listenPid = $null
}

if (-not $listenPid) {
  Write-Host "backend not running" -ForegroundColor Red
  exit 1
}

try {
  $p = Get-CimInstance Win32_Process -Filter "ProcessId=$listenPid"
  if (-not $p) { throw "process not found" }

  Write-Host "backend running (pid=$listenPid)" -ForegroundColor Green
  Write-Host "ProcessName: $($p.Name)"
  Write-Host "Path: $($p.ExecutablePath)"
  Write-Host "CommandLine: $($p.CommandLine)"
} catch {
  Write-Host "backend running (pid=$listenPid)" -ForegroundColor Yellow
  Write-Host "Process details not available" -ForegroundColor Yellow
}

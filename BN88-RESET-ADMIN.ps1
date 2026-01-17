<#  BN88-RESET-ADMIN.ps1
    Reset admin + login + fetch sessions (BN88-new-clean)
#>

param(
  [string]$Root = $PSScriptRoot,
  [string]$Tenant = "bn9",
  [string]$Email = "root@bn9.local",
  [string]$AdminPassword = $env:BN88_ADMIN_PASSWORD
)

$ErrorActionPreference = "Stop"

function Write-Step($t) { Write-Host "`n==== $t ====" -ForegroundColor Cyan }
function Write-Ok($t)   { Write-Host "[OK] $t" -ForegroundColor Green }
function Write-Warn($t) { Write-Host "[WARN] $t" -ForegroundColor Yellow }
function Write-Bad($t)  { Write-Host "[FAIL] $t" -ForegroundColor Red }

function Test-Port([int]$Port) {
  try {
    $c = New-Object System.Net.Sockets.TcpClient
    $iar = $c.BeginConnect("127.0.0.1", $Port, $null, $null)
    $ok = $iar.AsyncWaitHandle.WaitOne(200)
    if ($ok -and $c.Connected) { $c.Close(); return $true }
    $c.Close(); return $false
  } catch { return $false }
}

function Wait-HttpOk([string]$Url, [int]$Tries = 40) {
  for ($i=1; $i -le $Tries; $i++) {
    try {
      $r = Invoke-RestMethod -Uri $Url -Method Get -TimeoutSec 3
      return $r
    } catch {
      Start-Sleep -Milliseconds 300
    }
  }
  return $null
}

function Start-InNewPwsh([string]$WorkDir, [string]$Command, [string]$Title) {
  $pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue)?.Source
  if (-not $pwsh) { $pwsh = (Get-Command powershell).Source }

  $arg = @(
    "-NoExit",
    "-Command",
    "cd `"$WorkDir`"; $Command"
  )
  Start-Process -FilePath $pwsh -ArgumentList $arg -WorkingDirectory $WorkDir -WindowStyle Normal | Out-Null
  Write-Ok "Started: $Title"
}

function Try-Extract-PasswordFromSeed([string]$SeedPath) {
  if (-not (Test-Path $SeedPath)) { return $null }
  $txt = Get-Content $SeedPath -Raw

  # pattern 1: password: "xxx"
  $m = [regex]::Match($txt, 'password\s*:\s*["'']([^"'']+)["'']', 'IgnoreCase')
  if ($m.Success) { return $m.Groups[1].Value }

  # pattern 2: const ADMIN_PASSWORD = "xxx"
  $m2 = [regex]::Match($txt, '(ADMIN_PASSWORD|DEFAULT_ADMIN_PASSWORD|PASSWORD)\s*=\s*["'']([^"'']+)["'']', 'IgnoreCase')
  if ($m2.Success) { return $m2.Groups[2].Value }

  return $null
}

Write-Step "1) Resolve paths"
$BackendDir = Join-Path $Root "bn88-backend-v12"
if (-not (Test-Path $BackendDir)) { throw "Backend folder not found: $BackendDir" }

$SeedAdminTs = Join-Path $BackendDir "src\scripts\seedAdmin.ts"

Write-Host "Root      : $Root"
Write-Host "Backend   : $BackendDir"
Write-Host "SeedAdmin : $SeedAdminTs"

Write-Step "2) Port quick check"
$ports = 3000,5555,5567,8080,5432,6379
foreach ($p in $ports) {
  $isUp = Test-Port $p
  Write-Host ("Port {0} : {1}" -f $p, $(if($isUp){"LISTEN"}else{"-"}))
}

Write-Step "3) Start backend/frontend if not running"
if (-not (Test-Port 3000)) {
  Start-InNewPwsh -WorkDir $BackendDir -Command "npm run dev:backend" -Title "backend :3000"
} else {
  Write-Ok "backend already listening on :3000"
}

if (-not (Test-Port 5555)) {
  # ใช้สคริปต์ dev:frontend จาก backend (มีอยู่ใน package.json):contentReference[oaicite:3]{index=3}
  Start-InNewPwsh -WorkDir $BackendDir -Command "npm run dev:frontend" -Title "frontend :5555"
} else {
  Write-Ok "frontend already listening on :5555"
}

Write-Step "4) Wait health"
$h1 = Wait-HttpOk "http://localhost:3000/api/health"
if (-not $h1) { throw "Backend health not responding: http://localhost:3000/api/health" }
Write-Ok ("backend /api/health => ok={0}" -f $h1.ok)

$h2 = Wait-HttpOk "http://localhost:5555/api/health"
if (-not $h2) { Write-Warn "frontend proxy /api/health not responding yet (ยังไม่ critical)" }
else { Write-Ok ("frontend /api/health => ok={0}" -f $h2.ok) }

Write-Step "5) Run seed:admin"
Push-Location $BackendDir
try {
  # สคริปต์ seed:admin มีอยู่จริง:contentReference[oaicite:4]{index=4}
  npm run seed:admin
  Write-Ok "seed:admin done"
} finally {
  Pop-Location
}

Write-Step "6) Determine admin password"
if (-not $AdminPassword) {
  $guess = Try-Extract-PasswordFromSeed $SeedAdminTs
  if ($guess) {
    $AdminPassword = $guess
    Write-Ok "Password extracted from seedAdmin.ts"
  } else {
    Write-Warn "หา password ใน seedAdmin.ts ไม่เจอ -> ใส่ผ่าน ENV ชื่อ BN88_ADMIN_PASSWORD จะชัวร์สุด"
    $AdminPassword = Read-Host "Enter admin password for $Email"
  }
} else {
  Write-Ok "Using BN88_ADMIN_PASSWORD from environment"
}

Write-Step "7) Login and get token"
$body = @{ email = $Email; password = $AdminPassword } | ConvertTo-Json
$token = $null

$loginUrls = @(
  "http://localhost:3000/api/admin/auth/login",
  "http://localhost:5555/api/admin/auth/login"
)

foreach ($u in $loginUrls) {
  try {
    $res = Invoke-RestMethod -Uri $u -Method Post -ContentType "application/json" -Body $body -TimeoutSec 8
    if ($res.token) {
      $token = $res.token
      Write-Ok "Login success via $u"
      break
    }
  } catch {
    Write-Warn ("Login failed via {0} : {1}" -f $u, $_.Exception.Message)
  }
}

if (-not $token) {
  Write-Bad "Login still failed (no token)."
  Write-Host "แนะนำเช็ค: DATABASE_URL ใน backend .env + เปิด Prisma Studio แล้วดู AdminUser" -ForegroundColor Yellow
  throw "STOP"
}

Write-Host ("Token: {0}..." -f $token.Substring(0, [Math]::Min(24, $token.Length)))

Write-Step "8) Fetch sessions (proof)"
# ทุก /api/admin/* ต้องแนบ Authorization Bearer + x-tenant:contentReference[oaicite:5]{index=5}
$headers = @{
  "Authorization" = "Bearer $token"
  "x-tenant"      = $Tenant
}

$sessionsUrl = "http://localhost:3000/api/admin/chat/sessions?limit=5"
try {
  $sess = Invoke-RestMethod -Uri $sessionsUrl -Method Get -Headers $headers -TimeoutSec 8
  if ($sess.items) {
    Write-Ok ("sessions ok: {0} items" -f ($sess.items.Count))
    $sess.items | Select-Object -First 5 | Format-Table id, botId, platform, userId, lastMessageAt
  } else {
    Write-Ok "sessions response received (shape may differ) -> inspect below"
    $sess | ConvertTo-Json -Depth 6
  }
} catch {
  Write-Bad ("Fetch sessions failed: {0}" -f $_.Exception.Message)
  Write-Host "ถ้าเป็น 401 = header/token/tenant ยังไม่ถูกแนบครบ" -ForegroundColor Yellow
  throw
}

Write-Step "DONE"
Write-Ok "Next: เปิด http://localhost:5555 แล้วลองใช้งาน Chat Center"

# RUNBOOK

## Run backend
```powershell
cd .\bn88-backend-v12
npm i
npx prisma migrate dev
npm run dev
```

## Run dashboard
```powershell
cd .\bn88-frontend-dashboard-v12
npm i
npm run dev
```

## Run redis
```powershell
docker compose up -d redis
```

## Health checks
```powershell
curl http://localhost:3000/health
```

## LINE webhook (HTTPS required)
- LINE ต้องใช้ HTTPS เท่านั้น (ห้ามใช้ http:// หรือ localhost)
- แนะนำใช้ tunnel:
```powershell
cloudflared tunnel --url http://localhost:3000
```
- ถ้าติดปัญหา ให้ลองบังคับ protocol:
```powershell
cloudflared tunnel --protocol http2 --url http://localhost:3000
```
- ต้องใช้ URL ล่าสุดที่ cloudflared แสดง (URL เก่าอาจ 404)
- ตัวอย่าง webhook URL ที่ถูกต้อง:
```
https://<trycloudflare>/api/webhooks/line/bn9/dev-bot
```

## Troubleshooting: cloudflared quick tunnel เข้า URL ไม่ได้
1) เช็ค origin (localhost)
```powershell
curl http://localhost:3000/
curl http://localhost:3000/api/health
```
2) เช็ค public (status code)
```powershell
iwr https://<public>/ -Method GET | Select-Object -ExpandProperty StatusCode
iwr https://<public>/api/health -Method GET | Select-Object -ExpandProperty StatusCode
```
3) ถ้าไม่ผ่าน ให้บังคับ protocol เป็น http2
```powershell
cloudflared tunnel --url http://localhost:3000 --protocol http2
```
4) ถ้ายังไม่ผ่าน ให้เปิด debug แล้วดู keyword:
- origin connection refused
- handshake
- disconnect
```powershell
cloudflared tunnel --url http://localhost:3000 --protocol http2 --loglevel debug
```

## Checklist: trycloudflare ได้ 404 แต่ localhost ใช้งานได้ (Windows)
1) เคลียร์ cloudflared ที่รันค้างทั้งหมด
```powershell
Get-Process cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force
```
2) รัน cloudflared ใหม่ (http2 + debug)
```powershell
cloudflared tunnel --protocol http2 --url http://127.0.0.1:3000 --loglevel debug
```
3) เทส public ด้วย iwr (ดู StatusCode + headers)
```powershell
$r = iwr "https://<trycloudflare>/" -SkipHttpErrorCheck
$r.StatusCode
$r.Headers["server"]
$r.Headers["cf-ray"]
```
4) เงื่อนไขตัดสิน
- ถ้า backend ไม่มี log เมื่อยิง public => request ไม่ถึง origin

## Ports + netstat
- 3000 (backend)
- 5173 (dashboard)
- 6380 (redis) — set `REDIS_URL=redis://127.0.0.1:6380` or `REDIS_PORT=6380` to enable workers

```powershell
netstat -ano | findstr ":3000"
netstat -ano | findstr ":5173"
netstat -ano | findstr ":6380"
```

## E2E test (sample webhook -> dashboard event)
1) Send sample webhook:
```powershell
curl -X POST http://localhost:3000/webhooks/line -H "Content-Type: application/json" -d @sample-webhook.json
```
2) Open dashboard at http://localhost:5173 and confirm the event appears.

# Deployment Guide

> Production deployment guide for BN88 platform

## Table of Contents
- [Prerequisites](#prerequisites)
- [Pre-Deployment Checklist](#pre-deployment-checklist)
- [Deployment Methods](#deployment-methods)
- [Environment Variables](#environment-variables)
- [Database Migration](#database-migration)
- [Health Checks](#health-checks)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Infrastructure Requirements

- **Node.js** 18.x LTS
- **PostgreSQL** 15+ (production database)
- **Redis** 7+ (caching and queues)
- **Reverse Proxy** (nginx, Caddy, or similar)
- **SSL Certificate** (required for LINE webhooks)
- **Docker** (optional, for containerized deployment)

### Domain & SSL

- Domain name with DNS configured
- SSL certificate (Let's Encrypt recommended)
- Webhook URL must be HTTPS for LINE integration

## Pre-Deployment Checklist

### Security

- [ ] Change all default credentials
- [ ] Generate strong JWT secrets
- [ ] Update encryption keys
- [ ] Configure CORS origins
- [ ] Set up firewall rules
- [ ] Enable HTTPS only
- [ ] Configure rate limiting
- [ ] Set secure session cookies

### Environment

- [ ] Create production `.env` files
- [ ] Set `NODE_ENV=production`
- [ ] Configure database connection strings
- [ ] Set up Redis connection
- [ ] Configure LINE API credentials
- [ ] Set proper log levels
- [ ] Configure backup strategy

### Database

- [ ] Create production database
- [ ] Run migrations
- [ ] Create admin user
- [ ] Set up backup schedule
- [ ] Configure connection pooling

### Monitoring

- [ ] Set up error tracking (e.g., Sentry)
- [ ] Configure log aggregation
- [ ] Set up uptime monitoring
- [ ] Configure alerts
- [ ] Set up performance monitoring

## Deployment Methods

### Method 1: Docker Compose (Recommended)

**Best for:** Complete stack deployment with minimal setup

#### 1. Prepare Environment

```bash
# Clone repository
git clone https://github.com/josho007237-max/-bn88-new-clean.git
cd -bn88-new-clean

# Create environment files
cp .env.example .env
cp bn88-backend-v12/.env.example bn88-backend-v12/.env
cp bn88-frontend-dashboard-v12/.env.example bn88-frontend-dashboard-v12/.env
cp line-engagement-platform/.env.example line-engagement-platform/.env
```

#### 2. Configure Environment

Edit `.env` files with production values:

**Root `.env`:**
```env
POSTGRES_USER=bn88_prod
POSTGRES_PASSWORD=<strong-password>
POSTGRES_DB=bn88_production
```

**Backend `.env`:**
```env
NODE_ENV=production
DATABASE_URL=postgresql://bn88_prod:<password>@db:5432/bn88_production?schema=public
JWT_SECRET=<generate-strong-secret>
SECRET_ENC_KEY_BN9=<generate-32-char-hex>
ALLOWED_ORIGINS=https://yourdomain.com
ADMIN_EMAIL=admin@yourdomain.com
ADMIN_PASSWORD=<strong-password>
ENABLE_DEV_ROUTES=0
```

**Frontend `.env`:**
```env
VITE_API_BASE=https://yourdomain.com/api
VITE_TENANT=production
```

#### 3. Build and Deploy

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f

# Verify services are running
docker-compose ps
```

#### 4. Initialize Database

```bash
# Run migrations
docker-compose exec backend npx prisma migrate deploy

# Create admin user
docker-compose exec backend npm run seed:admin
```

#### 5. Configure Reverse Proxy

Example nginx configuration:

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # Frontend
    location / {
        proxy_pass http://localhost:5555;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # For SSE (Server-Sent Events)
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 86400s;
    }
}
```

### Method 2: Manual Deployment

**Best for:** Custom infrastructure or managed services

#### 1. Backend Deployment

```bash
cd bn88-backend-v12

# Install production dependencies
npm ci --only=production

# Generate Prisma client
npx prisma generate

# Build application
npm run build

# Run migrations
npx prisma migrate deploy

# Start with PM2 (process manager)
pm2 start dist/server.js --name bn88-backend

# Or with systemd
sudo systemctl start bn88-backend
```

#### 2. Frontend Deployment

```bash
cd bn88-frontend-dashboard-v12

# Install dependencies
npm ci

# Build for production
npm run build

# Serve with nginx or any static file server
# dist/ folder contains the built application
```

#### 3. LINE Engagement Platform

```bash
cd line-engagement-platform

# Install dependencies
npm ci --only=production

# Generate Prisma client
npx prisma generate

# Build application
npm run build

# Start application
pm2 start dist/server.js --name line-platform
```

### Method 3: Cloud Platforms

#### Vercel (Frontend Only)

```bash
cd bn88-frontend-dashboard-v12

# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

#### Heroku

```bash
# Backend
heroku create bn88-backend
heroku addons:create heroku-postgresql:hobby-dev
heroku addons:create heroku-redis:hobby-dev
git subtree push --prefix bn88-backend-v12 heroku main

# Frontend
heroku create bn88-frontend
git subtree push --prefix bn88-frontend-dashboard-v12 heroku main
```

## Environment Variables

### Critical Production Variables

**Backend:**
```env
# Must be changed from defaults
NODE_ENV=production
JWT_SECRET=<generate-with: openssl rand -hex 32>
SECRET_ENC_KEY_BN9=<generate-with: openssl rand -hex 16>
ADMIN_PASSWORD=<strong-password>

# Database
DATABASE_URL=postgresql://user:password@host:5432/database

# Security
ALLOWED_ORIGINS=https://yourdomain.com
ENABLE_DEV_ROUTES=0
LINE_DEV_SKIP_VERIFY=0

# Redis
REDIS_URL=redis://redis-host:6379
ENABLE_REDIS=1
```

**Frontend:**
```env
VITE_API_BASE=https://yourdomain.com/api
VITE_TENANT=production
```

### Generating Secrets

```bash
# JWT Secret (64 characters)
openssl rand -hex 32

# Encryption Key (32 characters)
openssl rand -hex 16

# Strong Password
openssl rand -base64 32
```

## Database Migration

### Production Migration Strategy

1. **Backup current database:**
   ```bash
   pg_dump -h host -U user -d database > backup-$(date +%Y%m%d-%H%M%S).sql
   ```

2. **Test migration locally:**
   ```bash
   # Use a copy of production data
   npx prisma migrate deploy --preview-feature
   ```

3. **Apply migration:**
   ```bash
   npx prisma migrate deploy
   ```

4. **Verify migration:**
   ```bash
   npx prisma migrate status
   ```

### Rollback Strategy

If migration fails:

```bash
# Restore from backup
psql -h host -U user -d database < backup-TIMESTAMP.sql

# Or use Prisma migrate
npx prisma migrate resolve --rolled-back <migration-name>
```

## Health Checks

### Automated Health Checks

**Backend Health:**
```bash
curl https://yourdomain.com/api/health
# Expected: {"status":"ok"}
```

**Frontend Health:**
```bash
curl -I https://yourdomain.com
# Expected: HTTP/1.1 200 OK
```

**Database Health:**
```bash
docker-compose exec db pg_isready
# Or
psql -h host -U user -c "SELECT 1"
```

**Redis Health:**
```bash
docker-compose exec redis redis-cli ping
# Expected: PONG
```

### Monitoring Endpoints

Set up monitoring for:
- `GET /api/health` - Backend health
- `GET /api/stats` - System statistics
- `GET /api/admin/health` - Authenticated health check

## Monitoring

### Log Management

**Backend Logs:**
```bash
# Docker
docker-compose logs -f backend

# PM2
pm2 logs bn88-backend

# File-based
tail -f /var/log/bn88/backend.log
```

**Frontend Logs:**
```bash
# Nginx access logs
tail -f /var/log/nginx/access.log

# Nginx error logs
tail -f /var/log/nginx/error.log
```

### Performance Monitoring

Recommended tools:
- **Application Performance:** New Relic, Datadog
- **Error Tracking:** Sentry
- **Uptime Monitoring:** Pingdom, UptimeRobot
- **Log Aggregation:** Loggly, Papertrail

### Metrics to Monitor

- Response times (p50, p95, p99)
- Error rates
- Database query performance
- Redis hit/miss ratio
- Memory usage
- CPU usage
- Disk usage
- Active connections

## Backup Strategy

### Database Backups

**Automated Daily Backup:**
```bash
#!/bin/bash
# /usr/local/bin/backup-bn88.sh

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR=/backups/bn88
RETENTION_DAYS=30

# Create backup
pg_dump -h localhost -U bn88_prod -d bn88_production | gzip > $BACKUP_DIR/db-$DATE.sql.gz

# Upload to S3 (optional)
aws s3 cp $BACKUP_DIR/db-$DATE.sql.gz s3://my-backups/bn88/

# Cleanup old backups
find $BACKUP_DIR -name "db-*.sql.gz" -mtime +$RETENTION_DAYS -delete
```

**Cron Schedule:**
```cron
# Daily at 2 AM
0 2 * * * /usr/local/bin/backup-bn88.sh
```

### Media Files Backup

```bash
# Backup uploaded media
rsync -avz /path/to/uploads/ backup-server:/backups/bn88-media/
```

## Troubleshooting

### Common Issues

**Port conflicts:**
```bash
# Check port usage
netstat -tlnp | grep :3000

# Kill process
kill -9 <PID>
```

**Database connection failed:**
```bash
# Check PostgreSQL is running
systemctl status postgresql

# Test connection
psql -h host -U user -d database -c "SELECT 1"
```

**High memory usage:**
```bash
# Check Node.js processes
ps aux | grep node

# Restart services
docker-compose restart backend
```

**SSL certificate issues:**
```bash
# Renew Let's Encrypt certificate
certbot renew

# Check certificate expiry
openssl x509 -in cert.pem -noout -dates
```

### Emergency Procedures

**Complete Service Restart:**
```bash
docker-compose down
docker-compose up -d
```

**Database Restore:**
```bash
# Stop services
docker-compose stop backend

# Restore database
psql -h host -U user -d database < backup.sql

# Restart services
docker-compose start backend
```

**Rollback Deployment:**
```bash
# Rollback to previous Docker image
docker-compose down
git checkout <previous-commit>
docker-compose up -d
```

## Post-Deployment

### Verification Checklist

- [ ] All services running
- [ ] Health checks passing
- [ ] Admin login works
- [ ] Database migrations applied
- [ ] LINE webhook configured
- [ ] SSL certificate valid
- [ ] Monitoring configured
- [ ] Backups scheduled
- [ ] Logs accessible
- [ ] Performance acceptable

### Monitoring Setup

1. Configure uptime monitoring
2. Set up error alerting
3. Configure log aggregation
4. Set up performance monitoring
5. Schedule regular backups

### Security Hardening

- Enable firewall
- Configure fail2ban
- Set up intrusion detection
- Regular security audits
- Keep dependencies updated
- Monitor security advisories

## Support

For deployment assistance:
- Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
- Review [RUNBOOK.md](./RUNBOOK.md)
- Create GitHub issue
- Contact development team

---

**Remember:** Always test deployments in a staging environment first!

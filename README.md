# Production Docker & GitHub Actions CI/CD Template Package

> **Enterprise Infrastructure Standard** by Apex Autonomous Technologies  
> Product ID: `V-DEVOPS-PACK` | Commercial Price: ₹1,200 INR (~$15 USD)

---

## 🚀 Overview

A battle-tested, security-hardened container orchestration and continuous delivery stack designed for modern microservices and high-reliability web applications. This template eliminates days of manual DevOps engineering and ensures enterprise-grade compliance from day one.

### Included Core Modules
1. **Traefik v3 Edge Ingress**: Automated Let's Encrypt TLS certificate provisioning, automated HTTP to HTTPS redirection, strict CSP/HSTS/XSS security headers, and dynamic container discovery.
2. **Dual-Tier Network Isolation**: Public edge network (`edge-public`) cleanly separated from isolated internal database/cache network (`internal-secure`).
3. **Hardened Multi-Stage Dockerfile**: Non-root container execution (`apexuser:apexgroup`), read-only root filesystem compatibility, minimal attack surface on Alpine Linux.
4. **Resilient Data Persistence**: PostgreSQL 16 Alpine and Redis 7 Alpine with tuned memory policies, healthcheck probes, and isolated named volumes.
5. **Observability Stack**: Prometheus metrics collector and pre-configured Grafana dashboard container.
6. **Production GitHub Actions CI/CD**:
   - Automated linting & type checks
   - Dependency vulnerability auditing
   - TruffleHog secret scanning & Trivy container vulnerability analysis
   - Multi-architecture Docker builds (`linux/amd64`, `linux/arm64`) with GitHub Actions cache
   - Zero-downtime rolling deployment hooks

---

## 📂 Architecture Diagram

```
[ Internet / Clients ]
         │
         ▼ (Port 80 / 443)
┌──────────────────────────────────────────────┐
│  Traefik v3 Edge Router (SSL Termination)    │  <-- [edge-public network]
└──────┬───────────────────────────────────────┘
       │
       ├────────────────────────┐
       ▼ (Internal Proxy)       ▼ (Metrics UI)
┌──────────────┐         ┌──────────────┐
│  API Service │         │   Grafana    │
└──────┬───────┘         └──────┬───────┘
       │                        │
       └───────────┬────────────┘  <-- [internal-secure network]
                   │
         ┌─────────┴─────────┐
         ▼                   ▼
┌──────────────────┐ ┌───────────────┐
│  PostgreSQL 16   │ │ Redis 7 Cache │
└──────────────────┘ └───────────────┘
```

---

## ⚡ Quickstart Guide

### 1. Prerequisites
- Docker Engine 24.0+ and Docker Compose v2.20+
- Linux (Ubuntu 22.04+ recommended) or macOS / Windows with WSL2

### 2. Configure Environment Variables
Copy the template environment file:
```bash
cp .env.example .env
```
Fill in your secure credentials:
```env
DOMAIN=api.yourcompany.com
ACME_EMAIL=admin@yourcompany.com
POSTGRES_USER=apex_admin
POSTGRES_PASSWORD=generate_a_very_strong_password_here
POSTGRES_DB=production_db
REDIS_PASSWORD=generate_another_strong_password_here
GRAFANA_USER=admin
GRAFANA_PASSWORD=generate_grafana_password_here
```

### 3. Launch the Stack
```bash
docker compose up -d --build
```

### 4. Verify Service Health
```bash
docker compose ps
```
All containers should display status `Up (healthy)`.

---

## 🛡️ Security Hardening Checklist

- [x] **Non-Root Execution**: Docker container drops root privileges and executes as UID 1001.
- [x] **No New Privileges**: `security_opt: [no-new-privileges:true]` enforced on all external-facing services.
- [x] **Automated TLS Encryption**: Ingress issues and renews 4096-bit Let's Encrypt certificates automatically.
- [x] **Isolated Database Tier**: Database and cache services do NOT expose ports to host machine or public network.
- [x] **Automated Secret Scanning**: TruffleHog in CI pipeline prevents credentials from ever being committed to git history.
- [x] **Static Vulnerability Scanning**: Aqua Security Trivy scans all built images for High and Critical CVEs prior to deployment.

---

## 📦 Commercial Distribution & Licensing

Distributed by **Apex Autonomous Technologies**.  
Licensed for single commercial venture deployment or multi-project agency use upon verified license fee payment.  
For technical support or customized infrastructure architectures: `support@apexautonomous.com`.

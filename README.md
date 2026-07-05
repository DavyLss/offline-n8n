# offline-n8n

<p align="center">
  <strong>Offline n8n stack for internal automation delivery</strong>
</p>

<p align="center">
  Small, focused, and built for environments where installation has to work without Internet access.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/status-ready%20for%20review-8b5cf6?style=flat-square" alt="status" />
  <img src="https://img.shields.io/badge/offline-ready-111827?style=flat-square" alt="offline ready" />
  <img src="https://img.shields.io/badge/n8n-automation-f97316?style=flat-square" alt="n8n" />
  <img src="https://img.shields.io/badge/Database-PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/TLS-internal%20HTTPS-0f766e?style=flat-square" alt="TLS" />
  <img src="https://img.shields.io/badge/license-MIT-22c55e?style=flat-square" alt="license" />
</p>

<p align="center">
  <sub>Made for private deployments, offline delivery, and straightforward operations.</sub>
</p>

---

## Overview

This project provides a small internal n8n base for teams that need private automation workflows without depending on Internet access at install time.

## Highlights

- fully offline installation flow
- n8n with PostgreSQL backend
- internal HTTPS support with local self-signed fallback
- simple deployment with Docker Compose or Podman Compose
- install, bundle, verification, and certificate scripts
- documentation for install, security, and acceptance

## Typical use case

This stack fits small internal deployments where n8n needs to stay on a private network, use internal DNS and TLS, and remain easy to hand over to an operations team.

## What is included

- n8n
- PostgreSQL
- Caddy reverse proxy for internal HTTPS
- offline image bundle preparation
- Docker Compose and Podman Compose deployment files
- install, preload, and verification scripts
- documentation for install, operations, security, and acceptance

## What is not included

- Docker or Podman installation on the host
- public certificate issuance
- high availability
- external database
- advanced monitoring
- queue mode with Redis
- SSO or directory integration

## Recommended sizing

Current defaults fit a small internal team:

| Component | Sizing |
|---|---|
| Host | 2 vCPU, 4 GB RAM, 40 GB SSD |
| n8n | 1 vCPU max, 1.5 GB RAM max |
| PostgreSQL | 1 vCPU max, 1 GB RAM max |
| Team size | about 5 to 15 active users |

## Repository layout

- `compose/` - Docker Compose and Podman Compose files
- `scripts/` - preflight, load, install, verify, helper scripts
- `artifacts/` - exported images, manifests, checksums
- `certs/` - local TLS drop-in directory, not versioned
- `docs/` - architecture, security, install, operations, acceptance

## Quick start

### 1. Prepare the offline bundle on a connected machine

```bash
cp .env.example .env
$EDITOR .env
./scripts/prepare-bundle.sh
```

Then transfer the repository and image archives to the target site.

### 2. Prepare the target configuration

```bash
cp .env.example .env
$EDITOR .env
```

### 3. TLS handling

For production, provide:
- `certs/n8n.crt`
- `certs/n8n.key`

These files should match `N8N_FQDN` and ideally come from the customer's internal PKI.

If no certificate files are present, `preflight.sh` generates a local self-signed certificate automatically.
That fallback is useful for lab, demo, or validation use, but it should be replaced before production handover.

### 4. Install

#### Docker

```bash
./scripts/install.sh docker
./scripts/verify.sh docker
```

#### Podman

```bash
./scripts/install.sh podman
./scripts/verify.sh podman
```

## Main variables

Review these values in `.env`:
- `N8N_FQDN`
- `N8N_HTTP_PORT`
- `N8N_HTTPS_PORT`
- `N8N_IMAGE`
- `POSTGRES_IMAGE`
- `CADDY_IMAGE`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `N8N_ENCRYPTION_KEY`

## Security notes

- n8n is served behind an internal HTTPS reverse proxy
- PostgreSQL stays on a backend-only network
- persistent data is separated for application state, database, and TLS material
- access is expected to be controlled by the internal deployment and account setup flow
- CPU and RAM limits are set on services

## No Internet egress

The repository avoids Internet downloads during installation and normal use.

Actual egress blocking still has to be enforced outside the repo, at host or network level:
- host firewall
- network ACLs
- micro-segmentation
- allow-list for required internal services only

See `docs/no-internet-egress.md`.

## Limits

This is a focused V1:
- no queue mode
- no built-in backup workflow
- no automatic certificate issuance
- production deployments should replace the self-signed TLS fallback

## Health check

- **Endpoint** : `GET /healthz`
- **Port HTTP** : `8080` (port exposé par Caddy)
- **Port HTTPS** : `8443` (derrière la terminaison TLS)
- **Réponse attendue** : `200 OK`

Ce endpoint est utilisé par la VIP ou un load‑balancer pour tester l'état du service.

## Documentation

- `docs/architecture.md`
- `docs/install-offline.md`
- `docs/security.md`
- `docs/operations.md`
- `docs/no-internet-egress.md`
- `docs/acceptance-checklist.md`

# Acceptance Checklist

- `docker compose` or `podman compose` is available on the host.
- `.env` is configured.
- Offline image archives are present in `artifacts/images/`.
- TLS files are present, or the fallback certificate has been accepted for test use.
- `./scripts/install.sh` completes without error.
- `./scripts/verify.sh` returns success.
- The n8n login page is reachable on the HTTPS endpoint.

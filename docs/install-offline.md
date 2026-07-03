# Offline Install

## Connected machine

1. Copy `.env.example` to `.env`.
2. Set the image tags and passwords.
3. Run `./scripts/prepare-bundle.sh`.
4. Transfer the repository and `artifacts/images/` to the target site.

## Target machine

1. Copy `.env.example` to `.env`.
2. Set the same values as the bundle preparation step.
3. Provide `certs/n8n.crt` and `certs/n8n.key`, or let the preflight script create a temporary self-signed pair.
4. Run `./scripts/install.sh docker` or `./scripts/install.sh podman`.
5. Run `./scripts/verify.sh docker` or `./scripts/verify.sh podman`.

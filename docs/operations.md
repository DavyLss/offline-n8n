# Operations

## Start

```bash
./scripts/install.sh docker
```

## Check status

```bash
./scripts/verify.sh docker
```

## Logs

```bash
docker compose -f compose/docker-compose.yml logs -f
# or
podman compose -f compose/podman-compose.yml logs -f
```

## Backup

Back up the volume data for n8n and PostgreSQL with your standard platform tooling.

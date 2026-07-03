#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

load_env
require_cmd curl

base_url="https://${N8N_FQDN}:${N8N_HTTPS_PORT}"
timeout_seconds="${1:-120}"
elapsed=0

while [ "$elapsed" -lt "$timeout_seconds" ]; do
  if curl -fsSk "$base_url/healthz" >/dev/null 2>&1; then
    log "n8n is ready"
    exit 0
  fi
  sleep 2
  elapsed=$((elapsed + 2))
done

fail "Timed out waiting for n8n"

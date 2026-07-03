#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

runtime="$(detect_runtime "${1:-}")"
load_env

compose_file="$(compose_file_for_runtime "$runtime")"

require_cmd curl

compose_cmd "$runtime" -f "$compose_file" ps
"$SCRIPT_DIR/wait-for-n8n.sh" 120
curl -fsSk "https://${N8N_FQDN}:${N8N_HTTPS_PORT}/healthz" >/dev/null
log "Verification complete"

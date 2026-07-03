#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

runtime="$(detect_runtime "${1:-}")"
load_env

require_cmd "$runtime"

mkdir -p "$ROOT_DIR/artifacts/images" "$ROOT_DIR/artifacts/checksums" "$ROOT_DIR/artifacts/manifest"

if [ ! -f "$ROOT_DIR/certs/n8n.crt" ] || [ ! -f "$ROOT_DIR/certs/n8n.key" ]; then
  "$SCRIPT_DIR/generate-self-signed-cert.sh"
fi

compose_file="$(compose_file_for_runtime "$runtime")"
log "Preflight OK for $runtime using $compose_file"

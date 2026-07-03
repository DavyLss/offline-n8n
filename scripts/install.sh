#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

runtime="$(detect_runtime "${1:-}")"
load_env

compose_file="$(compose_file_for_runtime "$runtime")"

"$SCRIPT_DIR/preflight.sh" "$runtime"
"$SCRIPT_DIR/load-images.sh" "$runtime"

compose_cmd "$runtime" -f "$compose_file" up -d
log "Installation complete"

#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

runtime="$(detect_runtime "${1:-}")"
load_env

require_cmd "$runtime"

images_dir="$ROOT_DIR/artifacts/images"
shopt -s nullglob
archives=("$images_dir"/*.tar "$images_dir"/*.tar.gz "$images_dir"/*.tgz)

if [ ${#archives[@]} -eq 0 ]; then
  log "No image archives found in artifacts/images"
  exit 0
fi

for archive in "${archives[@]}"; do
  log "Loading $archive"
  "$runtime" load -i "$archive"
done

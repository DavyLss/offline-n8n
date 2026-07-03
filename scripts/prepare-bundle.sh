#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

runtime="$(detect_runtime "${1:-}")"
load_env

require_cmd "$runtime"

images_dir="$ROOT_DIR/artifacts/images"
manifest_file="$ROOT_DIR/artifacts/manifest/images.txt"
checksum_file="$ROOT_DIR/artifacts/checksums/SHA256SUMS"
mkdir -p "$images_dir" "$ROOT_DIR/artifacts/manifest" "$ROOT_DIR/artifacts/checksums"

images=("$N8N_IMAGE" "$POSTGRES_IMAGE" "$CADDY_IMAGE")

:
> "$manifest_file"
for image in "${images[@]}"; do
  printf '%s\n' "$image" >> "$manifest_file"
done

for image in "${images[@]}"; do
  safe_name="$(printf '%s' "$image" | tr '/:@' '___')"
  archive="$images_dir/${safe_name}.tar"
  log "Pulling $image"
  "$runtime" pull "$image"
  log "Saving $image to $archive"
  "$runtime" save -o "$archive" "$image"
done

archives=("$images_dir"/*.tar "$images_dir"/*.tar.gz "$images_dir"/*.tgz)

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "${archives[@]}" > "$checksum_file"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "${archives[@]}" > "$checksum_file"
else
  fail "Neither sha256sum nor shasum was found"
fi

log "Bundle prepared"

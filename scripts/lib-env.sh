#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

load_env() {
  local env_file="${1:-$ROOT_DIR/.env}"
  [ -f "$env_file" ] || fail "Missing $env_file. Copy .env.example to .env first."
  set -a
  # shellcheck disable=SC1090
  . "$env_file"
  set +a
}

detect_runtime() {
  local runtime="${1:-}"
  if [ -n "$runtime" ]; then
    printf '%s\n' "$runtime"
    return
  fi

  if command -v docker >/dev/null 2>&1; then
    printf '%s\n' docker
    return
  fi

  if command -v podman >/dev/null 2>&1; then
    printf '%s\n' podman
    return
  fi

  fail "Neither docker nor podman was found"
}

compose_file_for_runtime() {
  case "$1" in
    docker)
      printf '%s\n' "$ROOT_DIR/compose/docker-compose.yml"
      ;;
    podman)
      printf '%s\n' "$ROOT_DIR/compose/podman-compose.yml"
      ;;
    *)
      fail "Unsupported runtime: $1"
      ;;
  esac
}

compose_cmd() {
  local runtime="$1"
  shift
  "$runtime" compose "$@"
}

#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib-env.sh"

require_cmd openssl
load_env

cert_dir="$ROOT_DIR/certs"
crt_file="$cert_dir/n8n.crt"
key_file="$cert_dir/n8n.key"

mkdir -p "$cert_dir"

if [ -f "$crt_file" ] && [ -f "$key_file" ]; then
  log "TLS certificate already present"
  exit 0
fi

if [ -f "$crt_file" ] || [ -f "$key_file" ]; then
  fail "Only one TLS file is present in certs/. Provide both n8n.crt and n8n.key"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cat > "$tmp_dir/openssl.cnf" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
CN = ${N8N_FQDN}

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${N8N_FQDN}
EOF

openssl req -x509 -nodes -newkey rsa:2048 -days 825 \
  -keyout "$key_file" \
  -out "$crt_file" \
  -config "$tmp_dir/openssl.cnf" \
  -extensions req_ext >/dev/null 2>&1

log "Generated self-signed certificate for ${N8N_FQDN}"

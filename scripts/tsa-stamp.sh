#!/usr/bin/env bash
set -euo pipefail

tag="${1:?usage: $0 <tag>}"
tsa_url="${TSA_URL:-http://timestamp.digicert.com}"
capability_token="${NETWORK_CAPABILITY_TOKEN:?set NETWORK_CAPABILITY_TOKEN to the signed capability token path}"
capability_signature="${NETWORK_CAPABILITY_SIGNATURE:?set NETWORK_CAPABILITY_SIGNATURE to the detached signature path}"

mkdir -p tsa/"$tag"

stamp_one () {
  in="$1"
  base="$(basename "$in")"
  out="tsa/${tag}/${base}.tsr"
  echo "Stamping $in -> $out"
  openssl ts -query -data "$in" -sha256 -cert > /tmp/tsq.bin
  python3 scripts/network_capability/guarded_tsa_post.py \
    --target "$tsa_url" \
    --query /tmp/tsq.bin \
    --response "$out" \
    --token "$capability_token" \
    --signature "$capability_signature"
  # basic parse check
  openssl ts -reply -in "$out" -text >/dev/null
}

stamp_one "transparency/merkle.root"
stamp_one "transparency/files.sha256"
stamp_one "tuple/TUPLE_${tag}.txt"

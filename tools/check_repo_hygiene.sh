#!/usr/bin/env bash
set -euo pipefail
FORBIDDEN=("ip/" "workspace/" "scratch/" "*.pem" "*.key")
for f in "${FORBIDDEN[@]}"; do
  if git ls-files | grep -q "$f"; then
    echo "FAIL forbidden content tracked: $f"
    exit 1
  fi
done
echo "OK repo hygiene"

#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

git ls-files -z \
  | LC_ALL=C sort -z \
  | while IFS= read -r -d '' f; do
      case "$f" in
        CHECKSUMS.txt) continue ;;
      esac
      sha="$(shasum -a 256 "$f" | awk '{print $1}')"
      printf "%s  %s\n" "$sha" "$f"
    done > "$tmp"

mv "$tmp" CHECKSUMS.txt
trap - EXIT

#!/usr/bin/env bash
set -euo pipefail

manifest_tmp="$(mktemp)"
root_tmp="$(mktemp)"
trap 'rm -f "$manifest_tmp" "$root_tmp"' EXIT

git ls-files -z \
  | LC_ALL=C sort -z \
  | while IFS= read -r -d '' f; do
      case "$f" in
        CHECKSUMS.txt|transparency/files.sha256|transparency/merkle.root) continue ;;
      esac
      sha="$(shasum -a 256 "$f" | awk '{print $1}')"
      printf "%s  %s\n" "$sha" "$f"
    done > "$manifest_tmp"

shasum -a 256 "$manifest_tmp" | awk '{print $1}' > "$root_tmp"
mv "$manifest_tmp" transparency/files.sha256
mv "$root_tmp" transparency/merkle.root
trap - EXIT

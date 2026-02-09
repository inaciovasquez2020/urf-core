#!/usr/bin/env bash
set -euo pipefail

tag="${1:?usage: $0 <tag>}"
commit="$(git rev-parse HEAD)"
tree="$(git rev-parse HEAD^{tree})"

# hash key artifacts if present
touch tuple/ARTIFACTS.sha256
: > tuple/ARTIFACTS.sha256
for f in \
  transparency/files.sha256 transparency/merkle.root \
  proof-certificate.pdf MANIFEST.sha256 IMAGE_DIGEST.txt REPRO.md \
; do
  if [ -f "$f" ]; then
    shasum -a 256 "$f" >> tuple/ARTIFACTS.sha256
  fi
done

root="$(shasum -a 256 tuple/ARTIFACTS.sha256 | awk '{print $1}')"

cat > "tuple/TUPLE_${tag}.txt" <<EOT
tag: $tag
commit: $commit
tree: $tree
artifacts_sha256_root: $root
artifacts_list: tuple/ARTIFACTS.sha256
ci_run_url: (fill from GitHub Actions run URL)
EOT

git add tuple/ARTIFACTS.sha256 "tuple/TUPLE_${tag}.txt"
git commit -m "tuple: add end-to-end tuple for $tag"

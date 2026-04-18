#!/usr/bin/env bash
set -e
echo "Validating prefab documents (structural only)"
[ -f STATUS.md ] || { echo "Missing STATUS.md"; exit 1; }
[ -f ASSUMPTIONS.md ] || { echo "Missing ASSUMPTIONS.md"; exit 1; }
[ -f docs/EXAMPLE_PREFAB.md ] || { echo "Missing docs/EXAMPLE_PREFAB.md"; exit 1; }
[ -f docs/PREFAB_SCHEMA.md ] || { echo "Missing docs/PREFAB_SCHEMA.md"; exit 1; }
echo "Validation passed"

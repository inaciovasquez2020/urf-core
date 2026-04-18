#!/usr/bin/env bash
set -euo pipefail

CERT="$1"

minisign -Vm "$CERT" -p scripts/keys/active.pub

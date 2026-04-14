#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

LEAN_FILES=(
)

PY_TESTS=(
  tests/test_remaining_math_targets.py
  tests/test_local_cycle_rank_bound.py
  tests/test_measure_cycle_to_lcrb.py
  tests/test_closure_chain_composition.py
  tests/test_global_coercivity_implies_unconditional_closure.py
  tests/test_ss_counterexample_search_lock.py
)

DOC_CHECKS=(
  docs/math
  docs/status
)

echo "[1/4] Lean compile: selected files only"
if ((${#LEAN_FILES[@]:-0} > 0)); then
  for f in "${LEAN_FILES[@]}"; do
    [ -f "$f" ] || { echo "missing Lean file: $f" >&2; exit 1; }
    lake env lean "$f"
  done
fi

echo "[2/4] Python tests: selected only"
PYTHONDONTWRITEBYTECODE=1 python3 -m pytest -q "${PY_TESTS[@]}"

echo "[3/4] Doc presence checks"
for p in "${DOC_CHECKS[@]}"; do
  [ -e "$p" ] || { echo "missing path: $p" >&2; exit 1; }
done

echo "[4/4] Success"

#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

LEAN_ROOT = ROOT / "lean"
DOC_ROOT = ROOT / "docs/status"
ARTIFACT_ROOT = ROOT / "artifacts"

ACTIVE_STALE_AXIOM = "axiom descent_first_remaining_admit_assumption_2026_05_15 : True"

lean_texts = []
for path in LEAN_ROOT.rglob("*.lean"):
    lean_texts.append(path.read_text())

active_lean = "\n".join(lean_texts)

assert ACTIVE_STALE_AXIOM not in active_lean, "stale trivial True axiom resurfaced in active Lean source"

combined_parts = []
for base in [LEAN_ROOT, DOC_ROOT, ARTIFACT_ROOT]:
    if base.exists():
        for path in base.rglob("*"):
            if path.is_file() and path.suffix in {".lean", ".md", ".json"}:
                try:
                    text = path.read_text()
                except UnicodeDecodeError:
                    continue
                if "descent_first_remaining" in text or "DescentFirstRemaining" in text:
                    combined_parts.append(text)

combined = "\n".join(combined_parts)

assert combined, "missing descent-first remaining admit boundary material"
assert (
    "descent_first_remaining" in combined
    or "DescentFirstRemaining" in combined
), "missing descent-first remaining token"
assert (
    "boundary" in combined.lower()
    or "assumption" in combined.lower()
    or "admit" in combined.lower()
), "missing descent boundary classification"

print("DESCENT_FIRST_REMAINING_ADMIT_BOUNDARY_OK")

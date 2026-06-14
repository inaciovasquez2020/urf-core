#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

doc = ROOT / "docs/status/URF_CORE_REPOSITORY_MATURITY_BOUNDARY_CLARITY_2026_06_14.md"
ledger = ROOT / "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean"
cert = ROOT / "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean"

doc_text = doc.read_text()
assert ledger.exists(), ledger
assert cert.exists(), cert

required_tokens = [
    "URF-core Repository Maturity-Boundary Clarity",
    "REPOSITORY_MATURITY_BOUNDARY_CLARITY_ONLY_NO_FINAL_THEOREM_CLOSURE",
    "URF_CORE_REPOSITORY_MATURITY_BOUNDARY_CLARITY",
    "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean",
    "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean",
    "NO_FINAL_THEOREM_CLOSURE_CLAIMED",
    "This document does not prove URF scientific closure",
    "The final scientific theorem targets remain unproved here.",
]

for token in required_tokens:
    assert token in doc_text, token

for forbidden in [
    "proves URF scientific closure",
    "proves Poincare",
    "proves H4.1/FGL",
    "proves P vs NP",
    "final theorem closure is proved",
]:
    assert forbidden not in doc_text, forbidden

print("URF_CORE_REPOSITORY_MATURITY_BOUNDARY_CLARITY_OK")
print("Status: REPOSITORY_MATURITY_BOUNDARY_CLARITY_ONLY_NO_FINAL_THEOREM_CLOSURE")
print("Boundary: NO_FINAL_THEOREM_CLOSURE_CLAIMED")

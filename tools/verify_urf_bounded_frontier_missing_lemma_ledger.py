#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
lean = ROOT / "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean"
text = lean.read_text()

required_tokens = [
    "structure BoundedFrontierMissingLemmaLedgerEntry",
    "def BoundedFrontierMissingLemmaLedgerWellFormed",
    "def URFBoundedFrontierMissingLemmaLedgerEntry",
    "theorem URFBoundedFrontierMissingLemmaLedgerSurface",
    "URF_BOUNDED_FRONTIER_MISSING_LEMMA_LEDGER",
    "LEDGER_SURFACE_ONLY_NO_FINAL_THEOREM_CLOSURE",
    "NO_FINAL_THEOREM_CLOSURE_CLAIMED",
    "It does not prove the flagship object",
]

for token in required_tokens:
    assert token in text, token

for forbidden in ["axiom ", "opaque ", "sorry", "admit"]:
    assert forbidden not in text, forbidden

print("URF_BOUNDED_FRONTIER_MISSING_LEMMA_LEDGER_SURFACE_OK")
print("Status: LEDGER_SURFACE_ONLY_NO_FINAL_THEOREM_CLOSURE")
print("Boundary: NO_FINAL_THEOREM_CLOSURE_CLAIMED")

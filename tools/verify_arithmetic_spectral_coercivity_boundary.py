#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/arithmetic_spectral_coercivity_boundary_2026_06_17.json"

FORBIDDEN_CLOSED = {
    "ArithmeticSpectralCoercivity",
    "global URF theorem closure",
    "unrestricted graph-class theorem",
    "unrestricted intended-configuration theorem",
    "P vs NP closure",
    "Clay problem closure",
}

payload = json.loads(ARTIFACT.read_text())

assert payload["artifact_id"] == "ARITHMETIC_SPECTRAL_COERCIVITY_BOUNDARY_2026_06_17"
assert payload["object"] == "ArithmeticSpectralCoercivity"
assert payload["status"] == "open_boundary"
assert payload["theorem_closure_claimed"] is False

boundary = payload["claim_boundary"]
closed = set(boundary.get("closed", []))
open_items = set(boundary.get("open", []))
not_claimed = set(boundary.get("not_claimed", []))

assert not closed.intersection(FORBIDDEN_CLOSED), "boundary artifact promotes an open object into closed status"
assert "unconditional ArithmeticSpectralCoercivity proof" in open_items
assert "global URF theorem closure" in open_items
assert "P vs NP closure" in not_claimed
assert "Clay problem closure" in not_claimed
assert "proof or externally checkable certificate" in payload["next_missing_object"]

print("ARITHMETIC_SPECTRAL_COERCIVITY_BOUNDARY_OK")

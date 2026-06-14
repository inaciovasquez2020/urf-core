#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
lean = ROOT / "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean"
text = lean.read_text()

required_tokens = [
    "structure URFCoreMaturityBoundaryCertificate",
    "def URFCoreMaturityBoundaryCertificateWellFormed",
    "def URFCoreMaturityBoundaryCertificateValue",
    "theorem URFCoreMaturityBoundaryCertificateSurface",
    "URF_CORE_MATURITY_BOUNDARY_CERTIFICATE",
    "LEAN_VERIFIER_TEST_GATE_PRESENT",
    "MATURITY_BOUNDARY_CERTIFICATE_ONLY_NO_FINAL_THEOREM_CLOSURE",
    "NO_FINAL_THEOREM_CLOSURE_CLAIMED",
    "It does not prove URF scientific",
]

for token in required_tokens:
    assert token in text, token

for forbidden in ["axiom ", "opaque ", "sorry", "admit"]:
    assert forbidden not in text, forbidden

print("URF_CORE_MATURITY_BOUNDARY_CERTIFICATE_SURFACE_OK")
print("Status: MATURITY_BOUNDARY_CERTIFICATE_ONLY_NO_FINAL_THEOREM_CLOSURE")
print("Boundary: NO_FINAL_THEOREM_CLOSURE_CLAIMED")

#!/usr/bin/env python3
from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
lean = ROOT / "finite_local_urf3_globalization_bridge.lean"
art = ROOT / "artifacts/urf/finite_local_urf3_globalization_bridge_2026_05_27.json"
doc = ROOT / "docs/status/FINITE_LOCAL_URF3_GLOBALIZATION_BRIDGE_2026_05_27.md"

required_lean_tokens = [
    "theorem FiniteLocalDataToCompleteURF3Package",
    "theorem FiniteLocalDataToFiniteLocalURF3Bound",
    "structure LocalFiniteURF3ToGlobalURF3Bridge",
    "theorem LocalFiniteURF3ToGlobalURF3Bound",
    "structure UnrestrictedURF3GlobalizationBridge",
    "theorem UnrestrictedURF3_from_globalization_bridge",
    "theorem no_universal_UnrestrictedURF3GlobalizationBridge",
    "¬ Nonempty",
    "structure AdmissibleGlobalURF3CMI",
    "theorem AdmissibleGlobalURF3",
    "fun _ => 2",
    "namespace FiniteLocalURF3GlobalizationBridge",
]

required_boundary_tokens = [
    "unrestricted arbitrary-global URF Law 3",
    "replacement of global cmi_nonneg",
    "replacement of global chain_rule",
    "replacement of global capacity",
    "unrestricted Chronos-RR",
    "unrestricted H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]

for p in [lean, art, doc]:
    if not p.exists():
        print(f"missing required file: {p}", file=sys.stderr)
        raise SystemExit(1)

lean_text = lean.read_text()
doc_text = doc.read_text()
data = json.loads(art.read_text())

for token in required_lean_tokens:
    if token not in lean_text:
        print(f"missing Lean token: {token}", file=sys.stderr)
        raise SystemExit(1)

payload = doc_text + json.dumps(data) + lean_text
for token in required_boundary_tokens:
    if token not in payload:
        print(f"missing boundary token: {token}", file=sys.stderr)
        raise SystemExit(1)

if data.get("status") != "FINITE_LOCAL_AND_ADMISSIBLE_GLOBAL_CLOSED_UNIVERSAL_REFUTED":
    print("bad artifact status", file=sys.stderr)
    raise SystemExit(1)

print("FINITE_LOCAL_URF3_GLOBALIZATION_BRIDGE_OK")

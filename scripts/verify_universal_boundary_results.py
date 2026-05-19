#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/UniversalBoundaryResults.lean"
artifact = ROOT / "artifacts/urf/universal_boundary_results_2026_05_19.json"
status = ROOT / "docs/status/UNIVERSAL_BOUNDARY_RESULTS_2026_05_19.md"

for path in (lean, artifact, status):
    if not path.exists():
        raise SystemExit(f"missing required file: {path}")

lean_text = lean.read_text()

for token in [
    "theorem TaggedUniversalRigidityGrammarExistence",
    "theorem TaggedUniversalGrammar_encode_injective",
    "theorem TaggedUniversalGrammar_predicate_factors",
    "theorem TaggedUniversalGrammar_relation_factors",
    "theorem UnitFalseEncoder_range_ne_BoolIdEncoder_range",
    "theorem no_Unit_equiv_Bool",
    "theorem not_unconditional_translation_from_injective_encoders",
    "theorem UnrestrictedUFEG_vanishing_gap_obstruction",
]:
    if token not in lean_text:
        raise SystemExit(f"missing Lean token: {token}")

for forbidden in ["axiom ", "sorry", "\\nadmit", "by admit"]:
    if forbidden in lean_text:
        raise SystemExit(f"forbidden Lean token present: {forbidden}")

data = json.loads(artifact.read_text())

if data["status"] != "BOUNDARY_RESULTS_CLOSED":
    raise SystemExit("unexpected artifact status")

classification = data["classification"]
if classification["weak_tagged_universal_grammar"] != "SOLVED":
    raise SystemExit("weak tagged grammar must be SOLVED")
if classification["unconditional_translation_from_injective_encoders"] != "REFUTED":
    raise SystemExit("unconditional translation must be REFUTED")
if classification["unrestricted_ufeg_without_floor"] != "OBSTRUCTED":
    raise SystemExit("unrestricted UFEG without floor must be OBSTRUCTED")

status_text = status.read_text()

for boundary in [
    "Does not prove:",
    "strong universal RigidityGrammar existence",
    "unconditional UniversalTranslationTheorem",
    "unrestricted UniversalFiberEntropyGap",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    if boundary not in status_text:
        raise SystemExit(f"missing boundary token: {boundary}")

print("Universal boundary results verified.")

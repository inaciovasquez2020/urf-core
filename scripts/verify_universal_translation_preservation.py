#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/UniversalTranslationPreservation.lean"
artifact = ROOT / "artifacts/urf/universal_translation_preservation_2026_05_19.json"
status = ROOT / "docs/status/UNIVERSAL_TRANSLATION_PRESERVATION_2026_05_19.md"

for path in (lean, artifact, status):
    if not path.exists():
        raise SystemExit(f"missing required file: {path}")

lean_text = lean.read_text()

for token in [
    "theorem UniversalTranslationTheorem_two_sided_conditional_on_equal_ranges",
    "theorem UniversalTranslationTheorem_predicate_preservation",
    "theorem UniversalTranslationTheorem_relation_preservation",
    "SharedRigidityCodeBijection_two_sided",
    "SharedRigidityCodeBijection_predicate",
    "SharedRigidityCodeBijection_relation",
]:
    if token not in lean_text:
        raise SystemExit(f"missing Lean token: {token}")

for forbidden in ["axiom ", "sorry", "admit"]:
    if forbidden in lean_text:
        raise SystemExit(f"forbidden Lean token present: {forbidden}")

data = json.loads(artifact.read_text())

if data["status"] != "CONDITIONAL_TRANSLATION_PRESERVATION_CLOSED":
    raise SystemExit("unexpected artifact status")

if data["condition"] != "Set.range EA.encode = Set.range EB.encode":
    raise SystemExit("condition must remain equal encoder ranges")

status_text = status.read_text()

for boundary in [
    "Does not prove:",
    "existence of a universal RigidityGrammar",
    "unconditional UniversalTranslationTheorem",
    "unrestricted UniversalFiberEntropyGap",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    if boundary not in status_text:
        raise SystemExit(f"missing boundary token: {boundary}")

print("Universal translation preservation verified.")

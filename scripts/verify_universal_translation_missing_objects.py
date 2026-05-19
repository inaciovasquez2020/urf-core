#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

LEAN = ROOT / "lean/URF/Foundation/UniversalTranslationMissingObjects.lean"
DOC = ROOT / "docs/status/UNIVERSAL_TRANSLATION_MISSING_OBJECTS_2026_05_19.md"
ARTIFACT = ROOT / "artifacts/urf/universal_translation_missing_objects_2026_05_19.json"
ROOT_IMPORT = ROOT / "lean/URF.lean"

lean_text = LEAN.read_text()
doc_text = DOC.read_text()
artifact = json.loads(ARTIFACT.read_text())
root_import_text = ROOT_IMPORT.read_text()

for token in [
    "structure UniversalRigidityGrammarCandidate",
    "structure CanonicalDomainEncoderFamily",
    "structure UniversalTranslationMissingObjects",
    "def universalTranslationTheoremWitness",
    "theorem universal_translation_from_missing_objects",
    "theorem universal_translation_candidate_exists",
]:
    assert token in lean_text, f"missing Lean token: {token}"

for forbidden in ["sorry", "admit", "axiom"]:
    assert forbidden not in lean_text, f"forbidden Lean token present: {forbidden}"

assert "import URF.Foundation.UniversalTranslationMissingObjects" in root_import_text

for token in [
    "Status: CONDITIONAL_MISSING_OBJECTS_SURFACE",
    "Conditional missing-objects surface only.",
    "Does not prove:",
    "existence of `UniversalTranslationMissingObjects`",
    "unconditional `UniversalTranslationTheorem`",
    "unrestricted `UniversalFiberEntropyGap`",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    assert token in doc_text, f"missing doc token: {token}"

assert artifact["status"] == "CONDITIONAL_MISSING_OBJECTS_SURFACE"
assert "UniversalTranslationMissingObjects" in artifact["created_objects"]
assert artifact["conditional_bridge"] == "UniversalTranslationMissingObjects -> UniversalTranslationTheorem"

print("Universal translation missing objects verified.")

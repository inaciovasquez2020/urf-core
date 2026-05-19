#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/UniversalTranslationTheorem.lean"
root_import = ROOT / "lean/URF.lean"
doc = ROOT / "docs/status/UNIVERSAL_TRANSLATION_THEOREM_EQUIVALENCE_2026_05_19.md"
artifact = ROOT / "artifacts/urf/universal_translation_theorem_equivalence_2026_05_19.json"

lean_text = lean.read_text()
doc_text = doc.read_text()
artifact_text = artifact.read_text()
data = json.loads(artifact_text)

required_lean = [
    "structure RigidityGrammar",
    "structure DomainModel",
    "structure FactorsThrough",
    "structure SameRigidityContent",
    "def UniversalTranslationTheorem",
    "Nonempty (FactorsThrough D G)",
    "theorem universal_translation_self_equivalence",
    "structure ComputationDomain",
    "structure PhysicsDomain",
    "def computationAsDomain",
    "def physicsAsDomain",
    "theorem computation_physics_equivalence_through_rigidity",
]

required_doc = [
    "Status: `CONDITIONAL_EQUIVALENCE_SURFACE`",
    "UniversalTranslationTheorem",
    "computation_physics_equivalence_through_rigidity",
    "Conditional equivalence surface only.",
    "RigidityGrammar",
    "P vs NP",
    "any Clay problem",
]

for token in required_lean:
    assert token in lean_text, f"missing Lean token: {token}"

for token in required_doc:
    assert token in doc_text, f"missing doc token: {token}"

assert "import URF.Foundation.UniversalTranslationTheorem" in root_import.read_text()
assert data["status"] == "CONDITIONAL_EQUIVALENCE_SURFACE"
assert data["defined_target"] == "UniversalTranslationTheorem"
assert data["proved_surface"] == "computation_physics_equivalence_through_rigidity"

for forbidden in [
    "theorem UniversalTranslationTheorem",
    "UniversalTranslationTheorem is proved",
    "P vs NP is proved",
    "Clay problem is solved",
    "Chronos-RR is proved",
    "H4.1/FGL is proved",
]:
    assert forbidden not in lean_text
    assert forbidden not in doc_text
    assert forbidden not in artifact_text

for forbidden_lean in ["sorry", "admit", "axiom"]:
    assert forbidden_lean not in lean_text

print("Universal translation theorem equivalence verified.")

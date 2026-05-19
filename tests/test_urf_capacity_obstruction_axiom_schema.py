from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

LEAN = ROOT / "lean/URF/Foundation/CapacityObstructionSchema.lean"
ARTIFACT = ROOT / "artifacts/urf/capacity_obstruction_axiom_schema.json"


def test_capacity_obstruction_schema_files_exist():
    assert LEAN.exists()
    assert ARTIFACT.exists()


def test_capacity_obstruction_schema_lean_core_objects():
    text = LEAN.read_text()

    required = [
        "structure CapacityObstructionSchema",
        "System : Type",
        "Goal : Type",
        "Adm : System → Prop",
        "I : Goal → Nat",
        "C_adm : System → Nat",
        "StableGen : System → Goal → Prop",
        "def CapacitySoundness",
        "def CapacityViolation",
        "def CapacityObstruction",
        "theorem contrapositive_obstruction",
        "theorem stable_generation_requires_capacity",
        "theorem capacity_excess_blocks_generation",
    ]

    for token in required:
        assert token in text


def test_capacity_obstruction_schema_has_no_unproved_lean_tokens():
    text = LEAN.read_text()

    forbidden = [
        "sorry",
        "admit",
        "axiom",
        "constant",
    ]

    for token in forbidden:
        assert token not in text


def test_capacity_obstruction_artifact_status_and_formula():
    data = json.loads(ARTIFACT.read_text())

    assert data["artifact"] == "urf_capacity_obstruction_axiom_schema"
    assert data["status"] == "CONDITIONAL"
    assert (
        data["canonical_formula"]
        == "Adm(S) ∧ C_adm(S) < I(G) ⇒ ¬StableGen(S,G)"
    )
    assert (
        data["minimal_missing_lemma"]
        == "CapacitySoundness: ∀ S G, Adm(S) → StableGen(S,G) → I(G) ≤ C_adm(S)"
    )


def test_capacity_obstruction_artifact_boundaries():
    data = json.loads(ARTIFACT.read_text())

    required_boundaries = [
        "unrestricted UniversalFiberEntropyGap",
        "unrestricted Chronos-RR",
        "unrestricted H4.1/FGL",
        "P vs NP",
        "any Clay problem",
    ]

    for boundary in required_boundaries:
        assert boundary in data["does_not_prove"]

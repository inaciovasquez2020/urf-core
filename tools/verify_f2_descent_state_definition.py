#!/usr/bin/env python3
from pathlib import Path
import json

lean = Path("lean/URF/F2/DescentState.lean").read_text()
doc = Path("docs/status/F2_DESCENT_STATE_DEFINITION_2026_06_05.md").read_text()
artifact = json.loads(Path("artifacts/urf/f2_descent_state_definition_2026_06_05.json").read_text())

required_lean = [
    "structure F2DescentState",
    "matrix : Matrix (Fin n) (Fin m) (ZMod 2)",
    "rank : Nat",
    "def descentRank",
    "theorem descentRank_eq_rank",
]

required_boundary = [
    "ConcretePhiDefinitionUsingExtractRMatrix",
    "ConcreteRankAgreement",
    "AbstractStepRealizesCanonicalF2Pivot",
    "DescentSystem.step_rank_drop",
    "DescentSystem.zero_rank_reached_within_rank",
    "F2DescentTerminatesFullIteration",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]

for item in required_lean:
    assert item in lean, item

for item in required_boundary:
    assert item in doc, item
    assert item in artifact["not_closed"], item

assert artifact["status"] == "F2_DESCENT_STATE_DEFINED"
assert artifact["closed_object"] == "F2DescentStateDefinition"
assert artifact["next_admissible_object"] == "ConcretePhiDefinitionUsingExtractRMatrix"

print("F2_DESCENT_STATE_DEFINITION_OK")

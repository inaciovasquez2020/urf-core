from pathlib import Path
import json
import subprocess
import sys

LEAN = Path("URF/TheoremClosure/NoStatusPromotion.lean")
DOC = Path("docs/status/URF_CORE_NO_STATUS_PROMOTION_THEOREM_CLOSURE_2026_05_15.md")
ARTIFACT = Path("artifacts/urf-core/no_status_promotion_theorem_closure_2026_05_15.json")

for path in (LEAN, DOC, ARTIFACT):
    assert path.exists(), path

lean = LEAN.read_text()
doc = DOC.read_text()
artifact = json.loads(ARTIFACT.read_text())

required_lean = [
    "theorem no_status_promotion_closed",
    "theorem frontier_open_cannot_transfer_to_solved_closed",
    "theorem solved_target_requires_solved_source_rank_closed",
    "Nat.not_lt_of_ge",
]

for phrase in required_lean:
    assert phrase in lean, phrase

for forbidden in ("axiom ", "admit", "sorry"):
    assert forbidden not in lean, forbidden

assert artifact["status"] == "THEOREM_CLOSED"
assert artifact["uses_axiom"] is False
assert artifact["uses_admit"] is False
assert artifact["uses_sorry"] is False
assert artifact["boundary"]["no_whole_urf_theorem_closure"] is True
assert artifact["boundary"]["does_not_discharge_existing_axioms"] is True
assert artifact["boundary"]["does_not_discharge_existing_admits"] is True

required_doc = [
    "STATUS := THEOREM_CLOSED",
    "no_status_promotion_closed",
    "uses_axiom := false",
    "uses_admit := false",
    "uses_sorry := false",
    "no_whole_URF_theorem_closure",
    "no_P_vs_NP_closure",
    "no_Clay_problem_closure",
]

for phrase in required_doc:
    assert phrase in doc, phrase

subprocess.run(["lake", "env", "lean", str(LEAN)], check=True)

print("URF Core no-status-promotion theorem closure verified.")

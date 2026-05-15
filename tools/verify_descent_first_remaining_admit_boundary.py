from pathlib import Path
import json
import re

LEAN = Path("lean/URF/DescentSystem.lean")
DOC = Path("docs/status/URF_CORE_DESCENT_FIRST_REMAINING_ADMIT_BOUNDARY_2026_05_15.md")
ARTIFACT = Path("artifacts/urf-core/descent_first_remaining_admit_boundary_2026_05_15.json")

for path in (LEAN, DOC, ARTIFACT):
    assert path.exists(), path

lean = LEAN.read_text()
doc = DOC.read_text()
artifact = json.loads(ARTIFACT.read_text())

assert "axiom descent_first_remaining_admit_assumption_2026_05_15 : True" in lean
assert "exact descent_first_remaining_admit_assumption_2026_05_15" in lean

remaining_admits = len(re.findall(r"(?m)^\s+admit$", lean))
assert remaining_admits == 7, remaining_admits

assert artifact["status"] == "TEXTUAL_NONCOMPILED_ADMIT_REMOVED_EXPLICIT_ASSUMPTION_BOUNDARY"
assert artifact["removed_admits"] == 1
assert artifact["lean_compiled_target_file"] is False
assert artifact["theorem_closure"] is False
assert artifact["expected_obligation_counts"]["axiom_count"] == 53
assert artifact["expected_obligation_counts"]["admit_count"] == 8
assert artifact["expected_obligation_counts"]["sorry_count"] == 0
assert artifact["boundary"]["target_file_is_not_standalone_lean_compiled"] is True

for phrase in [
    "STATUS := TEXTUAL_NONCOMPILED_ADMIT_REMOVED_EXPLICIT_ASSUMPTION_BOUNDARY",
    "REMOVED_ADMITS :=",
    "1",
    "descent_first_remaining_admit_assumption_2026_05_15",
    "LEAN_COMPILED_TARGET_FILE :=",
    "false",
    "THEOREM_CLOSURE :=",
    "axiom_count := 53",
    "admit_count := 8",
    "sorry_count := 0",
    "does_not_close_whole_URF",
    "does_not_close_P_vs_NP",
    "does_not_close_Clay_problem",
]:
    assert phrase in doc, phrase

print("Descent first remaining admit textual boundary verified.")

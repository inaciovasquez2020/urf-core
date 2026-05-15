from pathlib import Path
import json
import re

LEAN = Path("admissible/lean/URFAdmissible.lean")
DOC = Path("docs/status/URF_CORE_ADMISSIBLE_NORMALIZATION_BOUNDARIES_2026_05_15.md")
ARTIFACT = Path("artifacts/urf-core/urf_admissible_normalization_boundaries_2026_05_15.json")

for path in (LEAN, DOC, ARTIFACT):
    assert path.exists(), path

lean = LEAN.read_text()
doc = DOC.read_text()
artifact = json.loads(ARTIFACT.read_text())

required = [
    "axiom TM_normalization_assumption",
    "theorem TM_normalization",
    "exact TM_normalization_assumption M",
    "axiom RAM_normalization_assumption",
    "theorem RAM_normalization",
    "exact RAM_normalization_assumption R",
]

for phrase in required:
    assert phrase in lean, phrase

for theorem in ("TM_normalization", "RAM_normalization"):
    m = re.search(rf"theorem\s+{theorem}\b(?P<body>.*?)(?=\n/--|\nend URF)", lean, flags=re.S)
    assert m, theorem
    assert "admit" not in m.group("body"), theorem

assert artifact["status"] == "TEXTUAL_NONCOMPILED_ADMITS_REMOVED_EXPLICIT_ASSUMPTION_BOUNDARIES"
assert artifact["removed_admits"] == 2
assert artifact["theorem_closure"] is False
assert artifact["lean_compiled_target_file"] is False
assert artifact["boundary"]["target_file_is_not_standalone_lean_compiled"] is True
assert artifact["boundary"]["converted_two_admits_to_explicit_assumptions"] is True
assert artifact["boundary"]["does_not_discharge_TM_normalization"] is True
assert artifact["boundary"]["does_not_discharge_RAM_normalization"] is True

for phrase in [
    "STATUS := TEXTUAL_NONCOMPILED_ADMITS_REMOVED_EXPLICIT_ASSUMPTION_BOUNDARIES",
    "REMOVED_ADMITS :=",
    "2",
    "TM_normalization_assumption",
    "RAM_normalization_assumption",
    "THEOREM_CLOSURE :=",
    "false",
    "LEAN_COMPILED_TARGET_FILE :=",
    "does_not_close_whole_URF",
    "does_not_close_P_vs_NP",
    "does_not_close_Clay_problem",
]:
    assert phrase in doc, phrase

# Target file is a legacy/non-standalone Lean surface; do not claim Lean theorem closure here.

print("URFAdmissible normalization admit boundaries verified.")

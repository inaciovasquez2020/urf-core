from pathlib import Path
import json
import re
import subprocess

LEAN = Path("urf_law3.lean")
DOC = Path("docs/status/URF_CORE_LAW3_ENTROPY_NONAMPLIFICATION_2026_05_15.md")
ARTIFACT = Path("artifacts/urf-core/urf_law3_entropy_nonamplification_2026_05_15.json")

for path in (LEAN, DOC, ARTIFACT):
    assert path.exists(), path

lean = LEAN.read_text()
doc = DOC.read_text()
artifact = json.loads(ARTIFACT.read_text())

for phrase in [
    "theorem urf_law3",
    "Finset.single_le_sum",
    "chain_rule T",
    "capacity T",
    "cmi_nonneg i",
]:
    assert phrase in lean, phrase

m = re.search(r"theorem\s+urf_law3\b(?P<body>.*)", lean, flags=re.S)
assert m, "urf_law3 theorem block not found"

for forbidden in ["admit", "sorry"]:
    assert forbidden not in m.group("body"), forbidden

assert artifact["status"] == "THEOREM_CLOSED"
assert artifact["closed_theorem"] == "urf_law3"
assert artifact["removed_admits"] == 1
assert artifact["axiom_count_delta"] == 6
assert artifact["admit_count_delta"] == -1
assert artifact["sorry_count_delta"] == 0
assert artifact["expected_obligation_counts"]["axiom_count"] == 52
assert artifact["expected_obligation_counts"]["admit_count"] == 9
assert artifact["expected_obligation_counts"]["sorry_count"] == 0
assert artifact["boundary"]["adds_six_structural_axioms_for_law3_symbols"] is True
assert artifact["boundary"]["law3_closed_relative_to_existing_axioms"] is True
assert artifact["boundary"]["does_not_close_whole_urf"] is True

for phrase in [
    "STATUS := THEOREM_CLOSED",
    "CLOSED_THEOREM :=",
    "urf_law3",
    "REMOVED_ADMITS :=",
    "1",
    "axiom_count := 52",
    "admit_count := 9",
    "sorry_count := 0",
    "does_not_close_whole_URF",
    "does_not_close_P_vs_NP",
    "does_not_close_Clay_problem",
]:
    assert phrase in doc, phrase

subprocess.run(["lake", "env", "lean", str(LEAN)], check=True)

print("URF Law 3 entropy non-amplification theorem verified.")

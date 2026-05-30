import json
import subprocess
from pathlib import Path
ROOT = Path(file).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/cmi_nonnegativity_proof_2026_05_30.json"
LEAN = ROOT / "lean/URF/Foundation/CMINonnegativityProof.lean"
DOC = ROOT / "docs/status/CMI_NONNEGATIVITY_PROOF_2026_05_30.md"
def test_cmi_nonnegativity_artifact_boundary():
artifact = json.loads(ARTIFACT.read_text())
assert artifact["status"] == "CMI_NONNEGATIVITY_INTERFACE_ONLY_NO_CHAIN_RULE_OR_CAPACITY_BOUND"
assert artifact["next_admissible_object"] == "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF"
assert "NOT_FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF" in artifact["excluded_claims"]
assert "NOT_GLOBAL_URF_LAW3" in artifact["excluded_claims"]
assert "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF" in artifact["minimal_missing_objects"]
def test_cmi_nonnegativity_lean_surface():
lean = LEAN.read_text()
assert "structure CMINonnegativityProof" in lean
assert "ConditionalMutualInformationValue" in lean
assert "RandomVariable → RandomVariable → RandomVariable → ℝ" in lean
assert "cmi_nonneg" in lean
assert "theorem cmi_nonnegativity_proof" in lean
def test_cmi_nonnegativity_doc_boundary():
doc = DOC.read_text()
assert "CMI(X ; Y | Z) ≥ 0" in doc
assert "finite mutual-information chain rule" in doc
assert "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF" in doc
def test_cmi_nonnegativity_verifier():
result = subprocess.run(
["python3", "tools/verify_cmi_nonnegativity_proof.py"],
cwd=ROOT,
check=True,
capture_output=True,
text=True,
)
assert "CMI_NONNEGATIVITY_PROOF_OK" in result.stdout

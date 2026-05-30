import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/finite_mutual_information_chain_rule_proof_2026_05_30.json"
LEAN = ROOT / "lean/URF/Foundation/FiniteMutualInformationChainRuleProof.lean"
DOC = ROOT / "docs/status/FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_2026_05_30.md"

def test_finite_chain_rule_artifact_boundary():
    artifact = json.loads(ARTIFACT.read_text())
    assert artifact["status"] == "FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL"
    assert artifact["next_admissible_object"] == "CHANNEL_CAPACITY_BOUND_DERIVATION"
    assert "NOT_CHANNEL_CAPACITY_BOUND_DERIVATION" in artifact["excluded_claims"]
    assert "NOT_GLOBAL_URF_LAW3" in artifact["excluded_claims"]
    assert "CHANNEL_CAPACITY_BOUND_DERIVATION" in artifact["minimal_missing_objects"]

def test_finite_chain_rule_lean_surface():
    lean = LEAN.read_text()
    assert "structure FiniteMutualInformationChainRuleProof" in lean
    assert "finiteLocalSum : Nat → (Nat → ℝ) → ℝ" in lean
    assert "totalMI : ℝ" in lean
    assert "localCMIValue : Nat → ℝ" in lean
    assert "finite_chain_rule" in lean
    assert "theorem finite_mutual_information_chain_rule_proof" in lean
    assert "theorem finite_mutual_information_chain_rule_local_nonneg" in lean

def test_finite_chain_rule_doc_boundary():
    doc = DOC.read_text()
    assert "I_total = finiteLocalSum(T, CMI)" in doc
    assert "channel-capacity bound derivation" in doc
    assert "CHANNEL_CAPACITY_BOUND_DERIVATION" in doc
    assert "GLOBAL_VALID_KERNEL_THEOREM" in doc

def test_finite_chain_rule_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_finite_mutual_information_chain_rule_proof.py"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    assert "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_OK" in result.stdout

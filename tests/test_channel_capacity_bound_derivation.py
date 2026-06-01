import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/channel_capacity_bound_derivation_2026_05_30.json"
LEAN = ROOT / "lean/URF/Foundation/ChannelCapacityBoundDerivation.lean"
DOC = ROOT / "docs/status/CHANNEL_CAPACITY_BOUND_DERIVATION_2026_05_30.md"

def test_channel_capacity_artifact_boundary():
    artifact = json.loads(ARTIFACT.read_text())
    assert artifact["status"] == "CHANNEL_CAPACITY_BOUND_DERIVATION_CLOSED_CONDITIONAL_ON_FINITE_CAPACITY_BOUND_NO_GLOBAL_KERNEL"
    assert artifact["next_admissible_object"] == "GLOBAL_VALID_KERNEL_THEOREM"
    assert "finite_capacity_bound" in artifact["conditional_inputs"]
    assert "NOT_GLOBAL_VALID_KERNEL_THEOREM" in artifact["excluded_claims"]
    assert "NOT_GLOBAL_URF_LAW3" in artifact["excluded_claims"]
    assert "GLOBAL_VALID_KERNEL_THEOREM" in artifact["minimal_missing_objects"]

def test_channel_capacity_lean_surface():
    lean = LEAN.read_text()
    assert "structure ChannelCapacityBoundDerivation" in lean
    assert "finiteChain : FiniteMutualInformationChainRuleProof" in lean
    assert "channelCapacity : ℝ" in lean
    assert "finite_capacity_bound" in lean
    assert "theorem channel_capacity_bound_derivation" in lean
    assert "rw [K.finiteChain.finite_chain_rule]" in lean
    assert "exact K.finite_capacity_bound" in lean

def test_channel_capacity_doc_boundary():
    doc = DOC.read_text()
    assert "totalMI ≤ channelCapacity" in doc
    assert "global valid kernel theorem" in doc
    assert "GLOBAL_VALID_KERNEL_THEOREM" in doc

def test_channel_capacity_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_channel_capacity_bound_derivation.py"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    assert "CHANNEL_CAPACITY_BOUND_DERIVATION_OK" in result.stdout

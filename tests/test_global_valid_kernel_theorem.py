import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/global_valid_kernel_theorem_2026_05_31.json"
LEAN = ROOT / "lean/URF/Foundation/GlobalValidKernelTheorem.lean"
DOC = ROOT / "docs/status/GLOBAL_VALID_KERNEL_THEOREM_2026_05_31.md"

def test_global_valid_kernel_artifact_boundary():
    artifact = json.loads(ARTIFACT.read_text())
    assert artifact["status"] == "GLOBAL_VALID_KERNEL_THEOREM_CLOSED_CONDITIONAL_ON_KERNEL_CAPACITY_SOUNDNESS_NO_GLOBAL_LAW3"
    assert artifact["next_admissible_object"] == "GLOBAL_URF_LAW3"
    assert "kernel_capacity_soundness" in artifact["conditional_inputs"]
    assert "NOT_GLOBAL_URF_LAW3" in artifact["excluded_claims"]
    assert "GLOBAL_URF_LAW3" in artifact["minimal_missing_objects"]

def test_global_valid_kernel_lean_surface():
    lean = LEAN.read_text()
    assert "structure GlobalValidKernelTheorem" in lean
    assert "channelDerivation : ChannelCapacityBoundDerivation" in lean
    assert "validKernel : Prop" in lean
    assert "kernel_valid : validKernel" in lean
    assert "kernel_capacity_soundness" in lean
    assert "theorem global_valid_kernel_theorem" in lean
    assert "rw [K.channelDerivation.finiteChain.finite_chain_rule]" in lean
    assert "exact K.kernel_capacity_soundness K.kernel_valid" in lean

def test_global_valid_kernel_doc_boundary():
    doc = DOC.read_text()
    assert "ValidKernel -> finiteLocalSum(T, localCMIValue) ≤ channelCapacity" in doc
    assert "global URF Law 3" in doc
    assert "GLOBAL_URF_LAW3" in doc

def test_global_valid_kernel_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_global_valid_kernel_theorem.py"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    assert "GLOBAL_VALID_KERNEL_THEOREM_OK" in result.stdout

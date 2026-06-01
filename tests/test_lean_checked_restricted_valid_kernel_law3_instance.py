import json
import subprocess
from pathlib import Path

ART = Path("artifacts/urf/lean_checked_restricted_valid_kernel_law3_instance_2026_06_01.json")
LEAN = Path("lean/URF/Foundation/RestrictedValidKernelLaw3Instance.lean")
ROOT = Path("lean/URF.lean")
DOC = Path("docs/status/LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_2026_06_01.md")
VERIFY = Path("tools/verify_lean_checked_restricted_valid_kernel_law3_instance.py")

def test_artifact_records_lean_checked_conditional_instance():
    data = json.loads(ART.read_text())
    assert data["object"] == "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE"
    assert data["status"] == "LEAN_CHECKED_CONDITIONAL_INSTANCE_SUPPLIED_BINDINGS_REMAIN_HYPOTHESES"
    assert data["lean_checked_restricted_instance_supplied"] is True

def test_lean_file_contains_structure_and_theorem():
    text = LEAN.read_text()
    assert "structure RestrictedValidKernelLaw3Input" in text
    assert "theorem lean_checked_restricted_valid_kernel_law3_instance" in text
    assert "law3ConsequenceFromBindings" in text

def test_root_imports_module():
    assert "import URF.Foundation.RestrictedValidKernelLaw3Instance" in ROOT.read_text()

def test_doc_records_boundary_and_next_object():
    doc = DOC.read_text()
    assert "no unrestricted global URF Law 3" in doc
    assert "DIAMETER_SEPARATION_FILLING_OBSTRUCTION_PROOF_TARGET" in doc

def test_verifier_passes():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OK" in result.stdout

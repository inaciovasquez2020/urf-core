import json
import subprocess
from pathlib import Path

ART = Path("artifacts/urf/global_urf_law3_restricted_valid_kernel_instance_2026_06_01.json")
DOC = Path("docs/status/GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_2026_06_01.md")
VERIFY = Path("tools/verify_global_urf_law3_restricted_valid_kernel_instance.py")

def test_artifact_is_target_open():
    data = json.loads(ART.read_text())
    assert data["object"] == "GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE"
    assert data["status"] == "TARGET_OPEN_RESTRICTED_VALID_KERNEL_INSTANCE_NOT_SUPPLIED"
    assert data["decision"] == "PASS"

def test_no_unconditional_theorem_claim():
    data = json.loads(ART.read_text())
    assert data["restricted_valid_kernel_instance_supplied"] is False
    assert data["global_urf_law3_closed"] is False
    assert data["unconditional_theorem_claimed"] is False

def test_required_inputs_are_missing():
    data = json.loads(ART.read_text())
    required = {
        "restricted_valid_kernel_domain",
        "valid_kernel_assumption_binding",
        "finite_local_cmi_nonnegativity_binding",
        "finite_chain_rule_binding",
        "capacity_bound_binding",
        "restricted_law3_consequence_statement",
        "lean_checked_instance_or_explicit_missing_lemma",
    }
    assert required.issubset(set(data["missing_inputs"]))

def test_doc_records_next_admissible_object():
    doc = DOC.read_text()
    assert "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA" in doc
    assert "TARGET_OPEN_RESTRICTED_VALID_KERNEL_INSTANCE_NOT_SUPPLIED" in doc

def test_verifier_passes():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_OK" in result.stdout

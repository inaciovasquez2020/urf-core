import json
import subprocess
from pathlib import Path

ART = Path("artifacts/urf/restricted_valid_kernel_law3_instance_or_explicit_missing_lemma_2026_06_01.json")
DOC = Path("docs/status/RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA_2026_06_01.md")
VERIFY = Path("tools/verify_restricted_valid_kernel_law3_instance_or_explicit_missing_lemma.py")

def test_artifact_records_explicit_missing_lemma():
    data = json.loads(ART.read_text())
    assert data["object"] == "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA"
    assert data["status"] == "EXPLICIT_MISSING_LEMMA_RECORDED_NO_LEAN_INSTANCE_SUPPLIED"
    assert data["explicit_missing_lemma_supplied"] is True

def test_no_restricted_instance_claimed():
    data = json.loads(ART.read_text())
    assert data["lean_checked_restricted_instance_supplied"] is False
    assert data["restricted_valid_kernel_law3_closed"] is False

def test_missing_lemma_name_is_fixed():
    data = json.loads(ART.read_text())
    assert data["missing_lemma"]["name"] == "RestrictedValidKernelDomainBindingAndLaw3Consequence"

def test_doc_records_next_admissible_object():
    doc = DOC.read_text()
    assert "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE" in doc
    assert "EXPLICIT_MISSING_LEMMA_RECORDED_NO_LEAN_INSTANCE_SUPPLIED" in doc

def test_verifier_passes():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA_OK" in result.stdout

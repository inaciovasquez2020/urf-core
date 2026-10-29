import hashlib
import json
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFIER = ROOT / "tools" / "verify_zero_overclaim.py"
REGISTRY = ROOT / "artifacts" / "status" / "claim_registry.json"
VALID_REVISION = "a" * 40


def make_project(tmp_path, *, source_revision=VALID_REVISION,
                 verification_revision=VALID_REVISION,
                 evidence_class="formal_proof", receipt_exists=True,
                 artifact_hash_override=None, receipt_revision=None,
                 receipt_evidence_class=None):
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    claim = registry["claims"][0]
    claim["status"] = "PROVED"
    claim["public_claim"] = "A narrowly scoped theorem is proved."
    claim["boundary"] = []
    claim["evidence"] = ["Lean proof and audited theorem report."]
    claim["source_revision"] = source_revision

    artifact_dir = tmp_path / "artifacts" / "receipts"
    artifact_dir.mkdir(parents=True)
    artifact_file = artifact_dir / "proof-output.txt"
    artifact_file.write_text("proof output\n", encoding="utf-8")
    actual_hash = hashlib.sha256(artifact_file.read_bytes()).hexdigest()
    recorded_hash = artifact_hash_override or actual_hash
    artifact_record = {"path": "artifacts/receipts/proof-output.txt", "sha256": recorded_hash}

    receipt_path = artifact_dir / "proof.json"
    receipt_data = {
        "source_revision": receipt_revision if receipt_revision is not None else source_revision,
        "evidence_class": receipt_evidence_class if receipt_evidence_class is not None else evidence_class,
        "artifacts": [artifact_record],
    }
    if receipt_exists:
        receipt_path.write_text(json.dumps(receipt_data), encoding="utf-8")

    claim["verification"] = {
        "receipt": "artifacts/receipts/proof.json",
        "source_revision": verification_revision,
        "evidence_class": evidence_class,
        "artifacts": [artifact_record],
    }

    (tmp_path / "artifacts" / "status").mkdir(parents=True)
    (tmp_path / "artifacts" / "status" / "claim_registry.json").write_text(
        json.dumps(registry), encoding="utf-8"
    )
    verifier_path = tmp_path / "tools" / "verify_zero_overclaim.py"
    verifier_path.parent.mkdir(parents=True)
    shutil.copyfile(VERIFIER, verifier_path)
    return tmp_path


def run_verifier(project):
    return subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        cwd=project,
        text=True,
        capture_output=True,
    )


def test_zero_overclaim_verifier_passes():
    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert "ZERO_OVERCLAIM_VERIFIER_OK" in result.stdout


def test_proved_claim_with_unresolved_obligations_is_rejected(tmp_path):
    project = make_project(tmp_path)
    registry_path = project / "artifacts" / "status" / "claim_registry.json"
    registry = json.loads(registry_path.read_text(encoding="utf-8"))
    registry["claims"][0]["unresolved_obligations"] = ["A required assumption remains unresolved."]
    registry_path.write_text(json.dumps(registry), encoding="utf-8")

    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim has unresolved obligations" in result.stdout


def test_proved_claim_with_stale_source_revision_is_rejected(tmp_path):
    project = make_project(tmp_path, verification_revision="b" * 40)
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim has stale source revision" in result.stdout


def test_proved_claim_without_receipt_file_is_rejected(tmp_path):
    project = make_project(tmp_path, receipt_exists=False)
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "proof receipt file does not exist" in result.stdout


def test_proved_claim_with_non_commit_revision_is_rejected(tmp_path):
    project = make_project(tmp_path, source_revision="current-revision")
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "source_revision is not a full immutable Git commit SHA" in result.stdout


def test_proved_claim_with_non_formal_evidence_class_is_rejected(tmp_path):
    project = make_project(tmp_path, evidence_class="build_test")
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim requires formal_proof evidence_class" in result.stdout


def test_proved_claim_with_artifact_hash_mismatch_is_rejected(tmp_path):
    project = make_project(tmp_path, artifact_hash_override="0" * 64)
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "artifact hash mismatch" in result.stdout


def test_receipt_metadata_must_match_verification_record(tmp_path):
    project = make_project(tmp_path, receipt_revision="b" * 40)
    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "receipt content source_revision does not match claim" in result.stdout


def test_valid_immutable_formal_proof_receipt_passes(tmp_path):
    project = make_project(tmp_path)
    result = run_verifier(project)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "ZERO_OVERCLAIM_VERIFIER_OK" in result.stdout


def test_malformed_evidence_class_is_rejected_without_crashing(tmp_path):
    project = make_project(tmp_path, evidence_class="formal_proof")
    registry_path = project / "artifacts" / "status" / "claim_registry.json"
    registry = json.loads(registry_path.read_text(encoding="utf-8"))
    registry["claims"][0]["verification"]["evidence_class"] = ["formal_proof"]
    registry_path.write_text(json.dumps(registry), encoding="utf-8")

    result = run_verifier(project)
    assert result.returncode == 1, result.stdout + result.stderr
    assert "proof receipt has invalid evidence_class" in result.stdout

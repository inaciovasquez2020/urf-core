import json
import shutil
import subprocess
from pathlib import Path


def test_zero_overclaim_verifier_passes():
    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert "ZERO_OVERCLAIM_VERIFIER_OK" in result.stdout


def test_proved_claim_with_unresolved_obligations_is_rejected(tmp_path):
    registry = json.loads(Path("artifacts/status/claim_registry.json").read_text())
    claim = registry["claims"][0]
    claim["status"] = "PROVED"
    claim["unresolved_obligations"] = ["A required assumption remains unresolved."]

    registry_path = tmp_path / "artifacts" / "status" / "claim_registry.json"
    registry_path.parent.mkdir(parents=True)
    registry_path.write_text(json.dumps(registry), encoding="utf-8")

    verifier_path = tmp_path / "tools" / "verify_zero_overclaim.py"
    verifier_path.parent.mkdir(parents=True)
    shutil.copyfile("tools/verify_zero_overclaim.py", verifier_path)

    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        cwd=tmp_path,
        text=True,
        capture_output=True,
    )

    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim has unresolved obligations" in result.stdout


def test_proved_claim_with_stale_source_revision_is_rejected(tmp_path):
    registry = json.loads(Path("artifacts/status/claim_registry.json").read_text())
    claim = registry["claims"][0]
    claim["status"] = "PROVED"
    claim["evidence"] = ["Recorded verification evidence."]
    claim["source_revision"] = "current-revision"
    claim["verification"] = {
        "receipt": "proof-receipt-001",
        "source_revision": "stale-revision",
    }

    registry_path = tmp_path / "artifacts" / "status" / "claim_registry.json"
    registry_path.parent.mkdir(parents=True)
    registry_path.write_text(json.dumps(registry), encoding="utf-8")

    verifier_path = tmp_path / "tools" / "verify_zero_overclaim.py"
    verifier_path.parent.mkdir(parents=True)
    shutil.copyfile("tools/verify_zero_overclaim.py", verifier_path)

    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        cwd=tmp_path,
        text=True,
        capture_output=True,
    )

    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim has stale source revision" in result.stdout


def test_proved_claim_without_proof_receipt_is_rejected(tmp_path):
    registry = json.loads(Path("artifacts/status/claim_registry.json").read_text())
    claim = registry["claims"][0]
    claim["status"] = "PROVED"
    claim["evidence"] = ["Existing evidence list is not a proof receipt."]
    claim.pop("verification", None)

    registry_path = tmp_path / "artifacts" / "status" / "claim_registry.json"
    registry_path.parent.mkdir(parents=True)
    registry_path.write_text(json.dumps(registry), encoding="utf-8")

    verifier_path = tmp_path / "tools" / "verify_zero_overclaim.py"
    verifier_path.parent.mkdir(parents=True)
    shutil.copyfile("tools/verify_zero_overclaim.py", verifier_path)

    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        cwd=tmp_path,
        text=True,
        capture_output=True,
    )

    assert result.returncode == 1, result.stdout + result.stderr
    assert "PROVED claim lacks proof receipt" in result.stdout

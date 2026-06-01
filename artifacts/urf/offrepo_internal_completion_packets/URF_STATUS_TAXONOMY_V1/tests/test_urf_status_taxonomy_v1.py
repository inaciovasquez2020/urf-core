import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_status_taxonomy_v1_2026_05_30.json"
VERIFY = ROOT / "tools" / "verify_urf_status_taxonomy_v1.py"

def test_taxonomy_artifact_shape():
    data = json.loads(ARTIFACT.read_text())
    assert data["object_id"] == "URF_STATUS_TAXONOMY_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "URF_GLOBAL_CLAIM_LEDGER_V1"
    statuses = {entry["status"] for entry in data["statuses"]}
    assert "THEOREM_CLOSED" in statuses
    assert "EMPIRICAL_PIPELINE_ONLY" in statuses
    assert "BLOCKED_BY_MISSING_OBJECT" in statuses
    assert "DRAFT_OFF_REPO_NO_REPO_WRITE" in statuses

def test_reserved_terms_block_ambiguity():
    data = json.loads(ARTIFACT.read_text())
    assert "closed" in data["reserved_terms"]
    assert "validated" in data["reserved_terms"]
    assert "proved" in data["reserved_terms"]
    assert "adopted" in data["reserved_terms"]

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "URF_STATUS_TAXONOMY_V1_OK" in result.stdout

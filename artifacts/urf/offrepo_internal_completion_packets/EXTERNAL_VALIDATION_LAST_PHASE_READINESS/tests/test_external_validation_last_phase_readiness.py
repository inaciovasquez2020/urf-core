import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "external_validation_last_phase_readiness_2026_05_30.json"
VERIFY = ROOT / "tools" / "verify_external_validation_last_phase_readiness.py"

def load():
    return json.loads(ARTIFACT.read_text())

def test_artifact_shape():
    data = load()
    assert data["object_id"] == "EXTERNAL_VALIDATION_LAST_PHASE_READINESS"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "WAIT_FOR_EXTERNAL_VALIDATION_OR_REPO_WRITE_WINDOW"

def test_internal_chain_complete():
    data = load()
    required = {
        "URF_STATUS_TAXONOMY_V1",
        "URF_GLOBAL_CLAIM_LEDGER_V1",
        "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
        "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
        "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
        "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1",
    }
    assert set(data["internal_completion_chain"]) == required
    assert set(data["internal_packets"]) == required

def test_external_objects_remain_blocked():
    data = load()
    external = {obj["object_id"]: obj for obj in data["external_objects_remaining"]}
    assert external["URF_EXTERNAL_REPRODUCTION_RECORD_V1"]["status"] == "BLOCKED_BY_EXTERNAL_ACTOR"
    assert external["URF_EXPERT_EVALUATION_PACKET_V1"]["status"] == "BLOCKED_BY_EXTERNAL_ACTOR"
    assert external["URF_PUBLIC_REVIEW_OR_CITATION_SIGNAL_V1"]["status"] == "BLOCKED_BY_EXTERNAL_ACTOR"

def test_internal_ceiling_recorded():
    data = load()
    status = data["internal_completion_status"]
    assert status["internal_objects_completed_off_repo"] == 6
    assert status["internal_completion_ceiling_before_external_validation"] == "84_PERCENT"
    assert status["external_validation_status"] == "NOT_STARTED"

def test_boundaries_preserve_nonclaim_status():
    data = load()
    forbidden = set(data["forbidden_overclaims"])
    assert "external validation completed" in forbidden
    assert "independent reproduction completed" in forbidden
    assert "expert evaluation completed" in forbidden
    assert "Chronos-RR closure" in forbidden
    assert "P vs NP closure" in forbidden
    assert "Clay-problem closure" in forbidden

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], cwd=ROOT, text=True, capture_output=True, check=True)
    assert "EXTERNAL_VALIDATION_LAST_PHASE_READINESS_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

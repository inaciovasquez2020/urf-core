import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_reproducible_flagship_packet_v1_2026_05_30.json"
VERIFY = ROOT / "tools" / "verify_urf_reproducible_flagship_packet_v1.py"
RUNNER = ROOT / "tools" / "run_urf_reproducible_flagship_packet_v1.py"

def load():
    return json.loads(ARTIFACT.read_text())

def test_artifact_shape():
    data = load()
    assert data["object_id"] == "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "EXTERNAL_VALIDATION_LAST_PHASE"

def test_all_internal_objects_bundled():
    data = load()
    required = {
        "URF_STATUS_TAXONOMY_V1",
        "URF_GLOBAL_CLAIM_LEDGER_V1",
        "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
        "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
        "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
    }
    assert set(data["bundled_packets"]) == required
    for packet in data["bundled_packets"].values():
        assert Path(packet).exists()

def test_machine_checked_objects_named():
    data = load()
    machine = {obj["object_id"]: obj["lean_theorem"] for obj in data["machine_checked_objects"]}
    assert machine["FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"] == "finite_local_nonnegative_component_bound"
    assert machine["URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"] == "finite_information_to_claim_governance_bridge"

def test_boundaries_block_external_and_frontier_overclaims():
    data = load()
    forbidden = set(data["forbidden_overclaims"])
    assert "external validation" in forbidden
    assert "peer-review acceptance" in forbidden
    assert "Chronos-RR closure" in forbidden
    assert "P vs NP closure" in forbidden
    assert "Clay-problem closure" in forbidden
    assert "DFM-MKC validation" in forbidden

def test_runner_passes():
    result = subprocess.run(["python3", str(RUNNER)], cwd=ROOT, text=True, capture_output=True, check=True)
    assert "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_RUN_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], cwd=ROOT, text=True, capture_output=True, check=True)
    assert "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

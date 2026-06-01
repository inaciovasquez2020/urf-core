import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_internal_completion_repository_staging_packet_2026_05_31.json"
FINITE = ROOT / "lean" / "URF" / "Foundation" / "FiniteLocalNonnegativeComponentBound.lean"
BRIDGE = ROOT / "lean" / "URF" / "Foundation" / "FiniteInformationToClaimGovernanceBridge.lean"
VERIFY = ROOT / "tools" / "verify_urf_internal_completion_repository_staging_packet.py"

def load():
    return json.loads(ARTIFACT.read_text())

def test_artifact_shape():
    data = load()
    assert data["object_id"] == "URF_INTERNAL_COMPLETION_REPOSITORY_STAGING_PACKET"
    assert data["status"] == "FORMAL_CERTIFICATE_CLOSED"
    assert data["internal_completion_ceiling_before_external_validation"] == "84_PERCENT"
    assert data["external_validation_status"] == "NOT_STARTED"

def test_internal_packets_staged():
    data = load()
    required = set(data["internal_objects_staged"])
    assert "URF_STATUS_TAXONOMY_V1" in required
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in required
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in required
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" in required
    assert "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET" in required
    assert "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1" in required
    assert "EXTERNAL_VALIDATION_LAST_PHASE_READINESS" in required
    for packet in required:
        assert (ROOT / "artifacts" / "urf" / "offrepo_internal_completion_packets" / packet).exists()

def test_lean_files_exist_and_have_no_placeholders():
    finite = FINITE.read_text()
    bridge = BRIDGE.read_text()
    assert "theorem finite_local_nonnegative_component_bound" in finite
    assert "theorem finite_information_to_claim_governance_bridge" in bridge
    assert "finite_local_nonnegative_component_bound_bridge_source" in bridge
    assert "structure FiniteClaimGovernancePackage" in bridge
    lowered = (finite + "\n" + bridge).lower()
    assert "sorry" not in lowered
    assert "admit" not in lowered
    assert "axiom " not in lowered

def test_forbidden_overclaims_recorded():
    data = load()
    forbidden = set(data["forbidden_overclaims"])
    assert "external validation completed" in forbidden
    assert "independent reproduction completed" in forbidden
    assert "expert evaluation completed" in forbidden
    assert "Chronos-RR closure" in forbidden
    assert "P vs NP closure" in forbidden
    assert "Clay-problem closure" in forbidden
    assert "DFM-MKC validation" in forbidden

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], cwd=ROOT, text=True, capture_output=True, check=True)
    assert "URF_INTERNAL_COMPLETION_REPOSITORY_STAGING_PACKET_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

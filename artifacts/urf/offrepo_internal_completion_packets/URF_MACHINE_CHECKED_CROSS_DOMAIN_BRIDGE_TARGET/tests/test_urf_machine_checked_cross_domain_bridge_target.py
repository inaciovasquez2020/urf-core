import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_machine_checked_cross_domain_bridge_target_2026_05_30.json"
LEAN = ROOT / "lean" / "URF" / "Foundation" / "FiniteInformationToClaimGovernanceBridge.lean"
VERIFY = ROOT / "tools" / "verify_urf_machine_checked_cross_domain_bridge_target.py"

def load():
    return json.loads(ARTIFACT.read_text())

def test_artifact_shape():
    data = load()
    assert data["object_id"] == "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["bridge_id"] == "FINITE_INFORMATION_TO_CLAIM_GOVERNANCE_BRIDGE"
    assert data["next_admissible_object"] == "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1"

def test_dependencies_present():
    data = load()
    assert "URF_STATUS_TAXONOMY_V1" in data["depends_on"]
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in data["depends_on"]
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in data["depends_on"]
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" in data["depends_on"]

def test_lean_bridge_present_without_placeholders():
    text = LEAN.read_text()
    assert "structure FiniteClaimGovernancePackage" in text
    assert "theorem finite_information_to_claim_governance_bridge" in text
    assert "finite_local_nonnegative_component_bound" in text
    lowered = text.lower()
    assert "sorry" not in lowered
    assert "admit" not in lowered
    assert "axiom " not in lowered

def test_bridge_crosses_domain_boundary():
    data = load()
    assert data["source_domain"] == "finite information structure"
    assert data["target_domain"] == "claim governance / admissible claim strength"
    reasons = " ".join(data["why_this_is_a_cross_domain_bridge"])
    assert "finite information" in reasons
    assert "claim-governance" in reasons or "claim governance" in reasons

def test_boundaries_block_overclaims():
    data = load()
    forbidden = set(data["forbidden_overclaims"])
    assert "all URF domains unified" in forbidden
    assert "Chronos-RR closure" in forbidden
    assert "P vs NP closure" in forbidden
    assert "Clay-problem closure" in forbidden
    assert "DFM-MKC validation" in forbidden

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

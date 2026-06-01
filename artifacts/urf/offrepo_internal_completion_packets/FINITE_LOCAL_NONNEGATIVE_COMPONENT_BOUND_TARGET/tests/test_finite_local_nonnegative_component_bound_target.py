import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "finite_local_nonnegative_component_bound_target_2026_05_30.json"
LEAN = ROOT / "lean" / "URF" / "Foundation" / "FiniteLocalNonnegativeComponentBound.lean"
VERIFY = ROOT / "tools" / "verify_finite_local_nonnegative_component_bound_target.py"

def load():
    return json.loads(ARTIFACT.read_text())

def test_artifact_shape():
    data = load()
    assert data["object_id"] == "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"

def test_dependencies_present():
    data = load()
    assert "URF_STATUS_TAXONOMY_V1" in data["depends_on"]
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in data["depends_on"]
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in data["depends_on"]

def test_lean_theorem_present_without_placeholders():
    text = LEAN.read_text()
    assert "theorem finite_local_nonnegative_component_bound" in text
    assert "Finset.sum_eq_add_sum_diff_singleton" in text
    assert "le_trans" in text
    lowered = text.lower()
    assert "sorry" not in lowered
    assert "admit" not in lowered
    assert "axiom " not in lowered

def test_boundaries_block_overclaims():
    data = load()
    forbidden = set(data["forbidden_overclaims"])
    assert "global URF Law 3 closure" in forbidden
    assert "Chronos-RR closure" in forbidden
    assert "P vs NP closure" in forbidden
    assert "Clay-problem closure" in forbidden

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / "artifacts" / "urf" / "urf_global_claim_ledger_v1_2026_05_30.json"
VERIFY = ROOT / "tools" / "verify_urf_global_claim_ledger_v1.py"

def load():
    return json.loads(LEDGER.read_text())

def test_ledger_shape():
    data = load()
    assert data["object_id"] == "URF_GLOBAL_CLAIM_LEDGER_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE"

def test_required_claims_present():
    data = load()
    claim_ids = {claim["claim_id"] for claim in data["claims"]}
    assert "URF_STATUS_TAXONOMY_V1" in claim_ids
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in claim_ids
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in claim_ids
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" in claim_ids
    assert "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET" in claim_ids
    assert "EXTERNAL_VALIDATION_DEFERRED" in claim_ids

def test_open_and_blocked_claims_name_missing_objects():
    data = load()
    for claim in data["claims"]:
        if claim["status"] in {"OPEN", "BLOCKED_BY_MISSING_OBJECT"}:
            assert claim["missing_object"], claim["claim_id"]

def test_empirical_claims_do_not_overclaim():
    data = load()
    empirical = [claim for claim in data["claims"] if claim["status"] == "EMPIRICAL_PIPELINE_ONLY"]
    assert empirical
    for claim in empirical:
        forbidden = " ".join(claim["forbidden_interpretation"])
        assert "validated" in forbidden or "confirmed" in forbidden or "proved" in forbidden

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "URF_GLOBAL_CLAIM_LEDGER_V1_OK" in result.stdout

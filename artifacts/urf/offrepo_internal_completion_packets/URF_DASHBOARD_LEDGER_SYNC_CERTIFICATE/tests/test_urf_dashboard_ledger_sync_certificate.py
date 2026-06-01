import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERT = ROOT / "artifacts" / "urf" / "urf_dashboard_ledger_sync_certificate_2026_05_30.json"
DASHBOARD = ROOT / "artifacts" / "urf" / "urf_dashboard_candidate_from_ledger_2026_05_30.json"
VERIFY = ROOT / "tools" / "verify_urf_dashboard_ledger_sync_certificate.py"

def load_cert():
    return json.loads(CERT.read_text())

def load_dashboard():
    return json.loads(DASHBOARD.read_text())

def test_certificate_shape():
    cert = load_cert()
    assert cert["object_id"] == "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE"
    assert cert["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert cert["next_admissible_object"] == "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"
    assert "URF_STATUS_TAXONOMY_V1" in cert["depends_on"]
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in cert["depends_on"]

def test_dashboard_candidate_shape():
    dashboard = load_dashboard()
    assert dashboard["object_id"] == "URF_DASHBOARD_CANDIDATE_FROM_LEDGER"
    assert dashboard["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert len(dashboard["rows"]) >= 10

def test_required_rows_present():
    dashboard = load_dashboard()
    claim_ids = {row["claim_id"] for row in dashboard["rows"]}
    assert "URF_FRAMEWORK_GOAL" in claim_ids
    assert "URF_STATUS_TAXONOMY_V1" in claim_ids
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in claim_ids
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in claim_ids
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" in claim_ids
    assert "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET" in claim_ids
    assert "EXTERNAL_VALIDATION_DEFERRED" in claim_ids

def test_frontier_rows_expose_missing_objects():
    dashboard = load_dashboard()
    frontier_statuses = {"OPEN", "BLOCKED_BY_MISSING_OBJECT", "CONDITIONAL", "EMPIRICAL_PIPELINE_ONLY"}
    for row in dashboard["rows"]:
        if row["taxonomy_status"] in frontier_statuses:
            assert row["missing_object"], row["claim_id"]

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

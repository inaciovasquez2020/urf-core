#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERT = ROOT / "artifacts" / "urf" / "urf_dashboard_ledger_sync_certificate_2026_05_30.json"
DASHBOARD = ROOT / "artifacts" / "urf" / "urf_dashboard_candidate_from_ledger_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE_2026_05_30.md"

FRONTIER_STATUSES_REQUIRING_MISSING_OBJECT = {
    "OPEN",
    "BLOCKED_BY_MISSING_OBJECT",
    "CONDITIONAL",
    "EMPIRICAL_PIPELINE_ONLY",
}

def main() -> None:
    assert CERT.exists(), f"missing certificate: {CERT}"
    assert DASHBOARD.exists(), f"missing dashboard candidate: {DASHBOARD}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"

    cert = json.loads(CERT.read_text())
    dashboard = json.loads(DASHBOARD.read_text())
    status_doc = STATUS.read_text()

    assert cert["object_id"] == "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE"
    assert cert["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert cert["next_admissible_object"] == "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"

    taxonomy_path = Path(cert["source_artifacts"]["taxonomy"])
    ledger_path = Path(cert["source_artifacts"]["ledger"])
    dashboard_path = Path(cert["source_artifacts"]["dashboard_candidate"])

    assert taxonomy_path.exists(), f"missing taxonomy: {taxonomy_path}"
    assert ledger_path.exists(), f"missing ledger: {ledger_path}"
    assert dashboard_path.exists(), f"missing dashboard candidate: {dashboard_path}"
    assert dashboard_path.resolve() == DASHBOARD.resolve()

    taxonomy = json.loads(taxonomy_path.read_text())
    ledger = json.loads(ledger_path.read_text())

    taxonomy_statuses = {entry["status"] for entry in taxonomy["statuses"]}
    ledger_claims = {claim["claim_id"]: claim for claim in ledger["claims"]}
    required_claim_ids = {
        claim["claim_id"]
        for claim in ledger["claims"]
        if claim["dashboard_required"] is True
    }

    rows = dashboard["rows"]
    row_claim_ids = {row["claim_id"] for row in rows}

    assert required_claim_ids == row_claim_ids, {
        "missing": sorted(required_claim_ids - row_claim_ids),
        "extra": sorted(row_claim_ids - required_claim_ids),
    }

    undefined_statuses = []
    overclaim_flags = []
    missing_object_visibility_failures = []

    for row in rows:
        claim_id = row["claim_id"]
        assert claim_id in ledger_claims, claim_id
        claim = ledger_claims[claim_id]

        if row["taxonomy_status"] not in taxonomy_statuses:
            undefined_statuses.append((claim_id, row["taxonomy_status"]))

        assert row["display_status"] == claim["status"], claim_id
        assert row["taxonomy_status"] == claim["status"], claim_id
        assert row["repo"] == claim["repo"], claim_id
        assert row["domain"] == claim["domain"], claim_id
        assert row["claim_statement"] == claim["claim_statement"], claim_id
        assert "last_verified_commit" in row, claim_id

        if claim["status"] in FRONTIER_STATUSES_REQUIRING_MISSING_OBJECT and not row["missing_object"]:
            missing_object_visibility_failures.append(claim_id)

        row_boundary = set(row["boundary"])
        claim_forbidden = set(claim["forbidden_interpretation"])
        if not claim_forbidden <= row_boundary:
            overclaim_flags.append(claim_id)

    assert not undefined_statuses, undefined_statuses
    assert not overclaim_flags, overclaim_flags
    assert not missing_object_visibility_failures, missing_object_visibility_failures

    assert len(rows) >= 10
    assert "no repository files modified" in cert["global_boundary"]
    assert "no repository files modified" in status_doc
    assert "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" in status_doc

    result = {
        "checked_rows": len(rows),
        "ledger_required_claims": len(required_claim_ids),
        "matched_claims": len(row_claim_ids),
        "missing_dashboard_rows": sorted(required_claim_ids - row_claim_ids),
        "undefined_statuses": undefined_statuses,
        "overclaim_flags": overclaim_flags,
        "missing_object_visibility_failures": missing_object_visibility_failures,
        "decision": "PASS",
    }

    print("URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE_OK")
    print(json.dumps(result, indent=2, sort_keys=True))
    print(f"certificate={CERT}")
    print(f"dashboard_candidate={DASHBOARD}")
    print(f"ledger={ledger_path}")
    print(f"taxonomy={taxonomy_path}")

if __name__ == "__main__":
    main()

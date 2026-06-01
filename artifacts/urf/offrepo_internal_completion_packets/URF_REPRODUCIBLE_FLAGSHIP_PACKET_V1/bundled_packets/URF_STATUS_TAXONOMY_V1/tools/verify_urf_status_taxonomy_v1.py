#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_status_taxonomy_v1_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "URF_STATUS_TAXONOMY_V1_2026_05_30.md"

REQUIRED_STATUSES = {
    "THEOREM_CLOSED",
    "FORMAL_CERTIFICATE_CLOSED",
    "CONDITIONAL",
    "INTERFACE_ONLY",
    "SCHEMA_ONLY",
    "EMPIRICAL_PIPELINE_ONLY",
    "EMPIRICALLY_VALIDATED_RESTRICTED",
    "REFUTED",
    "OPEN",
    "BLOCKED_BY_MISSING_OBJECT",
    "DRAFT_OFF_REPO_NO_REPO_WRITE",
}

FORBIDDEN_OUTPUTS = {
    "URF_SOLVED",
    "URF_EXTERNALLY_VALIDATED",
    "CHRONOS_RR_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED",
    "NEW_GRAVITY_VALIDATED",
}

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()

    assert data["object_id"] == "URF_STATUS_TAXONOMY_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert "no repository files modified" in data["global_boundary"]

    statuses = {entry["status"] for entry in data["statuses"]}
    assert REQUIRED_STATUSES <= statuses, sorted(REQUIRED_STATUSES - statuses)

    for entry in data["statuses"]:
        for key in [
            "status",
            "meaning",
            "allowed_claim_strength",
            "required_evidence",
            "forbidden_interpretations",
            "promotion_requires",
        ]:
            assert key in entry, f"missing {key} in {entry.get('status')}"
        assert entry["allowed_claim_strength"], entry["status"]
        assert entry["required_evidence"], entry["status"]
        assert entry["forbidden_interpretations"], entry["status"]
        assert entry["promotion_requires"], entry["status"]

    reserved = data["reserved_terms"]
    for term in ["closed", "validated", "proved", "adopted"]:
        assert term in reserved

    dashboard_rule = data["dashboard_rule"]
    assert dashboard_rule["dashboard_status_must_reference_taxonomy_status"] is True
    assert dashboard_rule["dashboard_rows_must_not_use_freeform_status_labels"] is True
    assert dashboard_rule["dashboard_must_include_last_verified_commit"] is True
    assert dashboard_rule["dashboard_must_include_missing_object_when_status_is_open_or_blocked"] is True

    assert set(data["forbidden_outputs"]) == FORBIDDEN_OUTPUTS
    assert data["next_admissible_object"] == "URF_GLOBAL_CLAIM_LEDGER_V1"

    for forbidden in FORBIDDEN_OUTPUTS:
        assert forbidden not in status_doc

    assert "DRAFT_OFF_REPO_NO_REPO_WRITE" in status_doc
    assert "no repository file modified" in status_doc
    assert "URF_GLOBAL_CLAIM_LEDGER_V1" in status_doc

    print("URF_STATUS_TAXONOMY_V1_OK")
    print(f"artifact={ARTIFACT}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / "artifacts" / "urf" / "urf_global_claim_ledger_v1_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "URF_GLOBAL_CLAIM_LEDGER_V1_2026_05_30.md"

REQUIRED_CLAIMS = {
    "URF_FRAMEWORK_GOAL",
    "URF_STATUS_TAXONOMY_V1",
    "URF_GLOBAL_CLAIM_LEDGER_V1",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
    "URF_CORE_FINITE_MI_CHAIN_RULE_LOCAL_NONNEGATIVITY_ROUTE",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
    "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1",
    "CHRONOS_RR_UNRESTRICTED_CLOSURE",
    "DFM_MKC_EMPIRICAL_VALIDATION",
    "GRAVITY_MASCON_VALIDATION",
    "EXTERNAL_VALIDATION_DEFERRED",
}

FORBIDDEN_PROMOTIONS = [
    "URF_SOLVED",
    "URF_EXTERNALLY_VALIDATED",
    "CHRONOS_RR_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED",
    "NEW_GRAVITY_VALIDATED",
    "LAMBDA_CDM_FAILURE_PROVED",
]

def main() -> None:
    assert LEDGER.exists(), f"missing ledger: {LEDGER}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"

    data = json.loads(LEDGER.read_text())
    status_doc = STATUS.read_text()

    assert data["object_id"] == "URF_GLOBAL_CLAIM_LEDGER_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE"
    assert "URF_STATUS_TAXONOMY_V1" in data["depends_on"]

    taxonomy_path = Path(data["taxonomy_artifact"])
    assert taxonomy_path.exists(), f"missing taxonomy dependency: {taxonomy_path}"
    taxonomy = json.loads(taxonomy_path.read_text())
    taxonomy_statuses = {entry["status"] for entry in taxonomy["statuses"]}

    claims = data["claims"]
    claim_ids = {claim["claim_id"] for claim in claims}
    assert REQUIRED_CLAIMS <= claim_ids, sorted(REQUIRED_CLAIMS - claim_ids)

    schema_keys = set(data["claim_schema"].keys())
    required_keys = {
        "claim_id",
        "repo",
        "domain",
        "status",
        "claim_statement",
        "allowed_interpretation",
        "forbidden_interpretation",
        "primary_artifact",
        "proof_or_verifier",
        "test",
        "missing_object",
        "last_verified_commit",
        "dashboard_required",
    }
    assert required_keys <= schema_keys

    for claim in claims:
        assert set(claim.keys()) == required_keys, claim["claim_id"]
        assert claim["status"] in taxonomy_statuses, (claim["claim_id"], claim["status"])
        assert claim["claim_statement"], claim["claim_id"]
        assert claim["allowed_interpretation"], claim["claim_id"]
        assert claim["forbidden_interpretation"], claim["claim_id"]
        assert isinstance(claim["dashboard_required"], bool), claim["claim_id"]

        if claim["status"] in {"OPEN", "BLOCKED_BY_MISSING_OBJECT", "CONDITIONAL", "EMPIRICAL_PIPELINE_ONLY"}:
            assert claim["missing_object"], claim["claim_id"]

        if claim["status"] in {"THEOREM_CLOSED", "FORMAL_CERTIFICATE_CLOSED", "EMPIRICALLY_VALIDATED_RESTRICTED"}:
            assert claim["proof_or_verifier"] or claim["test"] or claim["primary_artifact"], claim["claim_id"]

        if claim["status"] == "EMPIRICAL_PIPELINE_ONLY":
            forbidden_text = " ".join(claim["forbidden_interpretation"])
            assert "validated" in forbidden_text or "confirmed" in forbidden_text, claim["claim_id"]

    assert any(claim["claim_id"] == "EXTERNAL_VALIDATION_DEFERRED" for claim in claims)
    assert any(claim["claim_id"] == "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET" for claim in claims)
    assert any(claim["claim_id"] == "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET" for claim in claims)

    ledger_text = LEDGER.read_text()
    for forbidden in FORBIDDEN_PROMOTIONS:
        assert forbidden not in ledger_text
        assert forbidden not in status_doc

    assert "no repository files modified" in data["global_boundary"]
    assert "no repository files modified" in status_doc
    assert "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE" in status_doc

    print("URF_GLOBAL_CLAIM_LEDGER_V1_OK")
    print(f"ledger={LEDGER}")
    print(f"taxonomy={taxonomy_path}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

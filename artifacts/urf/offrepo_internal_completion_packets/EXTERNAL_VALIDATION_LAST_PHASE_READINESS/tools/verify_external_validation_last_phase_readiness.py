#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "external_validation_last_phase_readiness_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "EXTERNAL_VALIDATION_LAST_PHASE_READINESS_2026_05_30.md"

REQUIRED_INTERNAL = {
    "URF_STATUS_TAXONOMY_V1",
    "URF_GLOBAL_CLAIM_LEDGER_V1",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
    "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1",
}

REQUIRED_EXTERNAL = {
    "URF_EXTERNAL_REPRODUCTION_RECORD_V1",
    "URF_EXPERT_EVALUATION_PACKET_V1",
    "URF_PUBLIC_REVIEW_OR_CITATION_SIGNAL_V1",
}

FORBIDDEN_PROMOTIONS = [
    "URF_SOLVED",
    "URF_EXTERNALLY_VALIDATED",
    "EXTERNAL_VALIDATION_COMPLETED",
    "INDEPENDENT_REPRODUCTION_COMPLETED",
    "EXPERT_EVALUATION_COMPLETED",
    "CHRONOS_RR_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED",
    "NEW_GRAVITY_VALIDATED",
    "DFM_MKC_VALIDATED",
    "LAMBDA_CDM_FAILURE_PROVED",
]

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()
    artifact_text = ARTIFACT.read_text()

    assert data["object_id"] == "EXTERNAL_VALIDATION_LAST_PHASE_READINESS"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "WAIT_FOR_EXTERNAL_VALIDATION_OR_REPO_WRITE_WINDOW"

    assert set(data["internal_completion_chain"]) == REQUIRED_INTERNAL
    assert set(data["internal_packets"].keys()) == REQUIRED_INTERNAL

    for object_id, packet in data["internal_packets"].items():
        packet_path = Path(packet)
        assert packet_path.exists(), f"missing internal packet for {object_id}: {packet_path}"
        assert (packet_path / "artifacts").exists(), object_id
        assert (packet_path / "docs").exists(), object_id
        assert (packet_path / "tools").exists(), object_id
        assert (packet_path / "tests").exists(), object_id

    assert data["internal_completion_status"]["internal_objects_completed_off_repo"] == 6
    assert data["internal_completion_status"]["internal_completion_ceiling_before_external_validation"] == "84_PERCENT"
    assert data["internal_completion_status"]["internal_done_enough_gate"] == "SATISFIED_OFF_REPO"
    assert data["internal_completion_status"]["repo_write_status"] == "NO_REPO_WRITE"
    assert data["internal_completion_status"]["external_validation_status"] == "NOT_STARTED"

    external_ids = {obj["object_id"] for obj in data["external_objects_remaining"]}
    assert external_ids == REQUIRED_EXTERNAL

    for obj in data["external_objects_remaining"]:
        assert obj["status"] == "BLOCKED_BY_EXTERNAL_ACTOR"
        assert obj["required_evidence"], obj["object_id"]
        assert obj["forbidden_interpretations"], obj["object_id"]

    for forbidden in FORBIDDEN_PROMOTIONS:
        assert forbidden not in artifact_text
        assert forbidden not in status_doc

    assert "no external contact made by this packet" in data["global_boundary"]
    assert "no repository files modified" in data["global_boundary"]
    assert "no external contact made" in status_doc
    assert "no repository files modified" in status_doc

    print("EXTERNAL_VALIDATION_LAST_PHASE_READINESS_OK")
    print(json.dumps({
        "decision": "PASS",
        "internal_objects_completed_off_repo": 6,
        "internal_completion_ceiling_before_external_validation": "84_PERCENT",
        "external_validation_status": "NOT_STARTED",
        "next_admissible_object": data["next_admissible_object"]
    }, indent=2, sort_keys=True))
    print(f"artifact={ARTIFACT}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

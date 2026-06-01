#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_reproducible_flagship_packet_v1_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_2026_05_30.md"
RUNBOOK = ROOT / "RUNBOOK.md"
RUNNER = ROOT / "tools" / "run_urf_reproducible_flagship_packet_v1.py"

REQUIRED_OBJECTS = {
    "URF_STATUS_TAXONOMY_V1",
    "URF_GLOBAL_CLAIM_LEDGER_V1",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
}

FORBIDDEN_PROMOTIONS = [
    "URF_SOLVED",
    "URF_EXTERNALLY_VALIDATED",
    "CHRONOS_RR_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED",
    "NEW_GRAVITY_VALIDATED",
    "LAMBDA_CDM_FAILURE_PROVED",
    "DFM_MKC_VALIDATED",
]

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"
    assert RUNBOOK.exists(), f"missing runbook: {RUNBOOK}"
    assert RUNNER.exists(), f"missing runner: {RUNNER}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()
    runbook = RUNBOOK.read_text()

    assert data["object_id"] == "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["next_admissible_object"] == "EXTERNAL_VALIDATION_LAST_PHASE"

    assert set(data["depends_on"]) == REQUIRED_OBJECTS
    assert set(data["bundled_packets"].keys()) == REQUIRED_OBJECTS
    assert set(data["source_packets"].keys()) == REQUIRED_OBJECTS

    for object_id, packet in data["bundled_packets"].items():
        packet_path = Path(packet)
        assert packet_path.exists(), f"missing bundled packet for {object_id}: {packet_path}"
        assert (packet_path / "artifacts").exists(), object_id
        assert (packet_path / "docs").exists(), object_id
        assert (packet_path / "tools").exists(), object_id
        assert (packet_path / "tests").exists(), object_id

    chain = " ".join(data["flagship_chain"])
    assert "taxonomy" in chain
    assert "ledger" in chain
    assert "dashboard sync" in chain
    assert "finite theorem" in chain
    assert "cross-domain bridge" in chain

    machine = {obj["object_id"]: obj for obj in data["machine_checked_objects"]}
    assert machine["FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"]["lean_theorem"] == "finite_local_nonnegative_component_bound"
    assert machine["URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"]["lean_theorem"] == "finite_information_to_claim_governance_bridge"

    artifact_text = ARTIFACT.read_text()
    for forbidden in FORBIDDEN_PROMOTIONS:
        assert forbidden not in artifact_text
        assert forbidden not in status_doc
        assert forbidden not in runbook

    assert "no repository files modified" in data["global_boundary"]
    assert "no repository files modified" in status_doc
    assert "No repository files are modified." in runbook

    result = subprocess.run(["python3", str(RUNNER)], cwd=ROOT, text=True, capture_output=True)
    if result.returncode != 0:
        raise AssertionError(
            "runner failed\nSTDOUT:\n"
            + result.stdout
            + "\nSTDERR:\n"
            + result.stderr
        )

    assert "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_RUN_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout

    print("URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_OK")
    print(json.dumps({
        "decision": "PASS",
        "bundled_objects": sorted(REQUIRED_OBJECTS),
        "runner": "PASS",
        "status": data["status"],
        "next_admissible_object": data["next_admissible_object"]
    }, indent=2, sort_keys=True))
    print(f"artifact={ARTIFACT}")
    print(f"runbook={RUNBOOK}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_reproducible_flagship_packet_v1_2026_05_30.json"

EXPECTED = {
    "URF_STATUS_TAXONOMY_V1": "URF_STATUS_TAXONOMY_V1_OK",
    "URF_GLOBAL_CLAIM_LEDGER_V1": "URF_GLOBAL_CLAIM_LEDGER_V1_OK",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE": "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE_OK",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET": "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET_OK",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET": "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET_OK",
}

VERIFY_PATHS = {
    "URF_STATUS_TAXONOMY_V1": "tools/verify_urf_status_taxonomy_v1.py",
    "URF_GLOBAL_CLAIM_LEDGER_V1": "tools/verify_urf_global_claim_ledger_v1.py",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE": "tools/verify_urf_dashboard_ledger_sync_certificate.py",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET": "tools/verify_finite_local_nonnegative_component_bound_target.py",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET": "tools/verify_urf_machine_checked_cross_domain_bridge_target.py",
}

TEST_PATHS = {
    "URF_STATUS_TAXONOMY_V1": "tests/test_urf_status_taxonomy_v1.py",
    "URF_GLOBAL_CLAIM_LEDGER_V1": "tests/test_urf_global_claim_ledger_v1.py",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE": "tests/test_urf_dashboard_ledger_sync_certificate.py",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET": "tests/test_finite_local_nonnegative_component_bound_target.py",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET": "tests/test_urf_machine_checked_cross_domain_bridge_target.py",
}

def run(cmd, cwd):
    result = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True)
    if result.returncode != 0:
        raise SystemExit(
            "Command failed: "
            + " ".join(cmd)
            + "\nCWD: "
            + str(cwd)
            + "\nSTDOUT:\n"
            + result.stdout
            + "\nSTDERR:\n"
            + result.stderr
        )
    return result.stdout

def main():
    data = json.loads(ARTIFACT.read_text())
    bundled = data["bundled_packets"]

    results = []

    for object_id, expected in EXPECTED.items():
        packet = Path(bundled[object_id])
        verifier = packet / VERIFY_PATHS[object_id]
        test = packet / TEST_PATHS[object_id]

        assert packet.exists(), f"missing packet: {packet}"
        assert verifier.exists(), f"missing verifier: {verifier}"
        assert test.exists(), f"missing test: {test}"

        verify_stdout = run(["python3", str(verifier)], cwd=packet)
        assert expected in verify_stdout, object_id

        pytest_stdout = run(["python3", "-m", "pytest", "-q", str(test)], cwd=packet)
        assert "passed" in pytest_stdout, object_id

        results.append({
            "object_id": object_id,
            "verifier": str(verifier),
            "test": str(test),
            "expected_message": expected,
            "decision": "PASS"
        })

    print("URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1_RUN_OK")
    print(json.dumps({
        "decision": "PASS",
        "checked_objects": len(results),
        "results": results
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()

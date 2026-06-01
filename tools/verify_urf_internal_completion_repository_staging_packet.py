import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ARTIFACT = ROOT / "artifacts" / "urf" / "urf_internal_completion_repository_staging_packet_2026_05_31.json"
STATUS = ROOT / "docs" / "status" / "URF_INTERNAL_COMPLETION_REPOSITORY_STAGING_PACKET_2026_05_31.md"
URF_ROOT = ROOT / "lean" / "URF.lean"

FINITE = ROOT / "lean" / "URF" / "Foundation" / "FiniteLocalNonnegativeComponentBound.lean"
BRIDGE = ROOT / "lean" / "URF" / "Foundation" / "FiniteInformationToClaimGovernanceBridge.lean"

REQUIRED_PACKETS = {
    "URF_STATUS_TAXONOMY_V1",
    "URF_GLOBAL_CLAIM_LEDGER_V1",
    "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
    "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
    "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET",
    "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1",
    "EXTERNAL_VALIDATION_LAST_PHASE_READINESS",
}

FORBIDDEN_TOKENS = ["sorry", "admit", "axiom ", "unsafe"]

FORBIDDEN_PROMOTIONS = [
    "URF_SOLVED",
    "URF_EXTERNALLY_VALIDATED",
    "CHRONOS_RR_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED",
    "NEW_GRAVITY_VALIDATED",
    "DFM_MKC_VALIDATED",
    "LAMBDA_CDM_FAILURE_PROVED"
]

def check_no_forbidden_tokens(path: Path) -> None:
    text = path.read_text().lower()
    for token in FORBIDDEN_TOKENS:
        assert token not in text, f"{path} contains forbidden token {token!r}"

def run(cmd):
    result = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
    if result.returncode == 0:
        return result.stdout
    raise AssertionError(
        "command failed: "
        + " ".join(cmd)
        + "\nSTDOUT:\n"
        + result.stdout
        + "\nSTDERR:\n"
        + result.stderr
    )

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"
    assert URF_ROOT.exists(), f"missing root import file: {URF_ROOT}"
    assert FINITE.exists(), f"missing finite Lean file: {FINITE}"
    assert BRIDGE.exists(), f"missing bridge Lean file: {BRIDGE}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()
    urf_root_text = URF_ROOT.read_text()

    assert data["object_id"] == "URF_INTERNAL_COMPLETION_REPOSITORY_STAGING_PACKET"
    assert data["status"] == "FORMAL_CERTIFICATE_CLOSED"
    assert data["internal_completion_ceiling_before_external_validation"] == "84_PERCENT"
    assert data["external_validation_status"] == "NOT_STARTED"
    assert set(data["internal_objects_staged"]) == REQUIRED_PACKETS

    for packet in REQUIRED_PACKETS:
        path = ROOT / "artifacts" / "urf" / "offrepo_internal_completion_packets" / packet
        assert path.exists(), f"missing staged packet: {path}"
        assert (path / "artifacts").exists(), packet
        assert (path / "docs").exists(), packet
        assert (path / "tools").exists(), packet
        assert (path / "tests").exists(), packet

    assert "import URF.Foundation.FiniteLocalNonnegativeComponentBound" in urf_root_text
    assert "import URF.Foundation.FiniteInformationToClaimGovernanceBridge" in urf_root_text

    finite_text = FINITE.read_text()
    bridge_text = BRIDGE.read_text()

    assert "theorem finite_local_nonnegative_component_bound" in finite_text
    assert "theorem finite_information_to_claim_governance_bridge" in bridge_text
    assert "structure FiniteClaimGovernancePackage" in bridge_text
    assert "finite_local_nonnegative_component_bound_bridge_source" in bridge_text

    check_no_forbidden_tokens(FINITE)
    check_no_forbidden_tokens(BRIDGE)

    artifact_text = ARTIFACT.read_text()
    for forbidden in FORBIDDEN_PROMOTIONS:
        assert forbidden not in artifact_text
        assert forbidden not in status_doc
        assert forbidden not in finite_text
        assert forbidden not in bridge_text

    run(["lake", "env", "lean", "lean/URF/Foundation/FiniteLocalNonnegativeComponentBound.lean"])
    run(["lake", "env", "lean", "lean/URF/Foundation/FiniteInformationToClaimGovernanceBridge.lean"])

    print("URF_INTERNAL_COMPLETION_REPOSITORY_STAGING_PACKET_OK")
    print(json.dumps({
        "decision": "PASS",
        "internal_objects_staged": sorted(REQUIRED_PACKETS),
        "lean_modules_checked": [
            "URF.Foundation.FiniteLocalNonnegativeComponentBound",
            "URF.Foundation.FiniteInformationToClaimGovernanceBridge"
        ],
        "internal_completion_ceiling_before_external_validation": "84_PERCENT",
        "external_validation_status": "NOT_STARTED",
        "next_admissible_object": data["next_admissible_object"]
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()

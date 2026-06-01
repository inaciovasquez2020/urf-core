#!/usr/bin/env python3
import json
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "urf_machine_checked_cross_domain_bridge_target_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET_2026_05_30.md"
LEAN = ROOT / "lean" / "URF" / "Foundation" / "FiniteInformationToClaimGovernanceBridge.lean"

FORBIDDEN_TOKENS = [
    "sorry",
    "admit",
    "axiom ",
    "unsafe",
]

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

def run_lean_if_available(lean_file: Path) -> str:
    urf_core = Path.home() / "urf-core"
    if not (urf_core / "lakefile.lean").exists() and not (urf_core / "lakefile.toml").exists():
        return "SKIPPED_NO_URF_CORE_LAKE_PROJECT"
    if shutil.which("lake") is None:
        return "SKIPPED_NO_LAKE_BINARY"
    result = subprocess.run(
        ["lake", "env", "lean", str(lean_file)],
        cwd=urf_core,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise AssertionError(
            "Lean check failed\nSTDOUT:\n"
            + result.stdout
            + "\nSTDERR:\n"
            + result.stderr
        )
    return "PASS"

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert STATUS.exists(), f"missing status doc: {STATUS}"
    assert LEAN.exists(), f"missing Lean bridge target: {LEAN}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()
    lean_text = LEAN.read_text()

    assert data["object_id"] == "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["bridge_id"] == "FINITE_INFORMATION_TO_CLAIM_GOVERNANCE_BRIDGE"
    assert data["source_domain"] == "finite information structure"
    assert data["target_domain"] == "claim governance / admissible claim strength"
    assert data["machine_checked_target"] == "finite_information_to_claim_governance_bridge"
    assert data["bridge_package"] == "FiniteClaimGovernancePackage"
    assert data["uses_theorem_surface"] == "finite_local_nonnegative_component_bound"
    assert data["next_admissible_object"] == "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1"

    for dep in [
        "URF_STATUS_TAXONOMY_V1",
        "URF_GLOBAL_CLAIM_LEDGER_V1",
        "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
        "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET",
    ]:
        assert dep in data["depends_on"]
        dep_path = Path(data["dependency_packets"][dep])
        assert dep_path.exists(), f"missing dependency packet: {dep_path}"

    for source_path in data["source_files"].values():
        assert Path(source_path).exists(), f"missing source file: {source_path}"

    assert "structure FiniteClaimGovernancePackage" in lean_text
    assert "theorem finite_information_to_claim_governance_bridge" in lean_text
    assert "finite_local_nonnegative_component_bound" in lean_text
    assert "localStrength" in lean_text
    assert "capacityBound" in lean_text
    assert "total_le_capacity" in lean_text
    assert "local_nonnegative" in lean_text

    lowered = lean_text.lower()
    for token in FORBIDDEN_TOKENS:
        assert token not in lowered, f"forbidden Lean token: {token}"

    for forbidden in FORBIDDEN_PROMOTIONS:
        assert forbidden not in ARTIFACT.read_text()
        assert forbidden not in status_doc
        assert forbidden not in lean_text

    assert "no repository files modified" in data["global_boundary"]
    assert "no repository files modified" in status_doc
    assert "not merged into `urf-core`" in status_doc
    assert "URF_REPRODUCIBLE_FLAGSHIP_PACKET_V1" in status_doc

    lean_check = run_lean_if_available(LEAN)

    result = {
        "decision": "PASS",
        "lean_check": lean_check,
        "bridge": data["machine_checked_target"],
        "status": data["status"],
        "next_admissible_object": data["next_admissible_object"],
    }

    print("URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET_OK")
    print(json.dumps(result, indent=2, sort_keys=True))
    print(f"artifact={ARTIFACT}")
    print(f"lean={LEAN}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

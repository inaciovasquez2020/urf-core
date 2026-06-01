#!/usr/bin/env python3
import json
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts" / "urf" / "finite_local_nonnegative_component_bound_target_2026_05_30.json"
STATUS = ROOT / "docs" / "status" / "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET_2026_05_30.md"
LEAN = ROOT / "lean" / "URF" / "Foundation" / "FiniteLocalNonnegativeComponentBound.lean"

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
    assert LEAN.exists(), f"missing Lean target: {LEAN}"

    data = json.loads(ARTIFACT.read_text())
    status_doc = STATUS.read_text()
    lean_text = LEAN.read_text()

    assert data["object_id"] == "FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET"
    assert data["status"] == "DRAFT_OFF_REPO_NO_REPO_WRITE"
    assert data["selected_route"] == "finite chain-rule / local nonnegativity"
    assert data["lean_theorem_name"] == "finite_local_nonnegative_component_bound"
    assert data["next_admissible_object"] == "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET"

    for dep in [
        "URF_STATUS_TAXONOMY_V1",
        "URF_GLOBAL_CLAIM_LEDGER_V1",
        "URF_DASHBOARD_LEDGER_SYNC_CERTIFICATE",
    ]:
        assert dep in data["depends_on"]
        dep_path = Path(data["dependency_packets"][dep])
        assert dep_path.exists(), f"missing dependency packet: {dep_path}"

    for source_path in data["source_files"].values():
        assert Path(source_path).exists(), f"missing source file: {source_path}"

    assert "theorem finite_local_nonnegative_component_bound" in lean_text
    assert "Finset.sum_eq_add_sum_diff_singleton" in lean_text
    assert "le_trans" in lean_text
    assert "h_nonneg" in lean_text
    assert "h_bound" in lean_text

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
    assert "URF_MACHINE_CHECKED_CROSS_DOMAIN_BRIDGE_TARGET" in status_doc

    lean_check = run_lean_if_available(LEAN)

    result = {
        "decision": "PASS",
        "lean_check": lean_check,
        "theorem": data["lean_theorem_name"],
        "status": data["status"],
        "next_admissible_object": data["next_admissible_object"],
    }

    print("FINITE_LOCAL_NONNEGATIVE_COMPONENT_BOUND_TARGET_OK")
    print(json.dumps(result, indent=2, sort_keys=True))
    print(f"artifact={ARTIFACT}")
    print(f"lean={LEAN}")
    print(f"status_doc={STATUS}")

if __name__ == "__main__":
    main()

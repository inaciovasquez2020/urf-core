#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/global_valid_kernel_theorem_2026_05_31.json"
DOC = ROOT / "docs/status/GLOBAL_VALID_KERNEL_THEOREM_2026_05_31.md"
LEAN = ROOT / "lean/URF/Foundation/GlobalValidKernelTheorem.lean"
ROOT_IMPORT = ROOT / "lean/URF.lean"

REQUIRED_EXCLUSIONS = {
    "NOT_GLOBAL_URF_LAW3",
    "NOT_INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
    "NOT_UNCONDITIONAL_GLOBAL_KERNEL_THEOREM",
    "NOT_UNCONDITIONAL_CHANNEL_CAPACITY_THEOREM",
    "NOT_CHRONOS_RR",
    "NOT_H4_1_FGL",
    "NOT_P_VS_NP",
    "NOT_CLAY",
}

REQUIRED_MISSING = {
    "GLOBAL_URF_LAW3",
    "INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
}

def main() -> None:
    assert ARTIFACT.exists(), f"missing artifact: {ARTIFACT}"
    assert DOC.exists(), f"missing status doc: {DOC}"
    assert LEAN.exists(), f"missing Lean file: {LEAN}"
    assert ROOT_IMPORT.exists(), f"missing root import file: {ROOT_IMPORT}"

    artifact = json.loads(ARTIFACT.read_text())
    lean = LEAN.read_text()
    doc = DOC.read_text()
    root_import = ROOT_IMPORT.read_text()

    assert artifact["id"] == "GLOBAL_VALID_KERNEL_THEOREM_2026_05_31"
    assert artifact["status"] == "GLOBAL_VALID_KERNEL_THEOREM_CLOSED_CONDITIONAL_ON_KERNEL_CAPACITY_SOUNDNESS_NO_GLOBAL_LAW3"
    assert artifact["object"] == "GlobalValidKernelTheorem"
    assert artifact["next_admissible_object"] == "GLOBAL_URF_LAW3"
    assert REQUIRED_EXCLUSIONS.issubset(set(artifact["excluded_claims"]))
    assert REQUIRED_MISSING.issubset(set(artifact["minimal_missing_objects"]))
    assert {"validKernel", "kernel_valid", "kernel_capacity_soundness"}.issubset(set(artifact["conditional_inputs"]))

    for token in [
        "import URF.Foundation.ChannelCapacityBoundDerivation",
        "structure GlobalValidKernelTheorem",
        "channelDerivation : ChannelCapacityBoundDerivation",
        "validKernel : Prop",
        "kernel_valid : validKernel",
        "kernel_capacity_soundness",
        "theorem global_valid_kernel_theorem",
        "K.channelDerivation.finiteChain.totalMI",
        "K.channelDerivation.channelCapacity",
        "rw [K.channelDerivation.finiteChain.finite_chain_rule]",
        "exact K.kernel_capacity_soundness K.kernel_valid",
        "theorem global_valid_kernel_theorem_local_nonneg",
        "GLOBAL_URF_LAW3",
    ]:
        assert token in lean, f"missing Lean token: {token}"

    assert "import URF.Foundation.GlobalValidKernelTheorem" in root_import

    for token in [
        "Status: `GLOBAL_VALID_KERNEL_THEOREM_CLOSED_CONDITIONAL_ON_KERNEL_CAPACITY_SOUNDNESS_NO_GLOBAL_LAW3`",
        "ValidKernel -> finiteLocalSum(T, localCMIValue) ≤ channelCapacity",
        "global URF Law 3",
        "GLOBAL_URF_LAW3",
        "INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
    ]:
        assert token in doc, f"missing doc token: {token}"

    print("GLOBAL_VALID_KERNEL_THEOREM_OK")

if __name__ == "__main__":
    main()

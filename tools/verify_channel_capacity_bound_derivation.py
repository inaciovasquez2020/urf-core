#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/channel_capacity_bound_derivation_2026_05_30.json"
DOC = ROOT / "docs/status/CHANNEL_CAPACITY_BOUND_DERIVATION_2026_05_30.md"
LEAN = ROOT / "lean/URF/Foundation/ChannelCapacityBoundDerivation.lean"
ROOT_IMPORT = ROOT / "lean/URF.lean"

REQUIRED_EXCLUSIONS = {
    "NOT_GLOBAL_VALID_KERNEL_THEOREM",
    "NOT_GLOBAL_URF_LAW3",
    "NOT_INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
    "NOT_UNCONDITIONAL_CHANNEL_CAPACITY_THEOREM",
    "NOT_CHRONOS_RR",
    "NOT_H4_1_FGL",
    "NOT_P_VS_NP",
    "NOT_CLAY",
}

REQUIRED_MISSING = {
    "GLOBAL_VALID_KERNEL_THEOREM",
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

    assert artifact["id"] == "CHANNEL_CAPACITY_BOUND_DERIVATION_2026_05_30"
    assert artifact["status"] == "CHANNEL_CAPACITY_BOUND_DERIVATION_CLOSED_CONDITIONAL_ON_FINITE_CAPACITY_BOUND_NO_GLOBAL_KERNEL"
    assert artifact["object"] == "ChannelCapacityBoundDerivation"
    assert artifact["next_admissible_object"] == "GLOBAL_VALID_KERNEL_THEOREM"

    assert REQUIRED_EXCLUSIONS.issubset(set(artifact["excluded_claims"]))
    assert REQUIRED_MISSING.issubset(set(artifact["minimal_missing_objects"]))
    assert "finite_capacity_bound" in artifact["conditional_inputs"]

    for token in [
        "structure FiniteMutualInformationChainRuleProof",
        "structure ChannelCapacityBoundDerivation",
        "finiteChain : FiniteMutualInformationChainRuleProof",
        "channelCapacity : ℝ",
        "finite_capacity_bound",
        "finiteChain.finiteLocalSum finiteChain.T finiteChain.localCMIValue ≤ channelCapacity",
        "theorem channel_capacity_bound_derivation",
        "K.finiteChain.totalMI ≤ K.channelCapacity",
        "rw [K.finiteChain.finite_chain_rule]",
        "exact K.finite_capacity_bound",
        "theorem channel_capacity_bound_derivation_local_nonneg",
        "GLOBAL_VALID_KERNEL_THEOREM",
    ]:
        assert token in lean, f"missing Lean token: {token}"

    assert "import URF.Foundation.ChannelCapacityBoundDerivation" in root_import

    for token in [
        "Status: `CHANNEL_CAPACITY_BOUND_DERIVATION_CLOSED_CONDITIONAL_ON_FINITE_CAPACITY_BOUND_NO_GLOBAL_KERNEL`",
        "totalMI ≤ channelCapacity",
        "global valid kernel theorem",
        "GLOBAL_VALID_KERNEL_THEOREM",
        "INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
    ]:
        assert token in doc, f"missing doc token: {token}"

    print("CHANNEL_CAPACITY_BOUND_DERIVATION_OK")

if __name__ == "__main__":
    main()

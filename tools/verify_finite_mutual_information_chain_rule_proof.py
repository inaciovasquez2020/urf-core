#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/finite_mutual_information_chain_rule_proof_2026_05_30.json"
DOC = ROOT / "docs/status/FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_2026_05_30.md"
LEAN = ROOT / "lean/URF/Foundation/FiniteMutualInformationChainRuleProof.lean"
ROOT_IMPORT = ROOT / "lean/URF.lean"

REQUIRED_EXCLUSIONS = {
    "NOT_CHANNEL_CAPACITY_BOUND_DERIVATION",
    "NOT_GLOBAL_VALID_KERNEL_THEOREM",
    "NOT_GLOBAL_URF_LAW3",
    "NOT_INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
    "NOT_CHRONOS_RR",
    "NOT_H4_1_FGL",
    "NOT_P_VS_NP",
    "NOT_CLAY",
}

REQUIRED_MISSING = {
    "CHANNEL_CAPACITY_BOUND_DERIVATION",
    "GLOBAL_VALID_KERNEL_THEOREM",
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

    assert artifact["id"] == "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_2026_05_30"
    assert artifact["status"] == "FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL"
    assert artifact["object"] == "FiniteMutualInformationChainRuleProof"
    assert artifact["next_admissible_object"] == "CHANNEL_CAPACITY_BOUND_DERIVATION"

    assert REQUIRED_EXCLUSIONS.issubset(set(artifact["excluded_claims"]))
    assert REQUIRED_MISSING.issubset(set(artifact["minimal_missing_objects"]))

    for token in [
        "structure FiniteMutualInformationChainRuleProof",
        "finiteLocalSum : Nat → (Nat → ℝ) → ℝ",
        "totalMI : ℝ",
        "localCMIValue : Nat → ℝ",
        "cmi_nonneg : ∀ t : Nat, 0 ≤ localCMIValue t",
        "finite_chain_rule",
        "totalMI = finiteLocalSum T localCMIValue",
        "theorem finite_mutual_information_chain_rule_proof",
        "theorem finite_mutual_information_chain_rule_local_nonneg",
        "FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL",
        "CHANNEL_CAPACITY_BOUND_DERIVATION",
    ]:
        assert token in lean, f"missing Lean token: {token}"

    assert "import URF.Foundation.FiniteMutualInformationChainRuleProof" in root_import

    for token in [
        "Status: `FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL`",
        "I_total = finiteLocalSum(T, CMI)",
        "channel-capacity bound derivation",
        "CHANNEL_CAPACITY_BOUND_DERIVATION",
        "GLOBAL_VALID_KERNEL_THEOREM",
    ]:
        assert token in doc, f"missing doc token: {token}"

    print("FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_OK")

if __name__ == "__main__":
    main()

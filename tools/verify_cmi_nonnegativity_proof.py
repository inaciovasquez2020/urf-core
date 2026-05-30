#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/cmi_nonnegativity_proof_2026_05_30.json"
DOC = ROOT / "docs/status/CMI_NONNEGATIVITY_PROOF_2026_05_30.md"
LEAN = ROOT / "lean/URF/Foundation/CMINonnegativityProof.lean"
ROOT_IMPORT = ROOT / "lean/URF.lean"

REQUIRED_EXCLUSIONS = {
    "NOT_FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF",
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
    "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF",
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

    assert artifact["id"] == "CMI_NONNEGATIVITY_PROOF_2026_05_30"
    assert artifact["status"] == "CMI_NONNEGATIVITY_INTERFACE_ONLY_NO_CHAIN_RULE_OR_CAPACITY_BOUND"
    assert artifact["object"] == "CMINonnegativityProof"
    assert artifact["next_admissible_object"] == "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF"

    assert REQUIRED_EXCLUSIONS.issubset(set(artifact["excluded_claims"]))
    assert REQUIRED_MISSING.issubset(set(artifact["minimal_missing_objects"]))

    for token in [
        "structure CMINonnegativityProof",
        "ConditionalMutualInformationValue",
        "RandomVariable → RandomVariable → RandomVariable → ℝ",
        "cmi_nonneg",
        "theorem cmi_nonnegativity_proof",
        "0 ≤ K.localCMIValue X Y Z",
        "CMI_NONNEGATIVITY_INTERFACE_ONLY_NO_CHAIN_RULE_OR_CAPACITY_BOUND",
        "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF",
    ]:
        assert token in lean, f"missing Lean token: {token}"

    assert "import URF.Foundation.CMINonnegativityProof" in root_import

    for token in [
        "Status: `CMI_NONNEGATIVITY_INTERFACE_ONLY_NO_CHAIN_RULE_OR_CAPACITY_BOUND`",
        "CMI(X ; Y | Z) ≥ 0",
        "finite mutual-information chain rule",
        "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF",
        "CHANNEL_CAPACITY_BOUND_DERIVATION",
        "GLOBAL_VALID_KERNEL_THEOREM",
    ]:
        assert token in doc, f"missing doc token: {token}"

    print("CMI_NONNEGATIVITY_PROOF_OK")

if __name__ == "__main__":
    main()

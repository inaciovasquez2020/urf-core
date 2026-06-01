#!/usr/bin/env python3
import json
from pathlib import Path

ART = Path("artifacts/urf/global_urf_law3_restricted_valid_kernel_instance_2026_06_01.json")
DOC = Path("docs/status/GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_2026_06_01.md")

REQUIRED_INPUTS = {
    "restricted_valid_kernel_domain",
    "valid_kernel_assumption_binding",
    "finite_local_cmi_nonnegativity_binding",
    "finite_chain_rule_binding",
    "capacity_bound_binding",
    "restricted_law3_consequence_statement",
    "lean_checked_instance_or_explicit_missing_lemma",
}

REQUIRED_NON_CLAIMS = {
    "no unrestricted global URF Law 3",
    "no unconditional valid-kernel theorem",
    "no information-theoretic derivation from probability measures",
    "no unconditional channel-capacity theorem",
    "no Chronos-RR closure",
    "no H4.1/FGL closure",
    "no P vs NP claim",
    "no Clay-problem claim",
}

FORBIDDEN_CLAIMS = [
    "GLOBAL_URF_LAW3_CLOSED",
    "UNRESTRICTED_GLOBAL_URF_LAW3",
    "UNCONDITIONAL_VALID_KERNEL_THEOREM",
    "PROBABILITY_MEASURE_DERIVATION_CLOSED",
    "UNCONDITIONAL_CHANNEL_CAPACITY_THEOREM",
    "CHRONOS_RR_CLOSED",
    "H4FGL_CLOSED",
    "P_VS_NP_CLOSED",
    "CLAY_CLOSED"
]

def main() -> None:
    assert ART.exists(), f"missing artifact: {ART}"
    assert DOC.exists(), f"missing doc: {DOC}"

    data = json.loads(ART.read_text())
    doc = DOC.read_text()
    joined = json.dumps(data, sort_keys=True) + "\n" + doc

    assert data["artifact"] == "GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_2026_06_01"
    assert data["object"] == "GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE"
    assert data["status"] == "TARGET_OPEN_RESTRICTED_VALID_KERNEL_INSTANCE_NOT_SUPPLIED"
    assert data["decision"] == "PASS"

    assert data["restricted_valid_kernel_instance_supplied"] is False
    assert data["global_urf_law3_closed"] is False
    assert data["unconditional_theorem_claimed"] is False

    assert REQUIRED_INPUTS.issubset(set(data["required_inputs"]))
    assert REQUIRED_INPUTS.issubset(set(data["missing_inputs"]))
    assert REQUIRED_NON_CLAIMS.issubset(set(data["certified_non_claims"]))

    for item in REQUIRED_INPUTS:
        assert item in doc

    for item in REQUIRED_NON_CLAIMS:
        assert item in doc

    for claim in FORBIDDEN_CLAIMS:
        assert claim not in joined, f"forbidden claim present: {claim}"

    assert data["next_admissible_object"] == "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA"
    assert data["weakest_sufficient_next_input"] == "LeanCheckedRestrictedValidKernelLaw3Instance"

    print("GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_OK")
    print(json.dumps({
        "artifact": str(ART),
        "decision": data["decision"],
        "status": data["status"],
        "missing_input_count": len(data["missing_inputs"]),
        "non_claim_count": len(data["certified_non_claims"]),
        "next_admissible_object": data["next_admissible_object"],
        "weakest_sufficient_next_input": data["weakest_sufficient_next_input"]
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()

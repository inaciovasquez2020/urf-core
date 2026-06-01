#!/usr/bin/env python3
import json
from pathlib import Path

ART = Path("artifacts/urf/restricted_valid_kernel_law3_instance_or_explicit_missing_lemma_2026_06_01.json")
DOC = Path("docs/status/RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA_2026_06_01.md")
PRIOR = Path("artifacts/urf/global_urf_law3_restricted_valid_kernel_instance_2026_06_01.json")

REQUIRED_BINDINGS = {
    "restricted_valid_kernel_domain",
    "valid_kernel_assumption_binding",
    "finite_local_cmi_nonnegativity_binding",
    "finite_chain_rule_binding",
    "capacity_bound_binding",
    "restricted_law3_consequence_statement",
}

REQUIRED_NON_CLAIMS = {
    "no Lean-checked restricted valid-kernel Law 3 instance supplied",
    "no restricted valid-kernel Law 3 closure",
    "no unrestricted global URF Law 3",
    "no unconditional valid-kernel theorem",
    "no information-theoretic derivation from probability measures",
    "no unconditional channel-capacity theorem",
    "no Chronos-RR closure",
    "no H4.1/FGL closure",
    "no P vs NP claim",
    "no Clay-problem claim",
}

FORBIDDEN_POSITIVE_CLAIMS = [
    "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_SUPPLIED_TRUE",
    "RESTRICTED_VALID_KERNEL_LAW3_CLOSED_TRUE",
    "GLOBAL_URF_LAW3_CLOSED_TRUE",
    "UNCONDITIONAL_VALID_KERNEL_THEOREM_CLOSED_TRUE",
    "CHRONOS_RR_CLOSED_TRUE",
    "H4FGL_CLOSED_TRUE",
    "P_VS_NP_CLOSED_TRUE",
    "CLAY_CLOSED_TRUE"
]

def main() -> None:
    assert ART.exists(), f"missing artifact: {ART}"
    assert DOC.exists(), f"missing doc: {DOC}"
    assert PRIOR.exists(), f"missing prior artifact: {PRIOR}"

    data = json.loads(ART.read_text())
    prior = json.loads(PRIOR.read_text())
    doc = DOC.read_text()
    joined = json.dumps(data, sort_keys=True) + "\n" + doc

    assert data["artifact"] == "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA_2026_06_01"
    assert data["object"] == "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA"
    assert data["status"] == "EXPLICIT_MISSING_LEMMA_RECORDED_NO_LEAN_INSTANCE_SUPPLIED"
    assert data["decision"] == "PASS"

    assert prior["object"] == "GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE"
    assert prior["status"] == "TARGET_OPEN_RESTRICTED_VALID_KERNEL_INSTANCE_NOT_SUPPLIED"

    assert data["lean_checked_restricted_instance_supplied"] is False
    assert data["restricted_valid_kernel_law3_closed"] is False
    assert data["explicit_missing_lemma_supplied"] is True

    lemma = data["missing_lemma"]
    assert lemma["name"] == "RestrictedValidKernelDomainBindingAndLaw3Consequence"
    assert REQUIRED_BINDINGS.issubset(set(lemma["required_bindings"]))
    assert REQUIRED_NON_CLAIMS.issubset(set(data["certified_non_claims"]))

    for token in REQUIRED_BINDINGS:
        assert token in doc

    for token in REQUIRED_NON_CLAIMS:
        assert token in doc

    for claim in FORBIDDEN_POSITIVE_CLAIMS:
        assert claim not in joined, f"forbidden positive claim present: {claim}"

    assert data["next_admissible_object"] == "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE"

    print("RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA_OK")
    print(json.dumps({
        "artifact": str(ART),
        "decision": data["decision"],
        "status": data["status"],
        "missing_lemma": lemma["name"],
        "required_binding_count": len(lemma["required_bindings"]),
        "non_claim_count": len(data["certified_non_claims"]),
        "next_admissible_object": data["next_admissible_object"]
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()

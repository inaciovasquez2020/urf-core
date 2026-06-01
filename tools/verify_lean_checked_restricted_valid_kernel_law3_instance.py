#!/usr/bin/env python3
import json
import re
from pathlib import Path

ART = Path("artifacts/urf/lean_checked_restricted_valid_kernel_law3_instance_2026_06_01.json")
DOC = Path("docs/status/LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_2026_06_01.md")
LEAN = Path("lean/URF/Foundation/RestrictedValidKernelLaw3Instance.lean")
ROOT = Path("lean/URF.lean")
PRIOR = Path("artifacts/urf/restricted_valid_kernel_law3_instance_or_explicit_missing_lemma_2026_06_01.json")

REQUIRED_BINDINGS = {
    "restricted_valid_kernel_domain",
    "valid_kernel_assumption_binding",
    "finite_local_cmi_nonnegativity_binding",
    "finite_chain_rule_binding",
    "capacity_bound_binding",
    "restricted_law3_consequence_statement",
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

FORBIDDEN_LEAN_TOKENS = [
    "sorry",
    "admit",
    "axiom ",
    "constant "
]

FORBIDDEN_POSITIVE_CLAIMS = [
    "GLOBAL_URF_LAW3_CLOSED_TRUE",
    "UNCONDITIONAL_VALID_KERNEL_THEOREM_CLOSED_TRUE",
    "UNRESTRICTED_CHRONOS_RR_CLOSED_TRUE",
    "H4FGL_CLOSED_TRUE",
    "P_VS_NP_CLOSED_TRUE",
    "CLAY_CLOSED_TRUE"
]

def main() -> None:
    assert ART.exists(), f"missing artifact: {ART}"
    assert DOC.exists(), f"missing doc: {DOC}"
    assert LEAN.exists(), f"missing Lean file: {LEAN}"
    assert ROOT.exists(), f"missing root import file: {ROOT}"
    assert PRIOR.exists(), f"missing prior artifact: {PRIOR}"

    data = json.loads(ART.read_text())
    prior = json.loads(PRIOR.read_text())
    doc = DOC.read_text()
    lean = LEAN.read_text()
    root = ROOT.read_text()
    joined = json.dumps(data, sort_keys=True) + "\n" + doc

    assert data["artifact"] == "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_2026_06_01"
    assert data["object"] == "LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE"
    assert data["status"] == "LEAN_CHECKED_CONDITIONAL_INSTANCE_SUPPLIED_BINDINGS_REMAIN_HYPOTHESES"
    assert data["decision"] == "PASS"

    assert prior["object"] == "RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA"
    assert prior["status"] == "EXPLICIT_MISSING_LEMMA_RECORDED_NO_LEAN_INSTANCE_SUPPLIED"

    assert data["lean_checked_restricted_instance_supplied"] is True
    assert data["restricted_valid_kernel_law3_closed"] == "conditional_on_six_bindings"

    assert data["lean_module"] == "URF.Foundation.RestrictedValidKernelLaw3Instance"
    assert data["lean_file"] == str(LEAN)
    assert data["structure"] == "RestrictedValidKernelLaw3Input"
    assert data["theorem"] == "lean_checked_restricted_valid_kernel_law3_instance"

    assert REQUIRED_BINDINGS.issubset(set(data["required_bindings"]))
    assert REQUIRED_NON_CLAIMS.issubset(set(data["certified_non_claims"]))

    assert "import URF.Foundation.RestrictedValidKernelLaw3Instance" in root
    assert "lean/URF.lean" in str(ROOT)
    assert "structure RestrictedValidKernelLaw3Input" in lean
    assert "theorem lean_checked_restricted_valid_kernel_law3_instance" in lean
    assert "law3ConsequenceFromBindings" in lean

    assert "import URF.Foundation.GlobalValidKernelTheorem" in lean
    assert "import URF.Foundation.ChannelCapacityBoundDerivation" in lean
    assert "import URF.Foundation.FiniteMutualInformationChainRuleProof" in lean

    stripped = re.sub(r"/-.*?-/", "", lean, flags=re.DOTALL)
    stripped = re.sub(r"--.*", "", stripped)
    for token in FORBIDDEN_LEAN_TOKENS:
        assert token not in stripped, f"forbidden Lean token present: {token}"

    for token in REQUIRED_BINDINGS:
        assert token in doc

    for token in REQUIRED_NON_CLAIMS:
        assert token in doc

    for claim in FORBIDDEN_POSITIVE_CLAIMS:
        assert claim not in joined, f"forbidden positive claim present: {claim}"

    assert data["next_admissible_object"] == "DIAMETER_SEPARATION_FILLING_OBSTRUCTION_PROOF_TARGET"

    print("LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OK")
    print(json.dumps({
        "artifact": str(ART),
        "decision": data["decision"],
        "status": data["status"],
        "lean_file": str(LEAN),
        "theorem": data["theorem"],
        "required_binding_count": len(data["required_bindings"]),
        "non_claim_count": len(data["certified_non_claims"]),
        "next_admissible_object": data["next_admissible_object"]
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()

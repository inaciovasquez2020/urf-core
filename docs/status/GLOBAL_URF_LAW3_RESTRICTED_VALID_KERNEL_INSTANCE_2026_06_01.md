# Global URF Law 3 Restricted Valid-Kernel Instance Target — 2026-06-01

## Status

`TARGET_OPEN_RESTRICTED_VALID_KERNEL_INSTANCE_NOT_SUPPLIED`

## Object

`GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE`

## Decision

`PASS`

This packet records the theorem-strengthening target for a restricted valid-kernel instance of Global URF Law 3.

It does not close Global URF Law 3.

## Required Inputs

1. `restricted_valid_kernel_domain`
2. `valid_kernel_assumption_binding`
3. `finite_local_cmi_nonnegativity_binding`
4. `finite_chain_rule_binding`
5. `capacity_bound_binding`
6. `restricted_law3_consequence_statement`
7. `lean_checked_instance_or_explicit_missing_lemma`

## Missing Inputs

All seven required inputs remain missing in this target packet.

## Certified Non-Claims

This packet records:

- no unrestricted global URF Law 3;
- no unconditional valid-kernel theorem;
- no information-theoretic derivation from probability measures;
- no unconditional channel-capacity theorem;
- no Chronos-RR closure;
- no H4.1/FGL closure;
- no P vs NP claim;
- no Clay-problem claim.

## Next Admissible Object

`RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA`

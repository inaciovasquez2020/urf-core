# Restricted Valid-Kernel Law 3 Instance or Explicit Missing Lemma — 2026-06-01

## Status

`EXPLICIT_MISSING_LEMMA_RECORDED_NO_LEAN_INSTANCE_SUPPLIED`

## Object

`RESTRICTED_VALID_KERNEL_LAW3_INSTANCE_OR_EXPLICIT_MISSING_LEMMA`

## Decision

`PASS`

This packet supplies the explicit missing lemma for the target opened by `GLOBAL_URF_LAW3_RESTRICTED_VALID_KERNEL_INSTANCE_2026_06_01`.

It does not supply the Lean-checked restricted valid-kernel Law 3 instance.

## Explicit Missing Lemma

`RestrictedValidKernelDomainBindingAndLaw3Consequence`

## Weakest Form

Given a restricted valid-kernel domain, a binding from that domain to the existing global valid-kernel theorem hypotheses, finite local CMI nonnegativity, finite chain-rule binding, and capacity-bound binding, derive the restricted Law 3 consequence as a Lean-checked instance.

## Required Bindings

1. `restricted_valid_kernel_domain`
2. `valid_kernel_assumption_binding`
3. `finite_local_cmi_nonnegativity_binding`
4. `finite_chain_rule_binding`
5. `capacity_bound_binding`
6. `restricted_law3_consequence_statement`

## Certified Non-Claims

This packet records:

- no Lean-checked restricted valid-kernel Law 3 instance supplied;
- no restricted valid-kernel Law 3 closure;
- no unrestricted global URF Law 3;
- no unconditional valid-kernel theorem;
- no information-theoretic derivation from probability measures;
- no unconditional channel-capacity theorem;
- no Chronos-RR closure;
- no H4.1/FGL closure;
- no P vs NP claim;
- no Clay-problem claim.

## Next Admissible Object

`LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE`

# Lean-Checked Restricted Valid-Kernel Law 3 Instance — 2026-06-01

## Status

`LEAN_CHECKED_CONDITIONAL_INSTANCE_SUPPLIED_BINDINGS_REMAIN_HYPOTHESES`

## Object

`LEAN_CHECKED_RESTRICTED_VALID_KERNEL_LAW3_INSTANCE`

## Decision

`PASS`

This packet supplies a Lean-checked restricted valid-kernel Law 3 conditional instance.

The instance closes only the conditional consequence from the six required bindings.

## Lean Module

`URF.Foundation.RestrictedValidKernelLaw3Instance`

## Lean File

`lean/URF/Foundation/RestrictedValidKernelLaw3Instance.lean`

## Structure

`RestrictedValidKernelLaw3Input`

## Theorem

`lean_checked_restricted_valid_kernel_law3_instance`

## Required Bindings

1. `restricted_valid_kernel_domain`
2. `valid_kernel_assumption_binding`
3. `finite_local_cmi_nonnegativity_binding`
4. `finite_chain_rule_binding`
5. `capacity_bound_binding`
6. `restricted_law3_consequence_statement`

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

`DIAMETER_SEPARATION_FILLING_OBSTRUCTION_PROOF_TARGET`

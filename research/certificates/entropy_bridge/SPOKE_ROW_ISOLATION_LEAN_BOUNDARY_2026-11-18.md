# Spoke-only Lean candidate audit — precise next proof obligation

Date: 2026-11-18
Source: `research/candidates/URFCoreSpokeRowIsolationCandidate.lean`
Branch: `research/entropy-uniform-radius-audit-20261118`
Base verified checkpoint: `a06477e82e96e90c316611c6bf71073e70297d62`

## What changed

The candidate includes the original complete source (unchanged text) plus:

* `matrix_zero_of_isolating_rows_candidate`: abstract field-valued
  matrix kernel argument; full tactic proof supplied, **NOT_RUN**.
* `SpokeIsolationTarget`: *Prop only*, the remaining graph-specific
  unique-row separation statement; **OPEN**.
* `SpokeOnlyZeroTarget`: *Prop only*, final desired spoke-only
  circulation lemma; **OPEN**.

There is no `sorry`, `admit`, `axiom`, `opaque`,
`native_decide`, or asserted proof of the OPEN propositions.

## Decisive missing lemma

For a fixed vertex `v`, any edge `e` with nonzero coefficient
`z e` and incident to `v` has another endpoint `u ≠ v`.
At row `u` of the actual incidence matrix:

* `A u e = ±1 ≠ 0`;
* any edge `d ≠ e` with nonzero `z d` is also incident to `v`;
* if it also contributed to row `u`, it would have the same
  unordered endpoints `{u,v}` as `e`, hence equal `e` by the
  simple-graph `OrderedEdge` representation, contradiction.

Thus `A u d * z d = 0` for `d ≠ e`.
This supplies exactly the `hisolate` premise of the matrix lemma,
with no additional graph assumptions.

## Formalization acceptance

1. Compile the candidate with the actual repository Lean toolchain.
2. Stop at the first error, if any; do not change the verified base.
3. Prove `SpokeIsolationTarget` from `OrderedEdge` uniqueness
   rather than assuming it.
4. Apply the matrix theorem and link the explicit matrix sum to
   `simpleGraphBoundary`.
5. Axiom audit: only `propext`, `Classical.choice`, `Quot.sound`;
   compare exact declarations and check nonvacuity.

**STATUS: REMOTE RESEARCH CANDIDATE SAVED; LEAN BUILD NOT_RUN.
GLOBAL URF RIGIDITY OPEN. MERGE NOT PERFORMED.**

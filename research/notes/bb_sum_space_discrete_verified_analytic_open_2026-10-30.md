# Bourgain–Brezis sum-space test: discrete verification boundary

Date: 2026-10-30
Status: **DISCRETE_VERIFIED / ANALYTIC_LOWER_BOUND_OPEN**
Scope: independent URF test of an external paper; not a verification or refutation of that paper.

## Verified repository components

At commit `3ed085642ebb7f2ccd3fc702e944208aa204a86e`, GitHub Actions reported success for the Lean build and associated checks.

- `lean/URF/Analysis/ScalePathTelescoping.lean`: finite telescoping identity `sum_succ_sub_eq_sub`.
- Same module: block-increment norm bound `norm_sub_le_sum_succ_sub_norm`.
- Same module: nonnegative sliding-block overlap bound `sliding_block_sum_le`.
- `lean/URF/Analysis/ScalePathLowerBound.lean`: scalar implication `scalePath_lower_bound` **conditional on** the aggregate hypothesis.
- `lean/URF/Analysis/SumSpaceGradientBridge.lean`: abstract ambient and gradient-constrained decomposition interface; no Sobolev or Fourier specialization.

The discrete lemmas imply, for a normed additive group and finite natural-number ranges,

```
sum_{j < N} ‖m(j+L) - m(j)‖
  ≤ L * sum_{i < N+L} ‖m(i+1) - m(i)‖.
```

This displayed combined inequality is a mathematical consequence of the verified components, but is **not recorded here as a separately compiled Lean declaration**.

## Unresolved analytic bridge

To invoke `scalePath_lower_bound`, one must independently establish, in the precise paper-specific model,

```
δ * sqrt(K*L) ≤ L*A + 2*sqrt(K)*B.
```

The paper-specific block lower bound, tracking-error estimate, index/parameter identification, Fourier/lacunary estimates, and Sobolev interpretation are **not established** by the discrete formalization.

The illustrative sufficient premise

```
δ * sqrt(K*L) ≤ sum_{j < N} ‖m(j+L)-m(j)‖ + 2*sqrt(K)*B
```

has **not** been derived from the paper. It must not be treated as an assumption proved by URF.

## Claim governance

- **Verified:** Lean-compiling abstract/discrete lemmas, under their exact types and hypotheses.
- **Open:** paper-specific analytic lower bound and interpretation.
- **Not claimed:** independent proof, validation, refutation, novelty, or a mathematical error in the external paper.
- **Next action:** retrieve the exact proposition, construction, parameter ranges, and proof from the primary paper; map each required inequality to explicit hypotheses before any further promotion.
- **Stop rule:** no further formalization or author outreach absent a concrete source-level mathematical finding.

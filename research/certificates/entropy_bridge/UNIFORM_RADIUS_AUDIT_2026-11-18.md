# URF-Core entropy bridge — verification and obstruction checkpoint (2026-11-18)

## Scope and provenance

Base commit: `a06477e82e96e90c316611c6bf71073e70297d62`.
Development branch: `research/entropy-uniform-radius-audit-20261118`.
Source: `research/certificates/entropy_bridge/URFCoreConcreteGraphStage.lean`.
Lean toolchain on user's Mac: `leanprover/lean4:v4.27.0`.
Pinned mathlib: `a3a10db0e9d66acbebf76c5e6a135066525ac900`.

This checkpoint archives *only verified results and clearly labeled outstanding obligations*. It does not assert a global rigidity theorem or a complete conditional entropy equality.

## A. Assembled concrete graph entropy inequality — LEAN_VERIFIED (Mac output)

The user ran an isolated appended Lean theorem named
`URF.EntropyBridge.concreteGraph_entropy_bound_candidate`, applying
`graphObservation_entropy_le_log_kernel` to
`concreteGraphChain (K := K) G cutoff`.

Compiler result: success. Exact axiom report:
`[propext, Classical.choice, Quot.sound]`.

Result: for a finite-field graph-chain presentation and any finite input law `p`,
the observation-weighted conditional entropy is bounded by the logarithm of the
observation kernel's cardinality. This bound uses *bounded edge support*, not
radius-locality. This additional theorem was compiler-verified in an isolated
temporary append, not separately integrated as an importable module.

## B. Uniform finite entropy — LEAN_VERIFIED (Mac output)

The new archival file `URFCoreUniformEntropyVerified.lean` preserves the exact
verified proof in a self-contained copy of the base source.

Theorem: `URF.EntropyBridge.finiteEntropy_uniform_eq_log_card`.

For a nonempty finite type `A`,
`finiteEntropy (fun _ : A => (1 : ℝ) / Fintype.card A) = Real.log (Fintype.card A)`.

Compiler result: success. Exact axiom report:
`[propext, Classical.choice, Quot.sound]`.

The archived copy is newly committed remotely; its post-commit build and axiom
audit have **not** been rerun at the new exact GitHub branch HEAD. The user's
reported Mac verification covered the same source-plus-theorem construction.

## C. Uniform conditional entropy — MATHEMATICALLY DERIVED, LEAN_OPEN

For a uniformly distributed input to a linear map `f : Q →ₗ[K] W`
between finite vector spaces over a finite field, all nonempty fibers are
affine translates of `ker f` and have equal cardinality. Their conditional
laws are uniform, so mathematically:

`H(X | f(X)) = Real.log (Fintype.card (LinearMap.ker f))`.

The following intermediate equalities were constructed as local proof steps in
failed compilations: fiber mass equality, normalization, uniform restricted
distribution, and fiber/kernel cardinality. **The final theorem did not compile.**
Compiler diagnostics showed an unresolved elaboration metavariable in the
final `calc` chain and included `sorryAx`. Do not promote it as verified.

The local proof candidate should be repaired by eliminating the problematic
final elaboration and checking the complete *fiber theorem* before averaging.
No failed proof candidate is committed here as a purported theorem.

## D. Exact finite computational tests — COMPUTATION_PASS

`check_uniform_fibers_and_radius.py` (Python standard library only) checks
all 682 binary linear maps `F2^n → F2^m` for `1 ≤ n,m ≤ 3`, represented by
all possible binary `m×n` matrices. Every nonempty output fiber has the same
cardinality as the kernel. Independent execution in this research session:
`BINARY_LINEAR_MAPS := 682`, assertions passed.

Prior Mac verification also checked 126 binary coordinate projection cases,
`1 ≤ n ≤ 6`. These are finite checks, not an unrestricted Lean proof.

## E. Radius-local vs bounded-edge-support — GENERAL EQUIVALENCE REFUTED

Graph: the cycle `C6` over `F2`.

* Global cycle space dimension: 1.
* Edge-support cutoff 6: all global cycles allowed; dimension 1.
* Radius-one vertex balls, with cycle chains supported inside induced balls:
  each induced ball is a three-vertex path, with cycle-space dimension zero.
  Their span is zero.

Therefore the two subspaces differ. The finite exact test checks all 64
binary edge chains and all six radius-one balls. Independently reproduced:
`COUNTEREXAMPLE := COMPUTATION_PASS`.

A useful replacement requires a *new explicit radius-local cycle-space
definition* and a theorem establishing the additional geometric conditions
under which the two spans coincide. The obstruction is universal: no
unconditional equivalence theorem can be correct.

## Status

* Concrete graph entropy upper bound: **LEAN_VERIFIED**, user Mac isolated build.
* Finite uniform entropy: **LEAN_VERIFIED**, user Mac isolated build.
* Uniform conditional entropy equality: **OPEN** in Lean.
* General radius/local support equivalence: **REFUTED**.
* New remote branch combined-build validation: **NOT_RUN**.
* Global URF rigidity: **OPEN**.
* Local Mac untracked `urf-cli/.venv/` and `urf-cli/dist/`: not accessed or modified.
* No merge into the default branch.

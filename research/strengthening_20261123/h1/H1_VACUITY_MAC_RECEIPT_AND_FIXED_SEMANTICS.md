# H1 locality specification — zero-axiom isolated verification and correction boundary

Date of observed Mac execution: 2026-11-24.
Scope: exact source-declaration witness audit of `lean/URF/H1Locality.lean`, not full URF Lean build.

## Source and environment provenance

User-provided Mac terminal output (not independently rerun by this note's author):

- Repository: `~/Desktop/GITHUB/urf-core-clean`.
- HEAD: `b02b6a965930ddb22e3cbfe6c733f727baf925f0`, branch `main`, short git status empty at the time of the check.
- H1 Git blob: `393b679a5d76daf755d0be683d4b10fa4332f6a2`.
- Repository toolchain: `leanprover/lean4:v4.27.0`.
- Actual compiler: Lean 4.27.0, arm64-apple-darwin24.6.0, commit `db93fe1608548721853390a10cd40580fe7d22ae`.
- The first compilation attempted `import URF.H1Locality` and stopped at line 1 because `.lake/build/lib/lean/URF/H1Locality.olean` did not exist. That is a dependency-loading error, **not** a failed theorem.
- The successful fallback confirmed the exact H1 blob, extracted four unmodified declaration bodies from that repository source, and compiled the two witness proofs with `import Init` using the pinned Lean executable directly (no missing .olean).

Exact successful terminal excerpt:

```text
EXACT_SOURCE_DECLARATIONS := 4
SOURCE_EXTRACTION := PASS
SOURCE_BLOB := 393b679a5d76daf755d0be683d4b10fa4332f6a2
Lean (version 4.27.0, arm64-apple-darwin24.6.0, commit db93fe1608548721853390a10cd40580fe7d22ae, Release)
'URF.H1Audit.h1_trivial' does not depend on any axioms
'URF.H1Audit.nominal_gate_trivial' does not depend on any axioms
ISOLATED_LEAN := PASS
H1_VACUITY := LEAN_VERIFIED_ISOLATED
NOMINAL_GATE_VACUITY := LEAN_VERIFIED_ISOLATED
AXIOM_AUDIT := PASS
SOURCE_MODIFICATIONS := NONE
COMMIT_PUSH_MERGE := NONE
```

The original local log was reported at
`/var/folders/g7/t7cdygm521zfn6t572ncddgw0000gn/T/urf-h1-isolated.XXXXXX.VXXBK71wRZ/lean.log`;
this ephemeral Mac path is a provenance hint, **not** a durable, uploaded log.
The corresponding read-only reproduction script is `verify_h1_vacuity_isolated_mac.sh` in this directory. **Its committed file bytes have not been rerun on the Mac**; the evidence above is for the earlier chat-supplied equivalent verification command. Rerun the repository script before assigning it a separate script-execution PASS.

## Exact formal counter-witness

The four verbatim repository declaration bodies used in the isolated compile are:

- `FOkAdmissibleRefinementInterface`
- `H1Locality`
- `ConcreteRepositoryNativeFOkWitnessComponents`
- `ConcreteRepositoryNativeFOkWitnessComponentsValueOpenProblem`

Choose

```lean
I := { k := 1, k_pos := by decide,
       RefinementProcedure := Unit,
       FOkAdmissible := fun _ => True }
```

and use the unique `Unit` inhabitant, `all_admissible := fun _ => True.intro`, semantic binding type `Unit`, and semantic content `True`. Then:

- `URF.H1Audit.h1_trivial : URF.H1Locality`.
- `URF.H1Audit.nominal_gate_trivial : URF.ConcreteRepositoryNativeFOkWitnessComponentsValueOpenProblem`.

Both compiled with **no axioms**. This proves that the *existing formal specifications* do not enforce any fixed, repository-native FOᵏ meaning. It does **not** refute locality of any particular refinement algorithm.

## Fixed-semantics replacement obligation (OPEN)

Do **not** replace one user-chosen interface with another existentially user-chosen predicate. Instead fix, independently of the sought proof:

1. A graph/model class `C` with explicitly defined vocabulary and encoding.
2. A concrete repository-native refinement family `R_repo` (with a specified actual procedure and semantics `Run(R,G,tuple)`). The semantics and inclusion of the actual algorithm must not be chosen by the proof witness.
3. The standard FOᵏ syntax, satisfaction relation, allowed parameters, and scope (e.g. uncolored graphs versus marked roots). Fix uniformity and variable reuse across all sizes.
4. One finite bound `k` valid across the designated algorithm family, with **a formula chosen before graphs**, not a formula chosen separately for every input graph.

A possible target, *once these objects are fixed*, is

```text
FixedH1(k) :=
  forall R in R_repo,
  exists phi_R in FO^k,
  forall G in C, forall tuples a,
    Run(R,G,a) <-> Sat(G,phi_R,a)
```

where `k` is a single positive integer independent of `R`, `G`, and size; one may seek `exists k >= 1, FixedH1(k)` if the intended claim merely requires an unspecified finite uniform bound. A family of refinement procedures is **not** the singleton `Unit` unless the actual repository code warrants it. A finite-variable formula must use standard fixed semantics, not `fun _ => True`.

**Decisive obstruction for k = 1 in the pure, uncolored, loopless graph signature:** FO¹ can only inspect equality `x=x` and diagonal adjacency `E(x,x)`. Complete `K₄` and empty four-vertex graphs have the same FO¹ truth values at every vertex but differ in the property “some edge exists”. The separate `fo1/URF_FO1_FixedSemanticCounterexample.lean` has an isolated Mac Lean receipt for `not_FO1Defines_hasEdge` (permitted `propext`). Thus any fixed-representation task whose required outputs distinguish this pair cannot be implemented in FO¹ under that signature. This does **not** exclude FO², higher FOᵏ, colored/parameterized formulas, or different semantics.

## Status and integration

- `H1_EXISTENTIAL_INTERFACE_VACUITY := LEAN_VERIFIED_ISOLATED`, zero axioms.
- `H1_NOMINAL_GATE_VACUITY := LEAN_VERIFIED_ISOLATED`, zero axioms.
- `H1_FIXED_SEMANTICS_SPECIFICATION := OPEN`.
- `H1_ACTUAL_REFINEMENT_FO_K_PROOF := OPEN`.
- `PRODUCTION_LEAN_COMPILATION := NOT_RUN` for these two new isolated declarations.
- `INDEPENDENT_MATHEMATICAL_REVIEW := OPEN`.
- No production Lean imports or declarations should be changed on the strength of these witness proofs alone. Draft PR #599 is not authorized for merge by this research receipt.

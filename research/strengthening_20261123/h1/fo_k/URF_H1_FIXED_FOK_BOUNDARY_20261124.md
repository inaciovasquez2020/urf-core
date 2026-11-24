# URF Core H1: fixed-semantics audit and a classical FO^k obstruction

Date: 2026-11-24. Status: **PROVED (paper)** for the logical separation; **COMPUTATION_PASS** for two bounded independent checks; **LEAN := NOT_RUN** for this new k-variable theorem. No source or repository mutation in this verification phase.

## Verified starting point

The earlier Mac check, on `urf-core-clean` at HEAD `b02b6a965930ddb22e3cbfe6c733f727baf925f0`, used Lean 4.27.0 and exact H1 source blob `393b679a5d76daf755d0be683d4b10fa4332f6a2`. It verified isolated theorems `URF.H1Audit.h1_trivial` and `URF.H1Audit.nominal_gate_trivial` with **zero axioms**. This establishes a definitional vacuity in the *formal interface*, not a counterexample to genuine FO^k locality.

The remote PR #599 head last inspected before this note was `3efc023f71b9587483c4a2114f907ec4f2a073bf` (research-only; draft). This phase has not modified that head.

## Classical theorem, and precise scope

Let `FO^k` be ordinary first-order logic over finite **uncolored, loopless, undirected graphs** in the relational signature `{E, =}`, using at most `k >= 1` *distinct variable names*, with unbounded quantifier depth but no counting quantifiers, auxiliary order, constants, numeric relations or extra vertex colors.

**Theorem.** For every `k >= 1`, the complete graphs `K_k` and `K_{k+1}` satisfy the same `FO^k` sentences:

    K_k ≡_{FO^k} K_{k+1}.

Indeed, they are equivalent even for infinitary logic with `k` variables, by the same infinite-round pebble-game argument.

**Proof.** Play the ordinary `k`-pebble back-and-forth game. Duplicator maintains the equivalence relation on occupied pebble labels: the vertices corresponding to labels `i` and `j` are equal in the first graph iff they are equal in the second. On a complete loopless graph, adjacency of occupied vertices is exactly their inequality, so this invariant is a partial isomorphism. After Spoiler lifts one pebble, at most `k-1` distinct vertices remain pebbled. If Spoiler places the lifted pebble on a currently occupied vertex, Duplicator chooses the corresponding vertex. If Spoiler chooses a vertex not currently occupied, Duplicator chooses a vertex not currently occupied in the other graph; this is always possible in both `K_k` and `K_{k+1}` because both have at least `k` vertices. The invariant persists forever. By the `k`-pebble characterization of `FO^k`, no `FO^k` sentence distinguishes the graphs. QED.

**Sharpness:** for `k>=2`, `K_{k-1}` and `K_k` *are* distinguished by the `FO^k` sentence asserting at least `k` distinct vertices; the same is true for `k=1` if comparison with an empty graph is allowed. The general separation is classical, not a novelty claim.

**Cycle-space consequence:** for a connected simple graph, `dim_F2 Z_1(G) = |E| - |V| + 1`. Therefore

    dim Z_1(K_n) = (n-1)(n-2)/2
    dim Z_1(K_{k+1}) - dim Z_1(K_k) = k-1.

For every `k>=2` the two FO^k-equivalent graphs have *different* cycle-space dimensions. For `k=1`, both cycle dimensions are zero; vertex count and edge count still differ. Hence an ordinary fixed `FO^k` sentence cannot decide every rank threshold or exactly recover the full cycle-rank invariant on all complete graphs with unrestricted graph sizes. **This is a definability obstruction to pure FO^k, not to bounded-variable logics with counting or to arbitrary iterative algorithms.**

## Critical limitations for URF

1. These witnesses have maximum degrees `k-1` and `k`, respectively. They do **not** uniformly furnish counterexamples inside a fixed maximum-degree `Δ` class when `k > Δ`.
2. Counting quantifiers immediately distinguish the vertex cardinalities; **FO^k != C^k**, and a Weisfeiler-Leman refinement correspondence ordinarily uses counting logic. The URF documentation's informal `FO^k / WL^k` shorthand cannot be treated as a semantic equivalence.
3. If graphs carry an auxiliary linear order, size metadata, identifier labels, or a nonlocal representation, this particular indistinguishability argument no longer applies directly.
4. Uniformly bounded `k` is not itself a bound on the *number of iterations*, *total queries*, *global transcript capacity*, or the information an iterative algorithm may accumulate over time. Those need independent accounting and semantics.
5. The theorem rules out expressing a separating numerical graph invariant with one fixed pure `FO^k` sentence in the specified signature. It does not rule out all algorithms whose **individual** updates use `k` variables.
6. There is no new Lean compilation for the general `k` theorem; its correctness follows from the paper proof and classical literature, not from bounded finite tests.

## Reproducible exact finite tests (assistant Linux)

Run using stdlib Python 3 and no downloads:

    PYTHONDONTWRITEBYTECODE=1 python3 -B verify_complete_graph_fo_k.py --max-k 6 --seconds 30 --max-states 20000
    PYTHONDONTWRITEBYTECODE=1 python3 -B verify_fo_k_direct_crosscheck.py

First method: symmetry-reduced equality-pattern greatest fixed point; `k=1..6` completed, checking all `2, 5, 15, 52, 203, 877` canonical partial equality patterns and the sharp negative controls for `k>=2`. Second independent implementation: unsymmetrized raw-vertex pair-game greatest fixed point, `k=1..3`, which checked winning-state counts `3, 31, 661`, and negative controls for `k=2,3`. Neither algorithm substitutes for an unrestricted mathematical proof.

SHA-256 files from this exact container execution:

- `verify_complete_graph_fo_k.py`: `9e67062309815605a1791585232046f27e1b4e4377c16668990f18a61924e9fc`
- `fo_k_replay_receipt_20261124.txt`: `7b817ef6cef20d8171f7bd12a655bfd9c38bea43d210c600a7a789a5ffe11274`
- `verify_fo_k_direct_crosscheck.py`: `58fadba7156225471c66fdaac3c0373531685b6a12ffd3026ae0ef22ad1f64c2`
- `fo_k_direct_crosscheck_receipt_20261124.txt`: `ba53c9caaa30f88fe6a3e5c88fc2d711cf82eedd9ee665e7c3aaab358870cc5c`

Resource-limit exhaustion must be **INCOMPLETE**, never PASS. Mac reproduction has not been performed for these two new scripts.

## H1 source trace and weakest missing object

Inspected repository surfaces: `lean/URF/H1Locality.lean`, `lean/URF/DescentSystem.lean`, `docs/referee/REFEREE_MAP.md`, `docs/normalization/{Axiom-B,Bstarstar-AC0,TRAP}.md`, `docs/foundations/nst.md`, `papers/fo-k-locality/fo-k-locality.tex`.

- `H1Locality.lean` exposes an existentially chosen interface with freely chosen `FOkAdmissible`, proved vacuous in isolation.
- `DescentSystem.lean` contains an abstract `step` field and a `ToyConcreteDescentSystem` marked as a sanity check, **not** the intended scientific refinement operator.
- `TRAP.md` explicitly treats global polynomial-time-to-bounded-logical-refinement normalization as a *frozen axiom*, not a theorem. `Axiom-B.md` is a candidate. Its restricted AC0 statements must not silently justify full FO^k normalization.
- The repository's `fo-k-locality.tex` has a conditional configuration-pumping program, not a provided complete code-bound uniform FO^k semantics.

**Exact OPEN blocker:** supply one designated, actual repository-native refinement transformation, over a fully specified graph/model representation and fixed vocabulary, plus an operational input-output interpretation. Then define a *separate*, standard `FO^k` semantics and prove an extensional equivalence between the actual operator's output and a chosen formula (or else produce a counterexample). No field that chooses the operator or its admissibility predicate may be introduced as a proof witness. Determine whether the intended semantics is pure `FO^k`, counting `C^k`, or `WL^k` **before** proposing a uniform bound.

## Independent literature / priority audit

The complete-graph pebble-game separation appears explicitly in Phokion G. Kolaitis and Moshe Y. Vardi, **“Fixpoint Logic vs. Infinitary Logic in Finite-Model Theory”**, available from Rice University at https://www.cs.rice.edu/~vardi/papers/lics92rj.pdf, printed p. 15, in the paragraph preceding Proposition 3.4. Therefore the general separation is **KNOWN**, not novel. This note's value is a repository-specific logical boundary and independently reproducible checks; it makes no novelty claim.

## Promotion gate

**NOT_RUN**: new Lean code on Mac, because none is asserted here. **NOT_PERFORMED**: repository edit, commit, push, merge. Prior draft PR #599 remains subject to existing review gates. Authoritative Mac `HEAD` and dirty state beyond the earlier receipts have not been reinspected. Request approval before adding these research-only artifacts to the PR.
# URF finite-obstruction descent: sharp safety invariant

Date: 2026-11-24. Scope: `inaciovasquez2020/urf-core`, `lean/URF/DescentSystem.lean` Git blob `be8a64f877be7aaf0153e6b6779fd738bf34fb21` (verified at GitHub `main` `b0f3aa7b0a64d9c9d72235d7e84f08ad8347a87f`). `URF.finiteObstructionDescentStep` is the target. **PROVED (paper); COMPUTATION_PASS (bounded); new Lean theorem NOT_RUN.**

## Exact result

For a finite tag set `S`, registered rank `r : Nat`, and any `FiniteObstructionSelector` whose output lies in every nonempty input set, a step maps `(S,r)` to `(S \ {chosen},r-1)` when `S` is nonempty (Nat subtraction is truncated), or `(∅,r-1)` when empty. Write `S_t`, `r_t` for the `t`-fold iteration.

**Theorem (exact cardinality evolution):** For every `t : Nat` and every admissible selector,

    |S_t| = |S_0| - t,   r_t = r_0 - t,

where `-` is truncated subtraction in `Nat`. Proof by induction on `t`: if the set is nonempty, the selected member is present and erasure lowers cardinality exactly one; otherwise the cardinality stays zero. The rank always subtracts one. Neither statement depends on how the selector chooses a member.

**Sharp terminal-to-empty criterion:** At the first rank-zero time `t = r_0`, the data set is empty **if and only if** `|S_0| ≤ r_0`. In fact, the following two conditions are equivalent:

- `|S_0| ≤ r_0`;
- for every `t`, `r_t = 0` implies `S_t = ∅`.

The forward implication follows from monotonicity of truncated subtraction: `|S_t| ≤ r_t`. For the reverse, take `t = r_0` and use the exact formulas. The same statement holds for **every** valid selector, not merely a chosen min/max policy.

Thus `RankDominates(C) := C.data.card ≤ C.rank` is an inductive safety invariant and is strictly weaker than the earlier sufficient equality `C.rank = C.data.card`. The latter is **not** a minimal precondition. If the initial rank is strictly below the number of tags, terminal rank zero occurs with nonempty data for all selectors.

**Conditional corrected completion theorem:** With `RankDominates(C)` as an explicit hypothesis, the existing registered-rank termination theorem supplies `n ≤ C.rank` for which the iterated data set is empty. Without this hypothesis there is no such inference from the existing rank theorem. The `ConcretePlanarScientificDescentSystem` type does not enforce `RankDominates`: its `Configuration` stores independent `data` and `rank` fields.

## Independent bounded stress test

`verify_rank_dominance.py` uses no third-party packages. It enumerates all subsets of tag universes `0..6`, initial registered ranks `0..10`, every possible next-tag erasure (nondeterministic branch enumeration), and a bounded number of subsequent steps. It checks both exact formulas, the preserved inequality, the rank-zero iff condition at the first rank-zero step, and adverse under-ranked configurations.

Actual container output (exit code 0):

```
MODEL := arbitrary selector on a nonempty finite obstruction set
LABEL_SIZES := 0..6
ALL_SUBSETS_PER_LABEL_SIZE := enumerated
INITIAL_RANKS := 0..10
INITIAL_CONFIGURATIONS := 1397
NONDETERMINISTIC_TRANSITIONS := 31746
STATE_TIMES_CHECKED := 20317
MAX_SIMULTANEOUS_REACHABLE_DATA_SETS := 20
REGISTERED_RANK_FORMULA := max(r0-t,0)
DATA_CARDINALITY_FORMULA := max(s0-t,0)
RANK_DOMINANCE_INVARIANT := PASS
FIRST_TERMINAL_SHARP_IFF_CHECKS := 2042
RANK_ZERO_WITH_DATA_NONEMPTY_EXAMPLES := 2650
RANK_ZERO_IMPLIES_EMPTY_DATA_FROM_INITIAL_STATE := iff (r0 >= s0)
STATUS := COMPUTATION_PASS (finite range only)
LEAN_VERIFIED := NOT_RUN
```

Guard overrun is `INCOMPLETE`, never PASS. Finite evidence is not proof of the theorem outside the tested range. This finite result corroborates the complete elementary induction argument above.

## Lean candidate and exact verification boundary

`RankDominanceCandidate.lean` is intended to be compiled **without editing the imported repository module** and with exactly the repository's pinned Lean 4.27.0 and mathlib. It states preservation of `RankDominates` by the actual `finiteObstructionDescentStep`, propagation through `FiniteObstructionDescentSystem.nstep`, implication `terminal => data=∅` under the invariant, and an at-most-registered-rank data-exhaustion theorem. It includes `#print axioms` for all load-bearing declarations and introduces no new assumptions, `sorry`, or `native_decide` proofs.

**NOT_RUN:** The assistant container has no Lean executable or compiled URF `.olean`; the candidate's compilation and axiom output have **not** been verified on the Mac or GitHub CI. Source content and syntax were inspected, but there may be compiler errors. Stop at first compiler error; do not promote candidate or claim LEAN_VERIFIED until it compiles and the axiom whitelist passes (`propext`, `Classical.choice`, `Quot.sound` only). The presence of this research file alone does not change the production proof portfolio.

## What remains open for graph-level H1

`PlanarForbiddenMinorObstruction` has only two tags, `K5` and `K33`; an arbitrary pair of tags is not a graph-minor detector. Even a Lean-certified `RankDominates` invariant would prove only that a finite set of **supplied tags** is exhausted. It does not establish how a graph yields faithful tags, that those tags represent all forbidden minors, or that producing and updating them is definable in ordinary fixed-variable FO^k. A global preprocessing algorithm may carry information in the initial rank and tag assignments without being FO^k-local.

**Exact next mathematical blocker:** supply a fixed graph-to-tag mapping with soundness, completeness, and audited preprocessing cost; plus a fixed logical vocabulary and a proof relating the actual repository operator to FO^k semantics. No existential user-selected `FOkAdmissible := True` can discharge that obligation. Broad URF H1 and downstream complexity conclusions remain **OPEN**.

**Integration:** This is a research-only note. The base production source, the separate manuscript correction PR #602, the authoritative Mac checkout, and `main` remain untouched by this phase. No merge authorized.

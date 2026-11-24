# Finite-obstruction descent: rank/data consistency audit (2026-11-24)

**Scope:** Research-only, exact public source inspection at `main` commit `b0f3aa7b0a64d9c9d72235d7e84f08ad8347a87f`. `lean/URF/DescentSystem.lean` Git blob `be8a64f877be7aaf0153e6b6779fd738bf34fb21`. **Paper proof** plus bounded two-tag computational check. No newly compiled Lean declarations.

## Exact repository definitions and discrepancy

- Lines 16–18: `Configuration α` has independent fields `data : α`, `rank : Nat`. No relation between them is part of the type.
- Lines 1419–1427: `finiteObstructionDescentStep selector C` keeps `C.data` if empty; otherwise erases `selector.choose C.data` (whose membership is certified); in either case it replaces the registered rank by `C.rank - 1` (Nat subtraction).
- Lines 1443–1452: `FiniteObstructionDescentSystem` defines `terminal C := C.rank = 0`, and `extractR := fun _ _ => ∅`.
- Lines 1591–1594 and 1628–1648: the concrete planar instance has two distinct obstruction *tags* `K5` and `K33`, and an element selector; this is not an algorithm recognizing graph minors.
- Lines 1669–1693: `ConcretePlanarScientificDescentSystem` is the resulting finite-tag system, with a theorem giving rank-zero reachability within initial registered rank.

**Exact counterexamples in this state model:**

1. `C.data = {K5}`, `C.rank = 0`: terminal by definition, even though `data.Nonempty`.
2. `C.data = {K5, K33}`, `C.rank = 1`: after exactly one `finiteObstructionDescentStep` the chosen tag is erased and rank becomes zero, while precisely one tag remains. This holds for *every* selector satisfying `choose_mem`.

These observations do **not** contradict the source theorem that registered rank reaches zero; they refute the **additional semantic inference** that rank-zero termination by itself establishes deletion of all present obstruction tags.

## Minimal invariant and proof

Fix any finite type of obstructions and any selector whose output belongs to a nonempty input set. Define

`RankConsistent(C) : Prop := C.rank = C.data.card`.

For every `C` satisfying `RankConsistent`, its successor under `finiteObstructionDescentStep` also satisfies it.

**Proof (paper):** If the data set is empty, rank consistency forces `rank=0`, and the successor has empty data and `0-1=0`. If nonempty, selector membership ensures that erasing the chosen element decreases `card` by one; rank consistency implies `rank>0`, so `rank-1` equals the new cardinality. By induction the property persists under repeated steps. Consequently, within the invariant class, `terminal C ↔ C.data = ∅`. QED.

**Important boundary:** This proves an invariant of the code-defined *finite-tag erasure machine*, not a graph-theoretic invariant or H1 locality theorem. It does not supply a graph-to-tag encoding, proof that tags correspond to actual minor obstructions, or fixed FOᵏ semantics. A finite tag set also does not record multiplicity of minors in a graph.

## Reproducibility

`verify_finite_obstruction_rank_consistency.py` runs with Python standard library, no downloads. It enumerates the 4 subsets of two tags, registered ranks 0..4, and two independent admissible selectors (lexicographically first and last), totaling 40 state/selector checks, and independently verifies the invariant through iteration for 8 consistent initial cases. The exact execution receipt is `FINITE_OBSTRUCTION_RANK_RECEIPT_20261124.txt`.

This finite computation is `COMPUTATION_PASS`, not a Lean proof. The universal preservation argument is `PROVED (paper)`. The exact code from this new research branch has not been compiled by the user's Mac, and no `#print axioms` receipt exists for a corresponding new Lean theorem.

## Status / action boundary

- `RANK_ZERO_IMPLIES_EMPTY_DATA_UNRESTRICTED := REFUTED`.
- `RANK_CONSISTENCY_PRESERVED := PROVED (paper)`.
- `TWO_TAG_EXHAUSTIVE_MODEL := COMPUTATION_PASS`.
- `PRODUCTION_LEAN_INVARIANT := NOT_RUN / NOT_INTEGRATED`.
- `FAITHFUL_GRAPH_TO_TAG_ENCODING := OPEN`.
- `FIXED_REPOSITORY_NATIVE_H1_FO_K_SEMANTICS := OPEN`.
- `INDEPENDENT_REVIEW := OPEN`.

No modifications to production source, `main`, PR #602, or the authoritative Mac checkout. Promotion requires inspection and Lean verification of the actual repository theorem, with explicit initial-state consistency hypotheses. No merge performed.

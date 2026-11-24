# H1 fixed-semantics binding: exact repository operator audit (2026-11-24)

**Result:** SOURCE_AUDIT; proposed specification only; graph-level FO^k admissibility **OPEN**; no new Lean compilation.

## Exact code-defined candidate, not a witness of H1

Repository: `inaciovasquez2020/urf-core`, remote main at `b0f3aa7b0a64d9c9d72235d7e84f08ad8347a87f`.
`lean/URF/DescentSystem.lean` blob `be8a64f877be7aaf0153e6b6779fd738bf34fb21` defines:

- `URF.finiteObstructionDescentStep selector (C : Configuration (Finset Obstruction))`: erase a selected obstruction when the finite set is nonempty, and replace `C.rank` by `C.rank - 1`.
- `URF.FiniteObstructionDescentSystem Obstruction selector`: an instance whose `extractR` is identically empty and whose `step` is the function above.
- `URF.PlanarForbiddenMinorObstruction`: a *two-element tag type*, with constructors `K5` and `K33`.
- `URF.ConcretePlanarScientificDescentSystem`: a concrete instance on `Configuration (Finset PlanarForbiddenMinorObstruction)`, backed by a selector of an already-supplied tag.

This is a real **fixed operation on its stated datatype**. It is **not**, by itself, a computation taking a graph to a faithful set of forbidden-minor occurrences or detecting whether a graph has a `K5` or `K_{3,3}` minor. Those are mathematical/semantic obligations not present in the operator signature. Deleting a supplied tag is not a proof of an FO^k graph-local refinement procedure.

`lean/URF/H1Locality.lean` blob `393b679a5d76daf755d0be683d4b10fa4332f6a2` only packages an arbitrary `RefinementProcedure` type and arbitrary `FOkAdmissible` predicate. The source-exact `Unit/True` witnesses in PR #599 were Lean verified in isolation with zero axioms, proving that the present H1 **interface** is vacuous.

## Weakest missing semantic bridge

For any proposed graph-based interpretation, **fix in source before proving H1**:

1. `Graph`, the designated input class `C`, relational signature (including any colors/constants/order), and standard FO^k satisfaction `Sat(G,phi,tuple)`.
2. `Encode`: a *specified* graph-to-algorithm-state function representing the actual computation, including what the two obstruction tags mean on a particular input graph. Prove faithfulness of encoded labels; a user-selected post hoc mapping does not suffice.
3. `Run` / `Next`: a *specified* repository-native output predicate or update over graphs/tuples, and a commutation or simulation theorem between `Run` and the actual `ConcretePlanarScientificDescentSystem.step`; track any global preprocessing and use of choice.
4. A single integer `k>0` and, for each fixed repository procedure `r`, a fixed FO^k formula `phi_r` selected independently of the input graph, with
   `forall G in C, forall tuples a, Run(r,G,a) <-> Sat(G,phi_r,a)`.

This specification is not yet a Lean declaration because essential graph semantics are missing from the inspected code. Quantifying over an arbitrary witness-selected `Run` or `Sat` would recreate the original vacuity.

**Do not infer:** H1 for all polynomial-time algorithms, `TRAP`, or arbitrary finite-input graph algorithms from the two-element tag datatype or from the syntactic existence of `D.step`.

## Mathematical context and status

- At fixed degree and radius, the cycle-rank ceiling is bounded, so a sufficiently-high rank threshold can be vacuous. The Petersen graph blocks any nonvacuous type-splitting threshold for `Delta=3,R=1`.
- Pure FO^k, counting logic C^k, and iteration of graph refinements are not equivalent by default. The finite counting display in the original cycle-fan source does not establish an FO^k formula with a fixed variable budget.
- Manuscript repairs are intentionally separated into a dedicated draft PR. The frozen historical CLR source and signed transparency/Merkle manifests must not be silently rewritten. The actively maintained `CHECKSUMS.txt` manifest can be updated narrowly for changed tracked paths; full CI reconciliation remains necessary.

**VALIDATION:** Exact public GitHub source inspection, elementary finite graph argument, and isolated `pdflatex` on a corrected manuscript in Linux. No new Mac Lean compilation. New graph-level H1 = **OPEN**. Do not merge before reviewing the diff, checksum implications and CI outcomes.

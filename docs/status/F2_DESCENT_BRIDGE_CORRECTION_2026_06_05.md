# F2 Descent Bridge Correction — 2026-06-05

Status: CONDITIONAL_BRIDGE_TARGET_ONLY

Corrected closure status:

- `eliminateCol_clears_selected_column`: CLOSED
- `eliminateCol_preserves_cleared_column`: CLOSED
- `applyPivot.cleared_zero`: CLOSED
- `applyPivot.uncleared_nonzero`: CLOSED if the supplied Lean file compiles as written
- `ConcreteF2DescentRankStrictlyDrops`: TARGETED_CLOSED, pending local `lake build`
- `CanonicalPivotSelectionExists`: TARGETED_CLOSED, pending local `lake build`

Not closed:

- `F2DescentTerminates`: NOT_CLOSED; current theorem body is only a skeleton and does not thread iterated `applyPivot` states.
- `step_rank_drop`: NOT_DISCHARGED for `DescentSystem.lean`.
- `zero_rank_reached_within_rank`: NOT_DISCHARGED for `DescentSystem.lean`.

Minimal missing theorem:

`AbstractStepRealizesCanonicalF2Pivot`

Statement:

For the concrete representation map

\[
\phi : Configuration\ \alpha \to F2DescentState\ n\ m,
\]

every nonterminal abstract descent step realizes one canonical F2 pivot:

\[
\forall C,\ \neg terminal(C) \to
\exists j\ p\ hj\ hp,\
\phi(D.step\ C)=applyPivot(\phi C)\ j\ p\ hj\ hp.
\]

Consequences if proved:

1. `descentRank (φ (D.step C)) < descentRank (φ C)`.
2. Together with `ConcreteRankAgreement`, this yields `step_rank_drop`.
3. Strong induction on `C.rank` yields `zero_rank_reached_within_rank`.

No Chronos-RR, H4.1/FGL, P vs NP, or Clay-problem closure follows from the current bridge file.

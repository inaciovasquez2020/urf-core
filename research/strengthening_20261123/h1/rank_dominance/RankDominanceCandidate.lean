import URF.DescentSystem

/-!
Research-only candidate for actual repository definitions at source blob
be8a64f877be7aaf0153e6b6779fd738bf34fb21.

STATUS: NOT_RUN under Lean 4.27.0 and pinned mathlib. Do not treat the
presence of this file or a green unrelated root CI job as Lean verification.
No axioms, sorry, admit, opaque, or native_decide introduced here.
-/
namespace URF.RankDominanceAudit

universe u

/-- A registered rank large enough to pay for erasing all remaining tags. -/
def RankDominates {Obstruction : Type u}
    (C : Configuration (Finset Obstruction)) : Prop :=
  C.data.card ≤ C.rank

/-- This stronger-than-necessary equality is not needed for tag exhaustion. -/
theorem equality_implies_dominance {Obstruction : Type u}
    (C : Configuration (Finset Obstruction))
    (h : C.rank = C.data.card) : RankDominates C := by
  simpa [RankDominates, h]

/-- Every valid single-tag deletion preserves the necessary safety invariant. -/
theorem rank_dominates_step
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction)
    (C : Configuration (Finset Obstruction))
    (h : RankDominates C) :
    RankDominates (finiteObstructionDescentStep selector C) := by
  unfold RankDominates at h ⊢
  by_cases hd : C.data = ∅
  · simp [finiteObstructionDescentStep, hd]
  · have hm := selector.choose_mem C.data hd
    simp only [finiteObstructionDescentStep, dif_neg hd]
    rw [Finset.card_erase_of_mem hm]
    omega

/-- The actual nstep field is the recursive iteration of the above step. -/
theorem rank_dominates_nstep
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction) :
    ∀ (n : Nat) (C : Configuration (Finset Obstruction)),
      RankDominates C →
      RankDominates
        ((FiniteObstructionDescentSystem Obstruction selector).nstep n C) := by
  intro n
  induction n with
  | zero =>
      intro C h
      simpa [FiniteObstructionDescentSystem, finiteObstructionDescentNstep] using h
  | succ n ih =>
      intro C h
      change RankDominates
        (finiteObstructionDescentNstep selector n
          (finiteObstructionDescentStep selector C))
      exact ih _ (rank_dominates_step selector C h)

/-- A rank-zero terminal state is tag-empty *under the preserved invariant*. -/
theorem terminal_implies_empty_of_rank_dominance
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction)
    (C : Configuration (Finset Obstruction))
    (h : RankDominates C)
    (ht : (FiniteObstructionDescentSystem Obstruction selector).terminal C) :
    C.data = ∅ := by
  change C.rank = 0 at ht
  unfold RankDominates at h
  have hc : C.data.card = 0 := by omega
  exact Finset.card_eq_zero.mp hc

/-- Corrected tag-exhaustion theorem with the indispensable initial-state bound. -/
theorem data_empty_within_initial_rank
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction)
    (C : Configuration (Finset Obstruction))
    (h : RankDominates C) :
    ∃ n ≤ C.rank,
      ((FiniteObstructionDescentSystem Obstruction selector).nstep n C).data = ∅ := by
  obtain ⟨n, hn, hz⟩ :=
    zero_rank_reached_within_rank
      (FiniteObstructionDescentSystem Obstruction selector) C
  refine ⟨n, hn, ?_⟩
  have hpres := rank_dominates_nstep selector n C h
  exact terminal_implies_empty_of_rank_dominance selector _ hpres hz

end URF.RankDominanceAudit

#print axioms URF.RankDominanceAudit.equality_implies_dominance
#print axioms URF.RankDominanceAudit.rank_dominates_step
#print axioms URF.RankDominanceAudit.rank_dominates_nstep
#print axioms URF.RankDominanceAudit.terminal_implies_empty_of_rank_dominance
#print axioms URF.RankDominanceAudit.data_empty_within_initial_rank

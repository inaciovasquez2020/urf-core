import Mathlib.Data.Finset.Card

namespace URF
universe u

structure Configuration (α : Type u) where
  data : α
  rank : Nat

structure FiniteObstructionSelector (Obstruction : Type u) [DecidableEq Obstruction] where
  choose : ∀ s : Finset Obstruction, s ≠ ∅ → Obstruction
  choose_mem : ∀ s h, choose s h ∈ s

def finiteObstructionDescentStep
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction)
    (C : Configuration (Finset Obstruction)) :
    Configuration (Finset Obstruction) :=
  if h : C.data = ∅ then
    { data := C.data, rank := C.rank - 1 }
  else
    { data := C.data.erase (selector.choose C.data h), rank := C.rank - 1 }

def finiteObstructionDescentNstep
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction) :
    Nat → Configuration (Finset Obstruction) → Configuration (Finset Obstruction)
  | 0, C => C
  | n + 1, C => finiteObstructionDescentNstep selector n
      (finiteObstructionDescentStep selector C)


namespace SharpRankAudit

theorem step_card
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentStep selector C).data.card = C.data.card - 1 := by
  by_cases hd : C.data = ∅
  · simp [finiteObstructionDescentStep, hd]
  · have hm := selector.choose_mem C.data hd
    simp only [finiteObstructionDescentStep, dif_neg hd]
    exact Finset.card_erase_of_mem hm

theorem step_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentStep selector C).rank = C.rank - 1 := by
  by_cases hd : C.data = ∅
  · simp [finiteObstructionDescentStep, hd]
  · simp [finiteObstructionDescentStep, hd]

theorem nstep_card
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O) :
    ∀ (n : Nat) (C : Configuration (Finset O)),
      (finiteObstructionDescentNstep selector n C).data.card = C.data.card - n := by
  intro n
  induction n with
  | zero =>
      intro C
      rfl
  | succ n ih =>
      intro C
      change (finiteObstructionDescentNstep selector n
        (finiteObstructionDescentStep selector C)).data.card = C.data.card - (n + 1)
      rw [ih (finiteObstructionDescentStep selector C), step_card selector C]
      omega

theorem nstep_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O) :
    ∀ (n : Nat) (C : Configuration (Finset O)),
      (finiteObstructionDescentNstep selector n C).rank = C.rank - n := by
  intro n
  induction n with
  | zero =>
      intro C
      rfl
  | succ n ih =>
      intro C
      change (finiteObstructionDescentNstep selector n
        (finiteObstructionDescentStep selector C)).rank = C.rank - (n + 1)
      rw [ih (finiteObstructionDescentStep selector C), step_rank selector C]
      omega

theorem rank_zero_at_initial_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentNstep selector C.rank C).rank = 0 := by
  rw [nstep_rank selector C.rank C]
  omega

theorem data_empty_at_initial_rank_iff
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentNstep selector C.rank C).data = ∅ ↔
      C.data.card ≤ C.rank := by
  constructor
  · intro h
    have hz : (finiteObstructionDescentNstep selector C.rank C).data.card = 0 := by
      simp [h]
    rw [nstep_card selector C.rank C] at hz
    omega
  · intro h
    apply Finset.card_eq_zero.mp
    rw [nstep_card selector C.rank C]
    omega

end SharpRankAudit
end URF

#print axioms URF.SharpRankAudit.step_card
#print axioms URF.SharpRankAudit.step_rank
#print axioms URF.SharpRankAudit.nstep_card
#print axioms URF.SharpRankAudit.nstep_rank
#print axioms URF.SharpRankAudit.rank_zero_at_initial_rank
#print axioms URF.SharpRankAudit.data_empty_at_initial_rank_iff

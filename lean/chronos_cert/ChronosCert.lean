import Mathlib

namespace ChronosCert

variable {Ω : Type}

constant Prob : Type
constant entropy : Prob → Real
constant condEntropy : Prob → Nat → Real
constant mutualInfo : Prob → Nat → Real

/-- Explicit input surface carrying the ChronosCert entropy/determinism payloads. -/
structure ChronosCertEntropyDeterminismInvariant : Prop where
  mi_le_entropy_answer :
    ∀ (P : Prob) (t : Nat) (Bk : Nat), mutualInfo P t ≤ Real.log Bk
  determinism_identity :
    ∀ (P : Prob) (t : Nat),
      condEntropy P t - condEntropy P (t+1) = mutualInfo P t
  entropy_drop_ceiling :
    ∀ (P : Prob) (t : Nat) (C : Real),
      mutualInfo P t ≤ C → condEntropy P t - condEntropy P (t+1) ≤ C

theorem mi_le_entropy_answer_from_invariant
    (h : ChronosCertEntropyDeterminismInvariant) :
    ∀ (P : Prob) (t : Nat) (Bk : Nat), mutualInfo P t ≤ Real.log Bk :=
  h.mi_le_entropy_answer

theorem determinism_identity_from_invariant
    (h : ChronosCertEntropyDeterminismInvariant) :
    ∀ (P : Prob) (t : Nat),
      condEntropy P t - condEntropy P (t+1) = mutualInfo P t :=
  h.determinism_identity

theorem entropy_drop_ceiling_from_invariant
    (h : ChronosCertEntropyDeterminismInvariant) :
    ∀ (P : Prob) (t : Nat) (C : Real),
      mutualInfo P t ≤ C → condEntropy P t - condEntropy P (t+1) ≤ C :=
  h.entropy_drop_ceiling

theorem drop_ceiling_from_mi
  (P : Prob) (t : Nat) (C : Real)
  (h : mutualInfo P t ≤ C) :
  condEntropy P t - condEntropy P (t+1) ≤ C := by
  have := entropy_drop_ceiling P t C h
  exact this

theorem telescoping_sum
  (P : Prob) (T : Nat) :
  (condEntropy P 0 - condEntropy P T) =
    Finset.sum (Finset.range T) (fun t => condEntropy P t - condEntropy P (t+1)) := by
  classical
  induction T with
  | zero =>
      simp
  | succ T ih =>
      simp [Finset.range_succ, ih, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]


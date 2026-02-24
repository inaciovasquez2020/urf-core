import Mathlib

axiom InfoStepBound : ℝ
axiom info_step_nonneg : 0 ≤ InfoStepBound

axiom info_increment
  (t : ℕ) : ℝ

axiom info_increment_le :
  ∀ t, info_increment t ≤ InfoStepBound

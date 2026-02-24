import Mathlib

axiom InfoStepBound : ℝ
axiom entropy_monotone : ∀ {a b : ℕ}, a ≤ b → entropy_of_set a ≤ entropy_of_set b
axiom info_step_nonneg : 0 ≤ InfoStepBound

axiom entropy_step : ∀ n, entropy_of_set (n+1) - entropy_of_set n ≤ InfoStepBound

axiom info_increment
  (t : ℕ) : ℝ

axiom entropy_step : ∀ n, entropy_of_set (n+1) - entropy_of_set n ≤ InfoStepBound

axiom info_increment_le :
  ∀ t, info_increment t ≤ InfoStepBound

import Mathlib

/-!
# Finite telescoping identity for discrete scale paths

This module isolates the exact algebraic telescoping identity used to
control an L-step path increment by its consecutive increments.
It contains no Fourier, Sobolev, or lacunary estimate.
-/

namespace URF
namespace Analysis

theorem sum_succ_sub_eq_sub
    {E : Type*} [AddCommGroup E]
    (m : ℕ → E) (j L : ℕ) :
    (∑ r ∈ Finset.range L, (m (j + r + 1) - m (j + r))) =
      m (j + L) - m j := by
  induction L with
  | zero =>
      simp
  | succ L ih =>
      rw [Finset.sum_range_succ]
      rw [ih]
      simp only [Nat.add_assoc]
      abel

end Analysis
end URF

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

/--
The norm of an L-step path increment is bounded by the sum of the
norms of its consecutive increments. This is the block-variation
estimate; finite-sum multiplicity and tracking-error estimates remain
separate obligations.
-/
theorem norm_sub_le_sum_succ_sub_norm
    {E : Type*} [NormedAddCommGroup E]
    (m : ℕ → E) (j L : ℕ) :
    ‖m (j + L) - m j‖ ≤
      ∑ r ∈ Finset.range L, ‖m (j + r + 1) - m (j + r)‖ := by
  calc
    ‖m (j + L) - m j‖ =
        ‖∑ r ∈ Finset.range L,
          (m (j + r + 1) - m (j + r))‖ := by
            rw [sum_succ_sub_eq_sub]
    _ ≤ ∑ r ∈ Finset.range L,
        ‖m (j + r + 1) - m (j + r)‖ := norm_sum_le _ _

end Analysis
end URF

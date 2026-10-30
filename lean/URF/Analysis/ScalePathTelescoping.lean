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

/--
Sliding-block overlap estimate. Every nonnegative increment can be
charged to at most L starting positions. The proof uses a bounded
double-sum majorant with a fixed outer range.
-/
theorem sliding_block_sum_le
    (a : ℕ → ℝ) (N L : ℕ)
    (ha : ∀ i, 0 ≤ a i) :
    (∑ j ∈ Finset.range N,
      ∑ r ∈ Finset.range L, a (j + r)) ≤
      (L : ℝ) * ∑ i ∈ Finset.range (N + L), a i := by
  rw [Finset.sum_comm]
  calc
    (∑ r ∈ Finset.range L, ∑ j ∈ Finset.range N, a (j + r))
      ≤ ∑ r ∈ Finset.range L,
          ∑ i ∈ Finset.range (N + L), a i := by
            apply Finset.sum_le_sum
            intro r hr
            have hrL : r < L := Finset.mem_range.mp hr
            rw [← Finset.sum_Ico_eq_sum_range]
            apply Finset.sum_le_sum_of_subset_of_nonneg
            · intro i hi
              have hri := Finset.mem_Ico.mp hi
              exact Finset.mem_range.mpr (by omega)
            · intro i hi _
              exact ha i
    _ = (L : ℝ) * ∑ i ∈ Finset.range (N + L), a i := by
          simp

end Analysis
end URF

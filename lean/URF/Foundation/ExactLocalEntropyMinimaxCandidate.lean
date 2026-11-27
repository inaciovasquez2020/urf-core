import Mathlib

/-!
Exact deterministic minimax absolute error for scalar information recovery.
This is the reusable decision-theoretic layer of the cycle-space entropy
obstruction. Graph locality and attainable cycle counts are separate obligations.
-/

namespace URF.EntropyBridge

/-- Given an unknown scalar in a closed interval, its midpoint is a minimax
absolute-error estimate; both interval endpoints force the sharp lower bound. -/
theorem scalar_midpoint_minimax (lo hi : ℝ) (hle : lo ≤ hi) :
    (∀ a : ℝ, (hi - lo) / 2 ≤ max |a - lo| |a - hi|) ∧
    (∀ x : ℝ, lo ≤ x → x ≤ hi →
      |(lo + hi) / 2 - x| ≤ (hi - lo) / 2) := by
  constructor
  · intro a
    have habs : hi - lo ≤ |hi - a| + |a - lo| := by
      calc
        hi - lo = |hi - lo| := (abs_of_nonneg (sub_nonneg.mpr hle)).symm
        _ = |(hi - a) + (a - lo)| := by congr 1; ring
        _ ≤ _ := abs_add_le _ _
    have hleft : |a - lo| ≤ max |a - lo| |a - hi| :=
      le_max_left _ _
    have hright : |hi - a| ≤ max |a - lo| |a - hi| := by
      rw [abs_sub_comm hi a]
      exact le_max_right _ _
    linarith
  · intro x hxlo hxhi
    apply abs_le.mpr
    constructor <;> dsimp <;> linarith

/-- Exact endpoint lower bound and midpoint upper bound for an unknown
integer component count in [1,M], with nonnegative information per component. -/
theorem component_entropy_minimax
    (M : ℕ) (hM : 1 ≤ M) (w : ℝ) (hw : 0 ≤ w) :
    (∀ a : ℝ, (((M : ℝ) - 1) * w) / 2 ≤
      max |a - w| |a - (M : ℝ) * w|) ∧
    (∀ c : ℕ, 1 ≤ c → c ≤ M →
      |(((M : ℝ) + 1) * w) / 2 - (c : ℝ) * w| ≤
        (((M : ℝ) - 1) * w) / 2) := by
  have hMr : (1 : ℝ) ≤ (M : ℝ) := by exact_mod_cast hM
  have hlohi : w ≤ (M : ℝ) * w := by
    have h := mul_le_mul_of_nonneg_right hMr hw
    simpa only [one_mul] using h
  obtain ⟨hlower, hupper⟩ := scalar_midpoint_minimax w ((M : ℝ) * w) hlohi
  constructor
  · intro a
    convert hlower a using 1 <;> ring
  · intro c hc hcM
    have hcr : (1 : ℝ) ≤ (c : ℝ) := by exact_mod_cast hc
    have hcrM : (c : ℝ) ≤ (M : ℝ) := by exact_mod_cast hcM
    have hclo : w ≤ (c : ℝ) * w := by
      have h := mul_le_mul_of_nonneg_right hcr hw
      simpa only [one_mul] using h
    have hchi : (c : ℝ) * w ≤ (M : ℝ) * w :=
      mul_le_mul_of_nonneg_right hcrM hw
    convert hupper ((c : ℝ) * w) hclo hchi using 1 <;> ring

/-- Numeric specialization for a nonempty cycle partition of N vertices,
minimum cycle length L, and alphabet cardinality q. -/
theorem cycle_entropy_minimax_numeric
    (N L q : ℕ) (hNL : L ≤ N) (hL : 0 < L) (hq : 1 ≤ q) :
    (∀ a : ℝ, ((((N / L : ℕ) : ℝ) - 1) * Real.log q) / 2 ≤
      max |a - Real.log q| |a - ((N / L : ℕ) : ℝ) * Real.log q|) ∧
    (∀ c : ℕ, 1 ≤ c → c ≤ N / L →
      |(((((N / L : ℕ) : ℝ) + 1) * Real.log q) / 2) -
          (c : ℝ) * Real.log q| ≤
        ((((N / L : ℕ) : ℝ) - 1) * Real.log q) / 2) := by
  have hdiv : 1 ≤ N / L := Nat.div_pos hNL hL
  have hw : 0 ≤ Real.log (q : ℝ) := Real.log_nonneg (by exact_mod_cast hq)
  exact component_entropy_minimax (N / L) hdiv (Real.log q) hw

#print axioms URF.EntropyBridge.scalar_midpoint_minimax
#print axioms URF.EntropyBridge.component_entropy_minimax
#print axioms URF.EntropyBridge.cycle_entropy_minimax_numeric

end URF.EntropyBridge

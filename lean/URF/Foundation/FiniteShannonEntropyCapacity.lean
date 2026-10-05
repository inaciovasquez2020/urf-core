import Mathlib

namespace URF.Foundation

theorem finiteShannonEntropy_le_log_card
    {β : Type u} [DecidableEq β] [Fintype β]
    (P : FiniteShannonEntropyData β) :
    finiteShannonEntropy P ≤ Real.log (Fintype.card β) := by
  classical
  let t : Finset β := Finset.univ.filter fun b ↦ P.prob b ≠ 0
  set k := t.card with hk
  have ht_nonempty : t.Nonempty := by
    by_contra ht
    rw [Finset.not_nonempty_iff_eq_empty] at ht
    have hpzero : ∀ b, P.prob b = 0 := by
      intro b
      by_contra hb
      have : b ∈ t := by simp [t, hb]
      simp [ht] at this
    rw [Finset.sum_eq_zero fun b _ ↦ hpzero b] at P.sum_one
    exact zero_ne_one P.sum_one
  have hk_pos : 0 < k := by
    simpa [k] using Finset.card_pos.mpr ht_nonempty
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk_pos
  have hsum_t : ∑ b ∈ t, P.prob b = 1 := by
    rw [← P.sum_one]
    refine Finset.sum_subset (Finset.subset_univ t) ?_
    intro b _ hbt
    have hb : P.prob b = 0 := by
      by_contra hb
      exact hbt (by simp [t, hb])
    rw [hb]
  have hsum_entropy :
      ∑ b ∈ t, Real.negMulLog (P.prob b) = finiteShannonEntropy P := by
    rw [finiteShannonEntropy]
    refine Finset.sum_subset (Finset.subset_univ t) ?_
    intro b _ hbt
    have hb : P.prob b = 0 := by
      by_contra hb
      exact hbt (by simp [t, hb])
    rw [hb, Real.negMulLog_zero]
  have hJensen := Real.concaveOn_negMulLog.le_map_sum
    (t := t) (w := fun _ : β ↦ ((k : ℝ)⁻¹)) (p := P.prob)
    (fun _ _ ↦ by positivity)
    (by rw [Finset.sum_const, nsmul_eq_mul, ← hk, mul_inv_cancel₀ hkR.ne'])
    (fun b _ ↦ P.nonneg b)
  rw [show (∑ b ∈ t, (k : ℝ)⁻¹ • P.prob b) = (k : ℝ)⁻¹ by
    rw [← Finset.smul_sum, hsum_t, smul_eq_mul, mul_one]] at hJensen
  have hleft :
      ∑ b ∈ t, (k : ℝ)⁻¹ • Real.negMulLog (P.prob b) =
        (k : ℝ)⁻¹ * finiteShannonEntropy P := by
    rw [← Finset.smul_sum, hsum_entropy, smul_eq_mul]
  rw [hleft] at hJensen
  have hright : (k : ℝ) * Real.negMulLog ((k : ℝ)⁻¹) = Real.log k := by
    rw [Real.negMulLog, Real.log_inv, neg_mul_neg, ← mul_assoc,
      mul_inv_cancel₀ hkR.ne', one_mul]
  have hscaled :
      (k : ℝ) * ((k : ℝ)⁻¹ * finiteShannonEntropy P) =
        finiteShannonEntropy P := by
    rw [← mul_assoc, mul_inv_cancel₀ hkR.ne', one_mul]
  have hmul := mul_le_mul_of_nonneg_left hJensen hkR.le
  rw [hscaled, hright] at hmul
  have hcard_le : t.card ≤ Finset.univ.card :=
    Finset.card_le_card (Finset.subset_univ t)
  have hlog_card : Real.log (t.card : ℝ) ≤ Real.log (Fintype.card β) := by
    apply Real.strictMonoOn_log.monotoneOn
    · exact_mod_cast hcard_le
    · exact_mod_cast hk_pos
  exact le_trans hmul hlog_card

end URF.Foundation

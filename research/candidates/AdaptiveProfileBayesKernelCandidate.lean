import Mathlib

namespace URF.Foundation.AdaptiveProfileAudit

open scoped BigOperators

/-- Error probability for a fixed decision rule; true means class U. -/
noncomputable def decisionRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) (rule : L → Bool) : ℝ :=
  ∑ l, if rule l then (1 - pi) * nu l else pi * mu l

/-- Pointwise optimal finite-transcript error. -/
noncomputable def bayesRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) : ℝ :=
  ∑ l, min (pi * mu l) ((1 - pi) * nu l)

private theorem scale_min (a b x : ℝ) (hx : 0 ≤ x) :
    min (a * x) (b * x) = min a b * x := by
  rcases le_total a b with hab | hba
  · rw [min_eq_left (mul_le_mul_of_nonneg_right hab hx), min_eq_left hab]
  · rw [min_eq_right (mul_le_mul_of_nonneg_right hba hx), min_eq_right hba]

theorem bayesRisk_le_decisionRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) (rule : L → Bool) :
    bayesRisk pi mu nu ≤ decisionRisk pi mu nu rule := by
  unfold bayesRisk decisionRisk
  apply Finset.sum_le_sum
  intro l _
  cases h : rule l
  · simpa [h] using min_le_left (pi * mu l) ((1 - pi) * nu l)
  · simpa [h] using min_le_right (pi * mu l) ((1 - pi) * nu l)

theorem bayesRisk_attained {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) :
    ∃ rule : L → Bool, decisionRisk pi mu nu rule = bayesRisk pi mu nu := by
  classical
  refine ⟨fun l => decide ((1 - pi) * nu l ≤ pi * mu l), ?_⟩
  unfold decisionRisk bayesRisk
  apply Finset.sum_congr rfl
  intro l _
  by_cases h : (1 - pi) * nu l ≤ pi * mu l
  · simp [h, min_eq_right h]
  · simp [h, min_eq_left (le_of_not_ge h)]

/-- Every observation with a lower likelihood ratio has at least this error. -/
theorem bayesRisk_ge_likelihood {L : Type*} [Fintype L]
    (pi c : ℝ) (mu nu : L → ℝ)
    (hpi : pi ≤ 1) (hmu : ∀ l, 0 ≤ mu l)
    (hsum : ∑ l, mu l = 1)
    (hbound : ∀ l, c * mu l ≤ nu l) :
    min pi ((1 - pi) * c) ≤ bayesRisk pi mu nu := by
  unfold bayesRisk
  calc
    min pi ((1 - pi) * c) =
        ∑ l, min pi ((1 - pi) * c) * mu l := by
          rw [← Finset.mul_sum, hsum, mul_one]
    _ ≤ ∑ l, min (pi * mu l) ((1 - pi) * nu l) := by
      apply Finset.sum_le_sum
      intro l _
      rw [← scale_min pi ((1 - pi) * c) (mu l) (hmu l)]
      apply min_le_min le_rfl
      calc
        ((1 - pi) * c) * mu l = (1 - pi) * (c * mu l) := by ring
        _ ≤ (1 - pi) * nu l :=
          mul_le_mul_of_nonneg_left (hbound l) (sub_nonneg.mpr hpi)

/-- Fixed maximizing query sets give a constant likelihood ratio on feasible leaves. -/
theorem bayesRisk_eq_of_likelihood {L : Type*} [Fintype L]
    (pi c : ℝ) (mu nu : L → ℝ)
    (hpi : pi ≤ 1) (hmu : ∀ l, 0 ≤ mu l) (hnu : ∀ l, 0 ≤ nu l)
    (hsum : ∑ l, mu l = 1)
    (heq : ∀ l, mu l ≠ 0 → nu l = c * mu l) :
    bayesRisk pi mu nu = min pi ((1 - pi) * c) := by
  unfold bayesRisk
  calc
    (∑ l, min (pi * mu l) ((1 - pi) * nu l)) =
        ∑ l, min pi ((1 - pi) * c) * mu l := by
      apply Finset.sum_congr rfl
      intro l _
      by_cases hz : mu l = 0
      · simp [hz, min_eq_left (mul_nonneg (sub_nonneg.mpr hpi) (hnu l))]
      · rw [heq l hz, ← mul_assoc, scale_min pi ((1 - pi) * c) (mu l) (hmu l)]
    _ = min pi ((1 - pi) * c) := by
      rw [← Finset.mul_sum, hsum, mul_one]

/-- Extract the lower complement likelihood from the uniform-mixture identity. -/
theorem likelihood_of_mixture {L : Type*}
    (a b : ℝ) (mu nu lam : L → ℝ) (hb : b < 1)
    (hmix : ∀ l, lam l = b * mu l + (1 - b) * nu l)
    (hbound : ∀ l, a * mu l ≤ lam l) :
    ∀ l, ((a - b) / (1 - b)) * mu l ≤ nu l := by
  intro l
  have h := (hbound l).trans_eq (hmix l)
  calc
    ((a - b) / (1 - b)) * mu l = ((a - b) * mu l) / (1 - b) := by ring
    _ ≤ nu l := (div_le_iff₀ (sub_pos.mpr hb)).2 (by linarith)

/-- Generic transcript bound: the coordinate-cylinder proof must supply hbound. -/
theorem decisionRisk_ge_mixture_bound {L : Type*} [Fintype L]
    (pi a b : ℝ) (mu nu lam : L → ℝ) (rule : L → Bool)
    (hpi : pi ≤ 1) (hb : b < 1)
    (hmu : ∀ l, 0 ≤ mu l) (hsum : ∑ l, mu l = 1)
    (hmix : ∀ l, lam l = b * mu l + (1 - b) * nu l)
    (hbound : ∀ l, a * mu l ≤ lam l) :
    min pi ((1 - pi) * ((a - b) / (1 - b))) ≤ decisionRisk pi mu nu rule :=
  (bayesRisk_ge_likelihood pi ((a - b) / (1 - b)) mu nu hpi hmu hsum
    (likelihood_of_mixture a b mu nu lam hb hmix hbound)).trans
    (bayesRisk_le_decisionRisk pi mu nu rule)

#print axioms decisionRisk
#print axioms bayesRisk
#print axioms bayesRisk_le_decisionRisk
#print axioms bayesRisk_attained
#print axioms bayesRisk_ge_likelihood
#print axioms bayesRisk_eq_of_likelihood
#print axioms likelihood_of_mixture
#print axioms decisionRisk_ge_mixture_bound

end URF.Foundation.AdaptiveProfileAudit

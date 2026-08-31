import Mathlib.MeasureTheory.Measure.AbsolutelyContinuous
import URF.Foundation.FiniteConditionalProductGibbsMeasures

namespace URF.Foundation.FiniteXYZAbsoluteContinuity

open MeasureTheory
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteRandomVariablePushforward
open URF.Foundation.FiniteJointDistributionEntropy
open URF.Foundation.FiniteDistributionMathlibMeasureBridge
open URF.Foundation.FiniteConditionalProductGibbsMeasures

universe u

noncomputable section

/-- A positive `(Z,X,Y)` atom is bounded above by its `(X,Z)` marginal atom. -/
theorem finiteXYZComparisonDistribution_prob_le_XZ
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ) :
    (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) ≤
      finiteJointProb μ X Z (x, z) := by
  rw [finiteXYZComparisonDistribution_prob, finiteJointProb_eq_preimage_sum]
  apply Finset.sum_le_sum
  intro a _
  by_cases hxyz : Z a = z ∧ X a = x ∧ Y a = y
  · have hxz : X a = x ∧ Z a = z := ⟨hxyz.2.1, hxyz.1⟩
    simp [hxyz, hxz]
  · by_cases hxz : X a = x ∧ Z a = z
    · simp [hxyz, hxz, μ.nonnegative a]
    · simp [hxyz, hxz]

/-- A positive `(Z,X,Y)` atom is bounded above by its `(Y,Z)` marginal atom. -/
theorem finiteXYZComparisonDistribution_prob_le_YZ
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ) :
    (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) ≤
      finiteJointProb μ Y Z (y, z) := by
  rw [finiteXYZComparisonDistribution_prob, finiteJointProb_eq_preimage_sum]
  apply Finset.sum_le_sum
  intro a _
  by_cases hxyz : Z a = z ∧ X a = x ∧ Y a = y
  · have hyz : Y a = y ∧ Z a = z := ⟨hxyz.2.2, hxyz.1⟩
    simp [hxyz, hyz]
  · by_cases hyz : Y a = y ∧ Z a = z
    · simp [hxyz, hyz, μ.nonnegative a]
    · simp [hxyz, hyz]

/-- A positive `(Z,X,Y)` atom is bounded above by its `Z` marginal atom. -/
theorem finiteXYZComparisonDistribution_prob_le_Z
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ) :
    (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) ≤
      finiteRandomVariablePushProb μ Z z := by
  rw [finiteXYZComparisonDistribution_prob, finiteRandomVariablePushProb_eq_preimage_sum]
  apply Finset.sum_le_sum
  intro a _
  by_cases hxyz : Z a = z ∧ X a = x ∧ Y a = y
  · simp [hxyz]
  · by_cases hz : Z a = z
    · simp [hxyz, hz, μ.nonnegative a]
    · simp [hxyz, hz]

/-- Positive actual joint mass forces all three comparison factors to be positive. -/
theorem finiteXYZComparisonDistribution_positive_implies_marginals_positive
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ)
    (hxyz : 0 < (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) :
    0 < finiteRandomVariablePushProb μ Z z ∧
      0 < finiteJointProb μ X Z (x, z) ∧
      0 < finiteJointProb μ Y Z (y, z) := by
  constructor
  · exact lt_of_lt_of_le hxyz
      (finiteXYZComparisonDistribution_prob_le_Z μ X Y Z z x y)
  constructor
  · exact lt_of_lt_of_le hxyz
      (finiteXYZComparisonDistribution_prob_le_XZ μ X Y Z z x y)
  · exact lt_of_lt_of_le hxyz
      (finiteXYZComparisonDistribution_prob_le_YZ μ X Y Z z x y)

/-- Every positive actual joint atom is positive under the conditional-product comparison law. -/
theorem finiteXYZComparisonDistribution_positive_implies_conditionalProduct_positive
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ)
    (hxyz : 0 < (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) :
    0 < finiteConditionalProductProb μ X Y Z (z, (x, y)) := by
  obtain ⟨hpz, hxz, hyz⟩ :=
    finiteXYZComparisonDistribution_positive_implies_marginals_positive
      μ X Y Z z x y hxyz
  simp only [finiteConditionalProductProb]
  rw [if_neg (ne_of_gt hpz)]
  exact div_pos (mul_pos hxz hyz) hpz

/-- Support of the actual finite PMF is contained in the conditional-product PMF support. -/
theorem finiteXYZComparisonPMF_support_subset_conditionalProductPMF_support
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).support ⊆
      (finDistributionToPMF (finiteConditionalProductDistribution μ X Y Z)).support := by
  intro s hs
  rcases s with ⟨z, ⟨x, y⟩⟩
  have hactualPMF :
      0 < finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z) (z, (x, y)) :=
    (PMF.apply_pos_iff _ _).2 hs
  have hactual :
      0 < (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) := by
    simpa only [finDistributionToPMF_apply, ENNReal.ofReal_pos] using hactualPMF
  have hq : 0 < finiteConditionalProductProb μ X Y Z (z, (x, y)) :=
    finiteXYZComparisonDistribution_positive_implies_conditionalProduct_positive
      μ X Y Z z x y hactual
  apply (PMF.apply_pos_iff _ _).1
  simpa only [finDistributionToPMF_apply, finiteConditionalProductDistribution,
    ENNReal.ofReal_pos] using hq

/--
The actual finite `(Z,X,Y)` measure is absolutely continuous with respect to
its conditional-product comparison measure. No Gibbs inequality is used here.
-/
theorem finiteXYZComparisonMeasure_absolutelyContinuous_conditionalProductMeasure
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteXYZComparisonMeasure μ X Y Z ≪
      finiteConditionalProductMeasure μ X Y Z := by
  apply Measure.AbsolutelyContinuous.mk
  intro s hs hzero
  simp only [finiteXYZComparisonMeasure, finiteConditionalProductMeasure,
    finDistributionToMeasure] at hzero ⊢
  rw [(finDistributionToPMF (finiteConditionalProductDistribution μ X Y Z)).toMeasure_apply_eq_zero_iff hs]
    at hzero
  rw [(finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).toMeasure_apply_eq_zero_iff hs]
  exact hzero.mono
    (finiteXYZComparisonPMF_support_subset_conditionalProductPMF_support μ X Y Z)
    Set.Subset.rfl

def status : String :=
  "FINITE_XYZ_ABSOLUTELY_CONTINUOUS_WITH_RESPECT_TO_CONDITIONAL_PRODUCT_MEASURE"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_GIBBS_LLR_INTEGRABILITY"

end

end URF.Foundation.FiniteXYZAbsoluteContinuity

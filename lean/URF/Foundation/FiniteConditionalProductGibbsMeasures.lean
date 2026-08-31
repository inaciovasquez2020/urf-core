import Mathlib.Data.Fintype.BigOperators
import URF.Foundation.FiniteJointDistributionEntropy
import URF.Foundation.FiniteDistributionMathlibMeasureBridge

namespace URF.Foundation.FiniteConditionalProductGibbsMeasures

open MeasureTheory
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteRandomVariablePushforward
open URF.Foundation.FiniteJointDistributionEntropy
open URF.Foundation.FiniteDistributionMathlibMeasureBridge

universe u

noncomputable section

/-- Summing a joint law over its first coordinate recovers the second marginal. -/
theorem finiteJointProb_sum_first
    {α β δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Z : α → δ) (z : δ) :
    (∑ x : β, finiteJointProb μ X Z (x, z)) =
      finiteRandomVariablePushProb μ Z z := by
  classical
  rw [finiteRandomVariablePushProb_eq_preimage_sum]
  simp_rw [finiteJointProb_eq_preimage_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  by_cases hz : Z a = z
  · simp [hz]
  · simp [hz]

/--
The conditional-product comparison mass used for conditional Gibbs:

  Q(z,x,y) = P(X=x,Z=z) P(Y=y,Z=z) / P(Z=z)

when `P(Z=z) ≠ 0`, and zero on a zero-probability `z` fiber.
-/
def finiteConditionalProductProb
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    δ × (β × γ) → ℝ :=
  fun s =>
    let z := s.1
    let x := s.2.1
    let y := s.2.2
    let pz := finiteRandomVariablePushProb μ Z z
    if pz = 0 then 0
    else finiteJointProb μ X Z (x, z) * finiteJointProb μ Y Z (y, z) / pz

/-- Conditional-product masses are nonnegative. -/
theorem finiteConditionalProductProb_nonnegative
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    ∀ s : δ × (β × γ), 0 ≤ finiteConditionalProductProb μ X Y Z s := by
  intro s
  rcases s with ⟨z, ⟨x, y⟩⟩
  simp only [finiteConditionalProductProb]
  by_cases hpz : finiteRandomVariablePushProb μ Z z = 0
  · simp [hpz]
  · rw [if_neg hpz]
    exact div_nonneg
      (mul_nonneg
        ((finiteJointProb_nonnegative μ X Z) (x, z))
        ((finiteJointProb_nonnegative μ Y Z) (y, z)))
      (finiteRandomVariablePushProb_nonnegative μ Z z)

/-- Each fixed-`z` fiber of the conditional-product law has mass `P(Z=z)`. -/
theorem finiteConditionalProductProb_fiber_sum
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) :
    (∑ xy : β × γ, finiteConditionalProductProb μ X Y Z (z, xy)) =
      finiteRandomVariablePushProb μ Z z := by
  classical
  by_cases hpz : finiteRandomVariablePushProb μ Z z = 0
  · simp [finiteConditionalProductProb, hpz]
  · rw [Fintype.sum_prod_type]
    simp only [finiteConditionalProductProb, hpz, if_false]
    have hinner : ∀ x : β,
        (∑ y : γ,
          finiteJointProb μ X Z (x, z) * finiteJointProb μ Y Z (y, z) /
            finiteRandomVariablePushProb μ Z z) =
        finiteJointProb μ X Z (x, z) *
            (∑ y : γ, finiteJointProb μ Y Z (y, z)) /
              finiteRandomVariablePushProb μ Z z := by
      intro x
      simp_rw [div_eq_mul_inv]
      rw [← Finset.sum_mul, ← Finset.mul_sum]
    calc
      (∑ x : β, ∑ y : γ,
          finiteJointProb μ X Z (x, z) * finiteJointProb μ Y Z (y, z) /
            finiteRandomVariablePushProb μ Z z) =
          ∑ x : β,
            finiteJointProb μ X Z (x, z) *
                (∑ y : γ, finiteJointProb μ Y Z (y, z)) /
                  finiteRandomVariablePushProb μ Z z := by
            apply Finset.sum_congr rfl
            intro x _
            exact hinner x
      _ = (∑ x : β, finiteJointProb μ X Z (x, z)) *
            (∑ y : γ, finiteJointProb μ Y Z (y, z)) /
              finiteRandomVariablePushProb μ Z z := by
            simp_rw [div_eq_mul_inv]
            rw [← Finset.sum_mul, ← Finset.sum_mul]
      _ = finiteRandomVariablePushProb μ Z z * finiteRandomVariablePushProb μ Z z /
            finiteRandomVariablePushProb μ Z z := by
            rw [finiteJointProb_sum_first μ X Z z, finiteJointProb_sum_first μ Y Z z]
      _ = finiteRandomVariablePushProb μ Z z := by
            field_simp

/-- The conditional-product mass is a normalized finite distribution. -/
def finiteConditionalProductDistribution
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    FinDistribution (δ × (β × γ)) where
  prob := finiteConditionalProductProb μ X Y Z
  nonnegative := finiteConditionalProductProb_nonnegative μ X Y Z
  total_mass := by
    rw [Fintype.sum_prod_type]
    simp_rw [finiteConditionalProductProb_fiber_sum μ X Y Z]
    exact finiteRandomVariablePushProb_total_mass μ Z

/-- The actual `(Z,(X,Y))` joint law, on the same carrier as the comparison law. -/
def finiteXYZComparisonDistribution
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    FinDistribution (δ × (β × γ)) :=
  finiteRandomVariablePushDistribution μ (fun a => (Z a, (X a, Y a)))

/-- Point mass of the actual `(Z,(X,Y))` law. -/
theorem finiteXYZComparisonDistribution_prob
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) (y : γ) :
    (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) =
      Finset.univ.sum
        (fun a => if Z a = z ∧ X a = x ∧ Y a = y then μ.prob a else 0) := by
  change finiteRandomVariablePushProb μ (fun a => (Z a, (X a, Y a))) (z, (x, y)) = _
  rw [finiteRandomVariablePushProb_eq_preimage_sum]
  apply Finset.sum_congr rfl
  intro a _
  simp

/-- Mathlib measure for the actual joint law. -/
def finiteXYZComparisonMeasure
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    Measure (δ × (β × γ)) :=
  finDistributionToMeasure (finiteXYZComparisonDistribution μ X Y Z)

/-- Mathlib measure for the conditioned-product comparison law. -/
def finiteConditionalProductMeasure
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    Measure (δ × (β × γ)) :=
  finDistributionToMeasure (finiteConditionalProductDistribution μ X Y Z)

/-- Point masses of the comparison measure are exactly the conditioned-product masses. -/
theorem finiteConditionalProductMeasure_singleton
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (s : δ × (β × γ)) :
    finiteConditionalProductMeasure μ X Y Z {s} =
      ENNReal.ofReal (finiteConditionalProductProb μ X Y Z s) := by
  exact finDistributionToMeasure_singleton (finiteConditionalProductDistribution μ X Y Z) s

/-- Both Gibbs comparison measures have total mass one. -/
theorem finiteXYZComparisonMeasure_univ
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteXYZComparisonMeasure μ X Y Z Set.univ = 1 := by
  exact finDistributionToMeasure_univ (finiteXYZComparisonDistribution μ X Y Z)

theorem finiteConditionalProductMeasure_univ
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteConditionalProductMeasure μ X Y Z Set.univ = 1 := by
  exact finDistributionToMeasure_univ (finiteConditionalProductDistribution μ X Y Z)

def status : String :=
  "FINITE_CONDITIONAL_PRODUCT_GIBBS_COMPARISON_MEASURES_CONSTRUCTED"

def nextAdmissibleObject : String :=
  "FINITE_XYZ_ABSOLUTE_CONTINUITY_WITH_RESPECT_TO_CONDITIONAL_PRODUCT_MEASURE"

end

end URF.Foundation.FiniteConditionalProductGibbsMeasures

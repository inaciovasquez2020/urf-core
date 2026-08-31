import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import URF.Foundation.FiniteXYZAbsoluteContinuity

namespace URF.Foundation.FiniteConditionalGibbsLikelihoodRatio

open MeasureTheory
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDistributionMathlibMeasureBridge
open URF.Foundation.FiniteConditionalProductGibbsMeasures
open URF.Foundation.FiniteXYZAbsoluteContinuity

universe u

noncomputable section

/-- A zero-safe finite KL atom. The zero-mass branch is defined as zero. -/
def finiteConditionalKLAtom (p q : ℝ) : ℝ :=
  if p = 0 then 0 else p * Real.log (p / q)

/--
At every positive atom of the actual `(Z,X,Y)` law, the Mathlib Radon-Nikodym derivative
with respect to the conditional-product comparison law is exactly the finite atom ratio.
-/
theorem finiteXYZComparison_rnDeriv_toReal_eq_ratio_of_positive
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (s : δ × (β × γ))
    (hp : 0 < (finiteXYZComparisonDistribution μ X Y Z).prob s) :
    ((finiteXYZComparisonMeasure μ X Y Z).rnDeriv
      (finiteConditionalProductMeasure μ X Y Z) s).toReal =
      (finiteXYZComparisonDistribution μ X Y Z).prob s /
        finiteConditionalProductProb μ X Y Z s := by
  rcases s with ⟨z, ⟨x, y⟩⟩
  have hq : 0 < finiteConditionalProductProb μ X Y Z (z, (x, y)) :=
    finiteXYZComparisonDistribution_positive_implies_conditionalProduct_positive
      μ X Y Z z x y hp
  have hac :
      finiteXYZComparisonMeasure μ X Y Z ≪
        finiteConditionalProductMeasure μ X Y Z :=
    finiteXYZComparisonMeasure_absolutelyContinuous_conditionalProductMeasure
      μ X Y Z
  have hRN := Measure.setLIntegral_rnDeriv hac
    ({(z, (x, y))} : Set (δ × (β × γ)))
  rw [lintegral_singleton] at hRN
  have hPsingle :
      finiteXYZComparisonMeasure μ X Y Z {(z, (x, y))} =
        ENNReal.ofReal
          ((finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) := by
    simpa [finiteXYZComparisonMeasure] using
      (finDistributionToMeasure_singleton
        (finiteXYZComparisonDistribution μ X Y Z) (z, (x, y)))
  rw [hPsingle,
    finiteConditionalProductMeasure_singleton μ X Y Z (z, (x, y))] at hRN
  have hp0 : 0 ≤ (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) :=
    (finiteXYZComparisonDistribution μ X Y Z).nonnegative (z, (x, y))
  have hq0 : 0 ≤ finiteConditionalProductProb μ X Y Z (z, (x, y)) :=
    finiteConditionalProductProb_nonnegative μ X Y Z (z, (x, y))
  have hreal := congrArg ENNReal.toReal hRN
  simp only [ENNReal.toReal_mul, ENNReal.toReal_ofReal hp0,
    ENNReal.toReal_ofReal hq0] at hreal
  exact (eq_div_iff (ne_of_gt hq)).2 hreal

/-- Positive finite atoms have the expected pointwise log-likelihood ratio. -/
theorem finiteXYZComparison_llr_eq_log_ratio_of_positive
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (s : δ × (β × γ))
    (hp : 0 < (finiteXYZComparisonDistribution μ X Y Z).prob s) :
    llr (finiteXYZComparisonMeasure μ X Y Z)
        (finiteConditionalProductMeasure μ X Y Z) s =
      Real.log
        ((finiteXYZComparisonDistribution μ X Y Z).prob s /
          finiteConditionalProductProb μ X Y Z s) := by
  simp only [llr]
  rw [finiteXYZComparison_rnDeriv_toReal_eq_ratio_of_positive μ X Y Z s hp]

/-- The finite log-likelihood ratio is integrable under the actual finite joint law. -/
theorem finiteXYZComparison_llr_integrable
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    Integrable
      (llr (finiteXYZComparisonMeasure μ X Y Z)
        (finiteConditionalProductMeasure μ X Y Z))
      (finiteXYZComparisonMeasure μ X Y Z) := by
  change Integrable
    (llr
      (finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).toMeasure
      (finDistributionToPMF (finiteConditionalProductDistribution μ X Y Z)).toMeasure)
    (finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).toMeasure
  rw [← integrableOn_univ]
  exact IntegrableOn.of_finite Set.toFinite

/--
The Mathlib LLR integral for the actual joint law against the conditional-product comparison law
is exactly the finite zero-safe `p * log (p / q)` sum.
-/
theorem finiteXYZComparison_llr_integral_eq_finiteConditionalKLSum
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∫ s,
      llr (finiteXYZComparisonMeasure μ X Y Z)
        (finiteConditionalProductMeasure μ X Y Z) s
      ∂(finiteXYZComparisonMeasure μ X Y Z)) =
      ∑ s : δ × (β × γ),
        finiteConditionalKLAtom
          ((finiteXYZComparisonDistribution μ X Y Z).prob s)
          (finiteConditionalProductProb μ X Y Z s) := by
  change
    (∫ s,
      llr
        (finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).toMeasure
        (finDistributionToPMF (finiteConditionalProductDistribution μ X Y Z)).toMeasure s
      ∂(finDistributionToPMF (finiteXYZComparisonDistribution μ X Y Z)).toMeasure) = _
  rw [PMF.integral_eq_sum]
  apply Finset.sum_congr rfl
  intro s _
  have hp0 : 0 ≤ (finiteXYZComparisonDistribution μ X Y Z).prob s :=
    (finiteXYZComparisonDistribution μ X Y Z).nonnegative s
  by_cases hp : (finiteXYZComparisonDistribution μ X Y Z).prob s = 0
  · simp [finiteConditionalKLAtom, hp, finDistributionToPMF_apply]
  · have hp_pos : 0 < (finiteXYZComparisonDistribution μ X Y Z).prob s :=
      lt_of_le_of_ne hp0 (Ne.symm hp)
    have hllr := finiteXYZComparison_llr_eq_log_ratio_of_positive
      μ X Y Z s hp_pos
    rw [hllr]
    simp [finiteConditionalKLAtom, hp, finDistributionToPMF_apply, hp0, smul_eq_mul]

def status : String :=
  "FINITE_CONDITIONAL_GIBBS_LLR_IDENTIFIED_WITH_FINITE_KL_SUM"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_GIBBS_INEQUALITY_APPLICATION"

end

end URF.Foundation.FiniteConditionalGibbsLikelihoodRatio

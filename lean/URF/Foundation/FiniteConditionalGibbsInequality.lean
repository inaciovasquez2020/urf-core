import URF.Foundation.FiniteConditionalGibbsLikelihoodRatio

namespace URF.Foundation.FiniteConditionalGibbsInequality

open MeasureTheory
open InformationTheory
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteConditionalProductGibbsMeasures
open URF.Foundation.FiniteXYZAbsoluteContinuity
open URF.Foundation.FiniteConditionalGibbsLikelihoodRatio

universe u

noncomputable section

/--
Gibbs' inequality for the concrete finite conditional-product comparison law.
The two measures are probability measures, so Mathlib's finite-measure mass
correction cancels, and the verified LLR integral is exactly the finite KL sum.
-/
theorem finiteConditionalKLSum_nonnegative
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    [MeasurableSpace (δ × (β × γ))]
    [MeasurableSingletonClass (δ × (β × γ))]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    0 ≤ ∑ s : δ × (β × γ),
      finiteConditionalKLAtom
        ((finiteXYZComparisonDistribution μ X Y Z).prob s)
        (finiteConditionalProductProb μ X Y Z s) := by
  have hac :
      finiteXYZComparisonMeasure μ X Y Z ≪
        finiteConditionalProductMeasure μ X Y Z :=
    finiteXYZComparisonMeasure_absolutelyContinuous_conditionalProductMeasure
      μ X Y Z
  have hint :
      Integrable
        (llr (finiteXYZComparisonMeasure μ X Y Z)
          (finiteConditionalProductMeasure μ X Y Z))
        (finiteXYZComparisonMeasure μ X Y Z) :=
    finiteXYZComparison_llr_integrable μ X Y Z
  have hgibbs :=
    InformationTheory.integral_llr_add_sub_measure_univ_nonneg hac hint
  have hPReal :
      (finiteXYZComparisonMeasure μ X Y Z).real Set.univ = 1 := by
    rw [measureReal_def, finiteXYZComparisonMeasure_univ μ X Y Z]
    simp
  have hQReal :
      (finiteConditionalProductMeasure μ X Y Z).real Set.univ = 1 := by
    rw [measureReal_def, finiteConditionalProductMeasure_univ μ X Y Z]
    simp
  have hIntegral :
      0 ≤ ∫ s,
        llr (finiteXYZComparisonMeasure μ X Y Z)
          (finiteConditionalProductMeasure μ X Y Z) s
        ∂(finiteXYZComparisonMeasure μ X Y Z) := by
    simpa [hPReal, hQReal] using hgibbs
  rw [finiteXYZComparison_llr_integral_eq_finiteConditionalKLSum μ X Y Z] at hIntegral
  exact hIntegral

def status : String :=
  "FINITE_CONDITIONAL_GIBBS_KL_SUM_NONNEGATIVE"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_KL_SUM_TO_ENTROPY_SUBMODULARITY_GAP"

end

end URF.Foundation.FiniteConditionalGibbsInequality

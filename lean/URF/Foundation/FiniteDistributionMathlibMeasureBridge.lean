import Mathlib.Probability.ProbabilityMassFunction.Basic
import URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

namespace URF.Foundation.FiniteDistributionMathlibMeasureBridge

open MeasureTheory
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

universe u

noncomputable section

/--
Embed a repository-native finite probability distribution as a Mathlib `PMF`.
The mass at `a` is exactly `ENNReal.ofReal (μ.prob a)`.
-/
def finDistributionToPMF
    {α : Type u}
    [DecidableEq α] [Fintype α]
    (μ : FinDistribution α) : PMF α :=
  ⟨fun a => ENNReal.ofReal (μ.prob a), by
    have hsum : (∑ a : α, ENNReal.ofReal (μ.prob a)) = 1 := by
      have hofreal :
          ENNReal.ofReal (∑ a : α, μ.prob a) =
            ∑ a : α, ENNReal.ofReal (μ.prob a) := by
        simpa using
          (ENNReal.ofReal_sum_of_nonneg
            (s := Finset.univ) (f := μ.prob)
            (fun a _ => μ.nonnegative a))
      rw [← hofreal, μ.total_mass]
      simp
    rw [← hsum]
    exact hasSum_fintype (fun a : α => ENNReal.ofReal (μ.prob a))⟩

@[simp]
theorem finDistributionToPMF_apply
    {α : Type u}
    [DecidableEq α] [Fintype α]
    (μ : FinDistribution α) (a : α) :
    finDistributionToPMF μ a = ENNReal.ofReal (μ.prob a) := by
  rfl

/--
Embed a repository-native finite probability distribution as a Mathlib measure
through the verified PMF above.
-/
def finDistributionToMeasure
    {α : Type u}
    [DecidableEq α] [Fintype α]
    [MeasurableSpace α]
    (μ : FinDistribution α) : Measure α :=
  (finDistributionToPMF μ).toMeasure

/-- Singleton measure agrees exactly with the repository probability mass. -/
theorem finDistributionToMeasure_singleton
    {α : Type u}
    [DecidableEq α] [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (μ : FinDistribution α) (a : α) :
    finDistributionToMeasure μ {a} = ENNReal.ofReal (μ.prob a) := by
  rw [finDistributionToMeasure]
  exact (finDistributionToPMF μ).toMeasure_apply_singleton a (measurableSet_singleton a)

/-- The embedded measure has total mass one. -/
theorem finDistributionToMeasure_univ
    {α : Type u}
    [DecidableEq α] [Fintype α]
    [MeasurableSpace α]
    (μ : FinDistribution α) :
    finDistributionToMeasure μ Set.univ = 1 := by
  rw [finDistributionToMeasure, PMF.toMeasure_apply (finDistributionToPMF μ) MeasurableSet.univ]
  simp

def status : String :=
  "FINITE_DISTRIBUTION_EMBEDDED_AS_MATHLIB_PMF_AND_MEASURE"

def nextAdmissibleObject : String :=
  "FINITE_SHANNON_TERM_TO_MATHLIB_NEG_MUL_LOG_BRIDGE"

end

end URF.Foundation.FiniteDistributionMathlibMeasureBridge

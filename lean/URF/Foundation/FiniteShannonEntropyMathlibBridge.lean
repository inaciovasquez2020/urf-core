import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import URF.Foundation.FiniteDiscreteShannonEntropy
import URF.Foundation.FiniteDistributionMathlibMeasureBridge

namespace URF.Foundation.FiniteShannonEntropyMathlibBridge

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteDistributionMathlibMeasureBridge

universe u

noncomputable section

/-- The repository zero-safe Shannon summand is exactly Mathlib's `Real.negMulLog`. -/
theorem shannonTerm_eq_negMulLog (p : ℝ) :
    shannonTerm p = Real.negMulLog p := by
  by_cases hp : p = 0
  · subst p
    simp [shannonTerm, Real.negMulLog]
  · simp only [shannonTerm, hp, if_false, Real.negMulLog]
    ring

/-- Finite repository Shannon entropy is the finite sum of Mathlib `Real.negMulLog`. -/
theorem finiteShannonEntropy_eq_sum_negMulLog
    {α : Type u}
    [DecidableEq α] [Fintype α]
    (μ : FinDistribution α) :
    finiteShannonEntropy μ =
      Finset.univ.sum (fun a => Real.negMulLog (μ.prob a)) := by
  unfold finiteShannonEntropy
  apply Finset.sum_congr rfl
  intro a _
  exact shannonTerm_eq_negMulLog (μ.prob a)

/-- The embedded Mathlib measure recovers each finite mass after `ENNReal.toReal`. -/
theorem finDistributionToMeasure_singleton_toReal
    {α : Type u}
    [DecidableEq α] [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (μ : FinDistribution α) (a : α) :
    (finDistributionToMeasure μ {a}).toReal = μ.prob a := by
  rw [finDistributionToMeasure_singleton]
  simp [μ.nonnegative a]

/--
Finite Shannon entropy can therefore be read directly from the singleton masses
of the embedded Mathlib measure.
-/
theorem finiteShannonEntropy_eq_measure_singleton_negMulLog_sum
    {α : Type u}
    [DecidableEq α] [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (μ : FinDistribution α) :
    finiteShannonEntropy μ =
      Finset.univ.sum
        (fun a => Real.negMulLog ((finDistributionToMeasure μ {a}).toReal)) := by
  rw [finiteShannonEntropy_eq_sum_negMulLog]
  apply Finset.sum_congr rfl
  intro a _
  rw [finDistributionToMeasure_singleton_toReal]

def status : String :=
  "FINITE_SHANNON_ENTROPY_CONNECTED_TO_MATHLIB_NEG_MUL_LOG_AND_MEASURE_SINGLETONS"

def nextAdmissibleObject : String :=
  "FINITE_ENTROPY_SUBMODULARITY_DERIVATION_FROM_MATHLIB_GIBBS_KL"

end

end URF.Foundation.FiniteShannonEntropyMathlibBridge

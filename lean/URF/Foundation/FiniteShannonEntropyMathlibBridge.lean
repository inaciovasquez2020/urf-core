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

/--
A probability distribution on a nonempty finite alphabet has Shannon entropy at
most the logarithm of the alphabet cardinality.  The proof sums Mathlib's
pointwise inequality `negMulLog x ≤ 1 - x` at `x = |α| p(a)` and uses the
verified unit total mass of the repository-native finite distribution.
-/
theorem finiteShannonEntropy_le_log_card
    {α : Type u}
    [DecidableEq α] [Fintype α] [Nonempty α]
    (μ : FinDistribution α) :
    finiteShannonEntropy μ ≤ Real.log (Fintype.card α) := by
  let n : ℝ := Fintype.card α
  have hnCard : 0 < Fintype.card α := Fintype.card_pos
  have hn : 0 < n := by
    dsimp [n]
    exact_mod_cast hnCard
  have hsum :
      (∑ a : α, Real.negMulLog (n * μ.prob a)) ≤
        ∑ a : α, (1 - n * μ.prob a) := by
    apply Finset.sum_le_sum
    intro a _
    exact Real.negMulLog_le_one_sub_self
      (mul_nonneg hn.le (μ.nonnegative a))
  have hleft :
      (∑ a : α, Real.negMulLog (n * μ.prob a)) =
        Real.negMulLog n + n * finiteShannonEntropy μ := by
    rw [finiteShannonEntropy_eq_sum_negMulLog]
    simp_rw [Real.negMulLog_mul]
    rw [Finset.sum_add_distrib]
    rw [← Finset.sum_mul]
    rw [← Finset.mul_sum]
    rw [μ.total_mass]
    ring
  have hright :
      (∑ a : α, (1 - n * μ.prob a)) = 0 := by
    rw [Finset.sum_sub_distrib]
    rw [← Finset.mul_sum]
    rw [μ.total_mass]
    simp [n]
  have hmain :
      Real.negMulLog n + n * finiteShannonEntropy μ ≤ 0 := by
    calc
      Real.negMulLog n + n * finiteShannonEntropy μ =
          ∑ a : α, Real.negMulLog (n * μ.prob a) := hleft.symm
      _ ≤ ∑ a : α, (1 - n * μ.prob a) := hsum
      _ = 0 := hright
  have hscaled :
      n * finiteShannonEntropy μ ≤ n * Real.log n := by
    simp only [Real.negMulLog] at hmain
    nlinarith
  have hfinal := (mul_le_mul_left hn).mp hscaled
  simpa [n] using hfinal

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

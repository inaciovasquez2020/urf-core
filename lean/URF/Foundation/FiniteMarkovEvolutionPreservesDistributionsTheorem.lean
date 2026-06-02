import URF.Foundation.FiniteStochasticKernelMassConservationTheorem

namespace URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

open URF.Foundation.FlagshipFiniteKernelTheoremSurface
open URF.Foundation.FiniteStochasticKernelMassConservationTheorem

universe u

structure FinDistribution (α : Type u) [DecidableEq α] [Fintype α] where
  prob : α → ℝ
  nonnegative : ∀ a : α, 0 ≤ prob a
  total_mass : Finset.univ.sum prob = 1

def pushProb
    {α β : Type u} [DecidableEq α] [Fintype α] [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (K : FinKernel α β) : β → ℝ :=
  fun b => Finset.univ.sum (fun a => μ.prob a * (K.transition a).prob b)

theorem finite_markov_evolution_nonnegative
    {α β : Type u} [DecidableEq α] [Fintype α] [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (K : FinKernel α β) :
    ∀ b : β, 0 ≤ pushProb μ K b := by
  intro b
  unfold pushProb
  exact Finset.sum_nonneg
    (fun a _ => mul_nonneg (μ.nonnegative a)
      (finite_stochastic_kernel_nonnegative_transition K a b))

theorem finite_markov_evolution_total_mass
    {α β : Type u} [DecidableEq α] [Fintype α] [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (K : FinKernel α β) :
    Finset.univ.sum (pushProb μ K) = 1 := by
  unfold pushProb
  calc
    Finset.univ.sum
        (fun b => Finset.univ.sum
          (fun a => μ.prob a * (K.transition a).prob b))
        =
        Finset.univ.sum
          (fun a => Finset.univ.sum
            (fun b => μ.prob a * (K.transition a).prob b)) := by
          exact Finset.sum_comm
    _ =
        Finset.univ.sum
          (fun a => μ.prob a *
            Finset.univ.sum (fun b => (K.transition a).prob b)) := by
          apply Finset.sum_congr rfl
          intro a _
          rw [← Finset.mul_sum]
    _ = Finset.univ.sum (fun a => μ.prob a * 1) := by
          apply Finset.sum_congr rfl
          intro a _
          rw [finite_stochastic_kernel_mass_conservation K a]
    _ = 1 := by
          simpa [μ.total_mass]

def pushDistribution
    {α β : Type u} [DecidableEq α] [Fintype α] [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (K : FinKernel α β) : FinDistribution β where
  prob := pushProb μ K
  nonnegative := finite_markov_evolution_nonnegative μ K
  total_mass := finite_markov_evolution_total_mass μ K

theorem finite_markov_evolution_preserves_probability_distribution
    {α β : Type u} [DecidableEq α] [Fintype α] [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (K : FinKernel α β) :
    (∀ b : β, 0 ≤ pushProb μ K b) ∧
      Finset.univ.sum (pushProb μ K) = 1 := by
  exact ⟨
    finite_markov_evolution_nonnegative μ K,
    finite_markov_evolution_total_mass μ K
  ⟩

end URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

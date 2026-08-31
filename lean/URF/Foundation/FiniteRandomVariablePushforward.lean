import URF.Foundation.FiniteAccumulatingTranscriptProbabilityModel
import URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

namespace URF.Foundation.FiniteRandomVariablePushforward

open URF.Foundation.FlagshipFiniteKernelTheoremSurface
open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

universe u

/-- A finite-valued random variable as a deterministic stochastic kernel. -/
def deterministicRandomVariableKernel
    {α β : Type u}
    [DecidableEq β] [Fintype β]
    (X : α → β) : FinKernel α β where
  transition := fun a =>
    { prob := fun b => if X a = b then 1 else 0
      nonneg := by
        intro b
        by_cases h : X a = b <;> simp [h]
      sum_one := by
        classical
        simp }

/-- The pushforward mass function of a finite random variable. -/
def finiteRandomVariablePushProb
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) : β → ℝ :=
  pushProb μ (deterministicRandomVariableKernel X)

theorem finiteRandomVariablePushProb_eq_preimage_sum
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) (b : β) :
    finiteRandomVariablePushProb μ X b =
      Finset.univ.sum (fun a => if X a = b then μ.prob a else 0) := by
  unfold finiteRandomVariablePushProb pushProb
  apply Finset.sum_congr rfl
  intro a _
  by_cases h : X a = b <;>
    simp [deterministicRandomVariableKernel, h]

/-- Injective recoding preserves pushforward mass at every image point. -/
theorem finiteRandomVariablePushProb_comp_injective
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (f : β → γ)
    (hf : Function.Injective f) (b : β) :
    finiteRandomVariablePushProb μ (fun a => f (X a)) (f b) =
      finiteRandomVariablePushProb μ X b := by
  rw [finiteRandomVariablePushProb_eq_preimage_sum,
    finiteRandomVariablePushProb_eq_preimage_sum]
  apply Finset.sum_congr rfl
  intro a _
  by_cases h : X a = b
  · subst b
    simp
  · have h' : f (X a) ≠ f b := by
      intro hfb
      exact h (hf hfb)
    simp [h, h']

theorem finiteRandomVariablePushProb_nonnegative
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) :
    ∀ b : β, 0 ≤ finiteRandomVariablePushProb μ X b := by
  exact finite_markov_evolution_nonnegative μ
    (deterministicRandomVariableKernel X)

theorem finiteRandomVariablePushProb_total_mass
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) :
    Finset.univ.sum (finiteRandomVariablePushProb μ X) = 1 := by
  exact finite_markov_evolution_total_mass μ
    (deterministicRandomVariableKernel X)

/-- The bundled finite pushforward distribution of a random variable. -/
def finiteRandomVariablePushDistribution
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) : FinDistribution β :=
  pushDistribution μ (deterministicRandomVariableKernel X)

theorem finiteRandomVariablePushDistribution_prob
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) (b : β) :
    (finiteRandomVariablePushDistribution μ X).prob b =
      finiteRandomVariablePushProb μ X b := by
  rfl

def status : String :=
  "FINITE_RANDOM_VARIABLE_PUSHFORWARD_DISTRIBUTION_DERIVED"

def nextAdmissibleObject : String :=
  "FINITE_DISCRETE_SHANNON_ENTROPY_DEFINITION"

end URF.Foundation.FiniteRandomVariablePushforward

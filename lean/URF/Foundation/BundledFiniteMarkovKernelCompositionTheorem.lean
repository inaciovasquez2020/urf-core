import URF.Foundation.FiniteMarkovKernelCompositionPreservesStochasticityTheorem

namespace URF.Foundation.BundledFiniteMarkovKernelCompositionTheorem

open URF.Foundation.FlagshipFiniteKernelTheoremSurface
open URF.Foundation.FiniteMarkovKernelCompositionPreservesStochasticityTheorem

universe u

def composedFinKernel
    {α β γ : Type u}
    [DecidableEq γ] [Fintype γ] [DecidableEq β] [Fintype β]
    (K : FinKernel α β) (L : FinKernel β γ) : FinKernel α γ where
  transition := fun a =>
    { prob := composedKernelProb K L a
      nonneg := finite_markov_kernel_composition_nonnegative K L a
      sum_one := finite_markov_kernel_composition_total_mass K L a }

theorem composed_fin_kernel_transition_eq
    {α β γ : Type u}
    [DecidableEq γ] [Fintype γ] [DecidableEq β] [Fintype β]
    (K : FinKernel α β) (L : FinKernel β γ) :
    ∀ (a : α) (c : γ),
      ((composedFinKernel K L).transition a).prob c =
        composedKernelProb K L a c := by
  intro a c
  rfl

theorem bundled_finite_markov_kernel_composition_nonnegative
    {α β γ : Type u}
    [DecidableEq γ] [Fintype γ] [DecidableEq β] [Fintype β]
    (K : FinKernel α β) (L : FinKernel β γ) :
    ∀ (a : α) (c : γ),
      0 ≤ ((composedFinKernel K L).transition a).prob c := by
  intro a c
  exact finite_markov_kernel_composition_nonnegative K L a c

theorem bundled_finite_markov_kernel_composition_total_mass
    {α β γ : Type u}
    [DecidableEq γ] [Fintype γ] [DecidableEq β] [Fintype β]
    (K : FinKernel α β) (L : FinKernel β γ) :
    ∀ a : α,
      Finset.univ.sum ((composedFinKernel K L).transition a).prob = 1 := by
  intro a
  exact finite_markov_kernel_composition_total_mass K L a

theorem bundled_finite_markov_kernel_composition_is_stochastic
    {α β γ : Type u}
    [DecidableEq γ] [Fintype γ] [DecidableEq β] [Fintype β]
    (K : FinKernel α β) (L : FinKernel β γ) :
    (∀ (a : α) (c : γ),
      0 ≤ ((composedFinKernel K L).transition a).prob c) ∧
      (∀ a : α,
        Finset.univ.sum ((composedFinKernel K L).transition a).prob = 1) := by
  exact ⟨
    bundled_finite_markov_kernel_composition_nonnegative K L,
    bundled_finite_markov_kernel_composition_total_mass K L
  ⟩

end URF.Foundation.BundledFiniteMarkovKernelCompositionTheorem

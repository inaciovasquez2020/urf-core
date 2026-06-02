import URF.Foundation.FiniteStochasticKernelMassConservationTheorem

namespace URF.Foundation.FiniteMarkovKernelCompositionPreservesStochasticityTheorem

open URF.Foundation.FlagshipFiniteKernelTheoremSurface
open URF.Foundation.FiniteStochasticKernelMassConservationTheorem

universe u

def composedKernelProb
    {α β γ : Type u}
    [DecidableEq β] [Fintype β] [DecidableEq γ] [Fintype γ]
    (K : FinKernel α β) (L : FinKernel β γ) (a : α) : γ → ℝ :=
  fun c => Finset.univ.sum (fun b => (K.transition a).prob b * (L.transition b).prob c)

theorem finite_markov_kernel_composition_nonnegative
    {α β γ : Type u}
    [DecidableEq β] [Fintype β] [DecidableEq γ] [Fintype γ]
    (K : FinKernel α β) (L : FinKernel β γ) :
    ∀ (a : α) (c : γ), 0 ≤ composedKernelProb K L a c := by
  intro a c
  unfold composedKernelProb
  exact Finset.sum_nonneg
    (fun b _ => mul_nonneg
      (finite_stochastic_kernel_nonnegative_transition K a b)
      (finite_stochastic_kernel_nonnegative_transition L b c))

theorem finite_markov_kernel_composition_total_mass
    {α β γ : Type u}
    [DecidableEq β] [Fintype β] [DecidableEq γ] [Fintype γ]
    (K : FinKernel α β) (L : FinKernel β γ) :
    ∀ a : α, Finset.univ.sum (composedKernelProb K L a) = 1 := by
  intro a
  unfold composedKernelProb
  calc
    Finset.univ.sum
        (fun c => Finset.univ.sum
          (fun b => (K.transition a).prob b * (L.transition b).prob c))
        =
        Finset.univ.sum
          (fun b => Finset.univ.sum
            (fun c => (K.transition a).prob b * (L.transition b).prob c)) := by
          exact Finset.sum_comm
    _ =
        Finset.univ.sum
          (fun b => (K.transition a).prob b *
            Finset.univ.sum (fun c => (L.transition b).prob c)) := by
          apply Finset.sum_congr rfl
          intro b _
          rw [← Finset.mul_sum]
    _ = Finset.univ.sum (fun b => (K.transition a).prob b * 1) := by
          apply Finset.sum_congr rfl
          intro b _
          rw [finite_stochastic_kernel_mass_conservation L b]
    _ = 1 := by
          simp [finite_stochastic_kernel_mass_conservation K a]

theorem finite_markov_kernel_composition_preserves_stochasticity
    {α β γ : Type u}
    [DecidableEq β] [Fintype β] [DecidableEq γ] [Fintype γ]
    (K : FinKernel α β) (L : FinKernel β γ) :
    (∀ (a : α) (c : γ), 0 ≤ composedKernelProb K L a c) ∧
      (∀ a : α, Finset.univ.sum (composedKernelProb K L a) = 1) := by
  exact ⟨
    finite_markov_kernel_composition_nonnegative K L,
    finite_markov_kernel_composition_total_mass K L
  ⟩

end URF.Foundation.FiniteMarkovKernelCompositionPreservesStochasticityTheorem

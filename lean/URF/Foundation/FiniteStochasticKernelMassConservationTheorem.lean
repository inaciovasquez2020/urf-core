import URF.Foundation.FlagshipFiniteKernelTheoremSurface

namespace URF.Foundation.FiniteStochasticKernelMassConservationTheorem

open URF.Foundation.FlagshipFiniteKernelTheoremSurface

universe u

theorem finite_stochastic_kernel_nonnegative_transition
    {α β : Type u} [DecidableEq β] [Fintype β]
    (K : FinKernel α β) :
    ∀ (a : α) (b : β), 0 ≤ (K.transition a).prob b := by
  exact (flagship_finite_kernel_theorem_surface K).1

theorem finite_stochastic_kernel_mass_conservation
    {α β : Type u} [DecidableEq β] [Fintype β]
    (K : FinKernel α β) :
    ∀ a : α, Finset.univ.sum (K.transition a).prob = 1 := by
  exact (flagship_finite_kernel_theorem_surface K).2

theorem finite_stochastic_kernel_science_field_solution
    {α β : Type u} [DecidableEq β] [Fintype β]
    (K : FinKernel α β) :
    (∀ (a : α) (b : β), 0 ≤ (K.transition a).prob b) ∧
      (∀ a : α, Finset.univ.sum (K.transition a).prob = 1) := by
  exact ⟨
    finite_stochastic_kernel_nonnegative_transition K,
    finite_stochastic_kernel_mass_conservation K
  ⟩

end URF.Foundation.FiniteStochasticKernelMassConservationTheorem

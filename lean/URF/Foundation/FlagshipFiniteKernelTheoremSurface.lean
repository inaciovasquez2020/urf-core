import Mathlib

namespace URF.Foundation.FlagshipFiniteKernelTheoremSurface

structure FinDist (β : Type u) [DecidableEq β] [Fintype β] where
  prob : β → ℝ
  nonneg : ∀ b : β, 0 ≤ prob b
  sum_one : Finset.sum Finset.univ prob = 1

structure FinKernel (α β : Type u) [DecidableEq β] [Fintype β] where
  transition : α → FinDist β

theorem flagship_finite_kernel_theorem_surface
    {α β : Type u}
    [DecidableEq β] [Fintype β]
    (K : FinKernel α β) :
    (∀ (a : α) (b : β), 0 ≤ (K.transition a).prob b) ∧
    (∀ (a : α), Finset.sum Finset.univ (K.transition a).prob = 1) := by
  constructor
  · intro a b
    exact (K.transition a).nonneg b
  · intro a
    exact (K.transition a).sum_one

end URF.Foundation.FlagshipFiniteKernelTheoremSurface

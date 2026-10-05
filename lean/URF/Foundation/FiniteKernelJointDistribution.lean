import Mathlib
import URF.Foundation.FiniteMutualInformation
import URF.Foundation.FlagshipFiniteKernelTheoremSurface

namespace URF.Foundation

open URF.Foundation.FlagshipFiniteKernelTheoremSurface

noncomputable def finiteKernelJointDistribution
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β) :
    FiniteMutualInformationData α β where
  joint := fun p => input.prob p.1 * (K.transition p.1).prob p.2
  nonneg := by
    intro p
    exact mul_nonneg (input.nonneg p.1) ((K.transition p.1).nonneg p.2)
  sum_one := by
    simp only [Finset.sum_product]
    calc
      ∑ x, ∑ y, input.prob x * (K.transition x).prob y =
          ∑ x, input.prob x * ∑ y, (K.transition x).prob y := by
            apply Finset.sum_congr rfl
            intro x hx
            rw [Finset.mul_sum]
      _ = ∑ x, input.prob x := by
            apply Finset.sum_congr rfl
            intro x hx
            rw [(K.transition x).sum_one]
            simp
      _ = 1 := input.sum_one

theorem finiteKernelJointDistribution_nonneg
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β) :
    ∀ p : α × β, 0 ≤ (finiteKernelJointDistribution input K).joint p := by
  intro p
  exact (finiteKernelJointDistribution input K).nonneg p

theorem finiteKernelJointDistribution_sum_one
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β) :
    ∑ p, (finiteKernelJointDistribution input K).joint p = 1 :=
  (finiteKernelJointDistribution input K).sum_one

end URF.Foundation

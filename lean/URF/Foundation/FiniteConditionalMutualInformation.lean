import Mathlib
import URF.Foundation.FiniteMutualInformation

namespace URF.Foundation

structure FiniteConditionalMutualInformationData
    (α β γ : Type u)
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ] where
  condition : γ → FiniteMutualInformationData α β
  weight : γ → ℝ
  weight_nonneg : ∀ z, 0 ≤ weight z
  weight_sum_one : ∑ z, weight z = 1

noncomputable def finiteConditionalMutualInformation
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : FiniteConditionalMutualInformationData α β γ) : ℝ :=
  ∑ z, P.weight z * finiteMutualInformation (P.condition z)

theorem finiteConditionalMutualInformation_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : FiniteConditionalMutualInformationData α β γ) :
    0 ≤ finiteConditionalMutualInformation P := by
  unfold finiteConditionalMutualInformation
  apply Finset.sum_nonneg
  intro z hz
  exact mul_nonneg
    (P.weight_nonneg z)
    (finiteMutualInformation_nonneg (P.condition z))

end URF.Foundation

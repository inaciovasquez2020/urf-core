import Mathlib
import URF.Foundation.FiniteMutualInformation

namespace URF.Foundation

structure JointFiniteDistributionData
    (α β γ : Type u)
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ] where
  joint : α × β × γ → ℝ
  nonneg : ∀ p, 0 ≤ joint p
  sum_one : ∑ p, joint p = 1

noncomputable def jointWeight
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) (z : γ) : ℝ :=
  ∑ p : α × β, P.joint (p.1, p.2, z)

theorem jointWeight_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) (z : γ) :
    0 ≤ jointWeight P z := by
  unfold jointWeight
  exact Finset.sum_nonneg (fun p _ => P.nonneg (p.1, p.2, z))

theorem jointWeight_sum_one
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    ∑ z, jointWeight P z = 1 := by
  unfold jointWeight
  simpa [Finset.sum_product] using P.sum_one

noncomputable def jointConditional
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) (z : γ) :
    α × β → ℝ :=
  fun p => P.joint (p.1, p.2, z) / jointWeight P z

theorem jointConditional_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) (z : γ) (p : α × β) :
    0 ≤ jointConditional P z p := by
  unfold jointConditional
  exact div_nonneg (P.nonneg (p.1, p.2, z)) (jointWeight_nonneg P z)

theorem jointConditional_sum_one_of_pos
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) (z : γ)
    (hz : 0 < jointWeight P z) :
    ∑ p : α × β, jointConditional P z p = 1 := by
  unfold jointConditional
  rw [Finset.sum_div]
  rw [show (∑ p : α × β, P.joint (p.1, p.2, z)) = jointWeight P z by rfl]
  exact div_self (ne_of_gt hz)

noncomputable def jointConditionalMI
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) : ℝ :=
  ∑ z, jointWeight P z *
    if hz : jointWeight P z = 0 then 0 else
      finiteMutualInformation
        { joint := jointConditional P z
          nonneg := jointConditional_nonneg P z
          sum_one := jointConditional_sum_one_of_pos P z (lt_of_le_of_ne
            (jointWeight_nonneg P z) (Ne.symm hz)) }

theorem jointConditionalMI_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    0 ≤ jointConditionalMI P := by
  unfold jointConditionalMI
  apply Finset.sum_nonneg
  intro z hz
  split_ifs with hz0
  · simp [hz0]
  · exact mul_nonneg (jointWeight_nonneg P z)
      (finiteMutualInformation_nonneg _)

end URF.Foundation

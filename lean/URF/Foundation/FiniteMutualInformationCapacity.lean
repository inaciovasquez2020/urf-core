import Mathlib
import URF.Foundation.FiniteMutualInformation
import URF.Foundation.ConcreteFiniteShannonEntropy
import URF.Foundation.FiniteShannonEntropyCapacity

namespace URF.Foundation

noncomputable def finiteMarginalX
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) (x : α) : ℝ :=
  ∑ y, P.joint (x, y)

noncomputable def finiteConditionalXGivenY
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) (y : β) (x : α) : ℝ :=
  P.joint (x, y) / (∑ x', P.joint (x', y))

noncomputable def finiteConditionalEntropyXGivenY
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) : ℝ :=
  ∑ y, (∑ x, P.joint (x, y)) *
    ∑ x, Real.negMulLog (finiteConditionalXGivenY P y x)

theorem finiteConditionalEntropyXGivenY_nonneg
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    0 ≤ finiteConditionalEntropyXGivenY P := by
  unfold finiteConditionalEntropyXGivenY
  apply Finset.sum_nonneg
  intro y hy
  apply mul_nonneg
  · exact Finset.sum_nonneg (fun x _ => P.nonneg (x, y))
  · apply Finset.sum_nonneg
    intro x hx
    apply Real.negMulLog_nonneg
    · exact div_nonneg (P.nonneg (x, y))
        (Finset.sum_nonneg (fun x' _ => P.nonneg (x', y)))
    · have hle : P.joint (x, y) ≤ ∑ x', P.joint (x', y) := by
        exact Finset.single_le_sum
          (s := (Finset.univ : Finset α))
          (fun x' _ => P.nonneg (x', y))
          (Finset.mem_univ x)
      exact div_le_one_of_le
        (Finset.sum_nonneg (fun x' _ => P.nonneg (x', y))) hle

theorem finiteMutualInformation_le_log_card_left
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤ Real.log (Fintype.card α) := by
  sorry

end URF.Foundation

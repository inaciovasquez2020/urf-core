import Mathlib
import URF.Foundation.FiniteMutualInformation
import URF.Foundation.ConcreteFiniteShannonEntropy
import URF.Foundation.FiniteShannonEntropyCapacity

namespace URF.Foundation

noncomputable def finiteMarginalX
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) (x : α) : ℝ :=
  ∑ y, P.joint (x, y)

noncomputable def finiteMarginalY
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) (y : β) : ℝ :=
  ∑ x, P.joint (x, y)

noncomputable def finiteConditionalXGivenY
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) (y : β) (x : α) : ℝ :=
  P.joint (x, y) / finiteMarginalY P y

noncomputable def finiteConditionalEntropyXGivenY
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) : ℝ :=
  ∑ y, finiteMarginalY P y *
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
    · exact div_nonneg (P.nonneg (x, y)) (Finset.sum_nonneg
        (fun x' _ => P.nonneg (x', y)))
    · have hle : P.joint (x, y) ≤ ∑ x', P.joint (x', y) := by
        exact Finset.single_le_sum
          (s := (Finset.univ : Finset α))
          (fun x' _ => P.nonneg (x', y))
          (Finset.mem_univ x)
      exact div_le_one_of_le
        (Finset.sum_nonneg (fun x' _ => P.nonneg (x', y))) hle

theorem finiteMutualInformation_eq_marginalEntropy_sub_conditionalEntropy
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P =
      finiteShannonEntropy
        { prob := finiteMarginalX P
          nonneg := fun x => Finset.sum_nonneg (fun y _ => P.nonneg (x, y))
          sum_one := by
            simpa [finiteMarginalX, Finset.sum_product] using P.sum_one } -
      finiteConditionalEntropyXGivenY P := by
  sorry

theorem finiteMutualInformation_le_marginalEntropy_left
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤
      finiteShannonEntropy
        { prob := finiteMarginalX P
          nonneg := fun x => Finset.sum_nonneg (fun y _ => P.nonneg (x, y))
          sum_one := by
            simpa [finiteMarginalX, Finset.sum_product] using P.sum_one } := by
  rw [finiteMutualInformation_eq_marginalEntropy_sub_conditionalEntropy]
  linarith [finiteConditionalEntropyXGivenY_nonneg P]

end URF.Foundation

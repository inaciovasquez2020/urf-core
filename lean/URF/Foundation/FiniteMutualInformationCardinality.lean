import Mathlib
import URF.Foundation.FiniteMutualInformationDecomposition
import URF.Foundation.FiniteShannonEntropyCapacity

namespace URF.Foundation

theorem finiteMutualInformation_le_marginalEntropy_left
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤
      finiteShannonEntropy
        { prob := fun x => ∑ y, P.joint (x, y)
          nonneg := fun x => Finset.sum_nonneg (fun y _ => P.nonneg (x, y))
          sum_one := by
            simpa [Finset.sum_product] using P.sum_one } := by
  rw [finiteMutualInformation_eq_marginalEntropy_sub_conditionalEntropy]
  linarith [finiteConditionalEntropyXGivenY_nonneg P]

theorem finiteMutualInformation_le_log_card_left
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤ Real.log (Fintype.card α) := by
  apply le_trans (finiteMutualInformation_le_marginalEntropy_left P)
  apply finiteShannonEntropy_le_log_card

end URF.Foundation

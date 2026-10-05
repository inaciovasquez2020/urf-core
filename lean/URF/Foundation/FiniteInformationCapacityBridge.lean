import Mathlib
import URF.Foundation.FiniteMutualInformationCardinality

namespace URF.Foundation

theorem finite_information_capacity_bridge
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β)
    (capacity : ℝ)
    (hcapacity : Real.log (Fintype.card α) ≤ capacity) :
    finiteMutualInformation P ≤ capacity := by
  exact le_trans (finiteMutualInformation_le_log_card_left P) hcapacity

end URF.Foundation

import Mathlib
import URF.Foundation.FiniteKernelJointDistribution
import URF.Foundation.FiniteMutualInformationCardinality

namespace URF.Foundation

open URF.Foundation.FlagshipFiniteKernelTheoremSurface

theorem finiteKernelJointDistribution_mutualInformation_le_log_card_left
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β) :
    finiteMutualInformation (finiteKernelJointDistribution input K)
      ≤ Real.log (Fintype.card α) :=
  finiteMutualInformation_le_log_card_left (finiteKernelJointDistribution input K)

end URF.Foundation

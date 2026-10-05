import Mathlib
import URF.Foundation.FiniteInformationCapacityBridge
import URF.Foundation.FiniteKernelJointDistribution

namespace URF.Foundation

open URF.Foundation.FlagshipFiniteKernelTheoremSurface

theorem finiteKernelJointDistribution_le_capacity
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β)
    (capacity : ℝ)
    (hcapacity : Real.log (Fintype.card α) ≤ capacity) :
    finiteMutualInformation (finiteKernelJointDistribution input K) ≤ capacity :=
  finite_information_capacity_bridge
    (finiteKernelJointDistribution input K)
    capacity
    hcapacity

end URF.Foundation

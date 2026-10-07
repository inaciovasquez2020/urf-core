import URF.Foundation.ValidURFKernelPredicate

namespace URF.Foundation

/-- Finite chain rule plus the explicit local capacity bound gives the
standard time-times-capacity estimate. -/
theorem ValidURFFiniteKernel.total_mi_le_time_capacity
    (K : ValidURFFiniteKernel) :
    K.chain.totalMI ≤ K.chain.T * K.channelCapacity := by
  rw [K.chain.finite_chain_rule, K.localSum_eq_sum]
  have hterm : ∀ t ∈ Finset.range K.chain.T,
      K.chain.localCMIValue t ≤ K.channelCapacity := by
    intro t ht
    exact K.perStepCapacityBound t (Finset.mem_range.mp ht)
  calc
    ∑ t in Finset.range K.chain.T, K.chain.localCMIValue t ≤
        ∑ _t in Finset.range K.chain.T, K.channelCapacity :=
      Finset.sum_le_sum hterm
    _ = K.chain.T * K.channelCapacity := by simp

end URF.Foundation

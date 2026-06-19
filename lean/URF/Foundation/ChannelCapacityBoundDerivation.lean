import URF.Foundation.FiniteMutualInformationChainRuleProof

namespace URF

structure ChannelCapacityBoundDerivation where
  finiteChain : FiniteMutualInformationChainRuleProof
  channelCapacity : ℝ
  finite_capacity_bound :
    finiteChain.finiteLocalSum finiteChain.T finiteChain.localCMIValue ≤ channelCapacity
  global_kernel_required : Prop
  law3_required : Prop

theorem channel_capacity_bound_derivation
    (K : ChannelCapacityBoundDerivation) :
    K.finiteChain.totalMI ≤ K.channelCapacity := by
  rw [K.finiteChain.finite_chain_rule]
  exact K.finite_capacity_bound

theorem channel_capacity_bound_derivation_local_nonneg
    (K : ChannelCapacityBoundDerivation)
    (t : Nat) :
    0 ≤ K.finiteChain.localCMIValue t :=
  K.finiteChain.cmi_nonneg t

def ChannelCapacityBoundDerivation.status : String :=
  "CHANNEL_CAPACITY_BOUND_DERIVATION_CLOSED_CONDITIONAL_ON_FINITE_CAPACITY_BOUND_NO_GLOBAL_KERNEL"

def ChannelCapacityBoundDerivation.nextAdmissibleObject : String :=
  "GLOBAL_VALID_KERNEL_THEOREM"

end URF

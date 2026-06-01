import URF.Foundation.ChannelCapacityBoundDerivation

namespace URF

structure GlobalValidKernelTheorem where
  channelDerivation : ChannelCapacityBoundDerivation
  validKernel : Prop
  kernel_valid : validKernel
  kernel_capacity_soundness :
    validKernel →
      channelDerivation.finiteChain.finiteLocalSum
        channelDerivation.finiteChain.T
        channelDerivation.finiteChain.localCMIValue ≤
      channelDerivation.channelCapacity
  law3_required : Prop
  probability_measure_derivation_required : Prop

theorem global_valid_kernel_theorem
    (K : GlobalValidKernelTheorem) :
    K.channelDerivation.finiteChain.totalMI ≤
      K.channelDerivation.channelCapacity := by
  rw [K.channelDerivation.finiteChain.finite_chain_rule]
  exact K.kernel_capacity_soundness K.kernel_valid

theorem global_valid_kernel_theorem_local_nonneg
    (K : GlobalValidKernelTheorem)
    (t : Nat) :
    0 ≤ K.channelDerivation.finiteChain.localCMIValue t :=
  K.channelDerivation.finiteChain.cmi_nonneg t

def GlobalValidKernelTheorem.status : String :=
  "GLOBAL_VALID_KERNEL_THEOREM_CLOSED_CONDITIONAL_ON_KERNEL_CAPACITY_SOUNDNESS_NO_GLOBAL_LAW3"

def GlobalValidKernelTheorem.nextAdmissibleObject : String :=
  "GLOBAL_URF_LAW3"

end URF

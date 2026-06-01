# GLOBAL_VALID_KERNEL_THEOREM_2026_05_31

Status: `GLOBAL_VALID_KERNEL_THEOREM_CLOSED_CONDITIONAL_ON_KERNEL_CAPACITY_SOUNDNESS_NO_GLOBAL_LAW3`

## Object

```lean
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
Lean theorem
theorem global_valid_kernel_theorem
    (K : GlobalValidKernelTheorem) :
    K.channelDerivation.finiteChain.totalMI ≤
      K.channelDerivation.channelCapacity
Mathematical content
ValidKernel
ValidKernel -> finiteLocalSum(T, localCMIValue) ≤ channelCapacity
totalMI = finiteLocalSum(T, localCMIValue)
therefore totalMI ≤ channelCapacity
Boundary
This closes only the global valid-kernel theorem conditional on kernel capacity soundness.
It does not prove:
global URF Law 3;
information-theoretic derivation from probability measures;
unconditional global kernel theorem;
unconditional channel-capacity theorem;
Chronos-RR;
H4.1/FGL;
P vs NP;
any Clay problem.
Minimal missing objects
GLOBAL_URF_LAW3
INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES
Next admissible object
GLOBAL_URF_LAW3

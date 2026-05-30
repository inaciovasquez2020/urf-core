# CHANNEL_CAPACITY_BOUND_DERIVATION_2026_05_30

Status: `CHANNEL_CAPACITY_BOUND_DERIVATION_CLOSED_CONDITIONAL_ON_FINITE_CAPACITY_BOUND_NO_GLOBAL_KERNEL`

## Object

```lean
structure ChannelCapacityBoundDerivation where
  finiteChain : FiniteMutualInformationChainRuleProof
  channelCapacity : ℝ
  finite_capacity_bound :
    finiteChain.finiteLocalSum finiteChain.T finiteChain.localCMIValue ≤ channelCapacity
  global_kernel_required : Prop
  law3_required : Prop
Lean theorem
theorem channel_capacity_bound_derivation
    (K : ChannelCapacityBoundDerivation) :
    K.finiteChain.totalMI ≤ K.channelCapacity
Mathematical content
totalMI = finiteLocalSum(T, localCMIValue)
finiteLocalSum(T, localCMIValue) ≤ channelCapacity
therefore totalMI ≤ channelCapacity
Boundary
This closes only the channel-capacity bound derivation conditional on a packaged finite capacity bound.
It does not prove:
global valid kernel theorem;
global URF Law 3;
information-theoretic derivation from probability measures;
unconditional channel-capacity theorem;
Chronos-RR;
H4.1/FGL;
P vs NP;
any Clay problem.
Minimal missing objects
GLOBAL_VALID_KERNEL_THEOREM
INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES
Next admissible object
GLOBAL_VALID_KERNEL_THEOREM

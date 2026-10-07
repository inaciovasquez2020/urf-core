import URF.Foundation.FiniteMutualInformationChainRuleProof

namespace URF.Foundation

/--
The explicit finite admissibility interface for a URF kernel/process.

The previous global theorem carried validKernel : Prop as an unstructured
placeholder. This interface makes the required semantic layers explicit:
the admissible object must expose probability-kernel semantics, a measurable
transition system, and a per-history/per-step capacity bound.

The capacity bound is deliberately a field of the admissibility interface.
It is therefore not claimed here that the underlying URF rules imply the
bound; that implication remains the next mathematical theorem.
-/
structure ValidURFFiniteKernel where
  chain : URF.FiniteMutualInformationChainRuleProof
  channelCapacity : ℝ
  validKernel : Prop
  probabilityKernelSemantics : Prop
  measurableTransitionSystem : Prop
  perStepCapacityBound :
    ∀ t : Nat, t < chain.T → chain.localCMIValue t ≤ channelCapacity

/--
The admissibility interface exposes the exact local information bound needed
by the finite chain-rule derivation.
-/
theorem ValidURFFiniteKernel.per_step_capacity_bound
    (K : ValidURFFiniteKernel)
    (t : Nat)
    (ht : t < K.chain.T) :
    K.chain.localCMIValue t ≤ K.channelCapacity :=
  K.perStepCapacityBound t ht

/--
This is an interface theorem, not an unconditional URF Law 3 theorem.
The remaining global step is to prove that the intended URF rules construct
ValidURFFiniteKernel instances and, in particular, supply
perStepCapacityBound.
-/
def ValidURFFiniteKernel.status : String :=
  "VALID_URF_FINITE_KERNEL_INTERFACE_CLOSED_CONDITIONAL_ON_PER_STEP_CAPACITY_BOUND"

def ValidURFFiniteKernel.nextAdmissibleObject : String :=
  "URF_RULES_TO_PER_STEP_CAPACITY_BOUND"

end URF.Foundation

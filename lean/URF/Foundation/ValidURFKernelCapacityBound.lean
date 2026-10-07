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
  localSum_eq_sum :
    ∀ T : Nat, ∀ f : Nat → ℝ,
      chain.finiteLocalSum T f = ∑ t in Finset.range T, f t

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

/-- The finite chain rule yields the T-times-capacity bound once the
abstract finiteLocalSum is identified with the concrete finite sum. -/
theorem ValidURFFiniteKernel.total_mi_le_time_capacity
    (K : ValidURFFiniteKernel) :
    K.chain.totalMI ≤ K.chain.T * K.channelCapacity := by
  rw [K.chain.finite_chain_rule, K.localSum_eq_sum]
  have hterm : ∀ t ∈ Finset.range K.chain.T,
      K.chain.localCMIValue t ≤ K.channelCapacity := by
    intro t ht
    exact K.perStepCapacityBound t (Finset.mem_range.mp ht)
  have hsum :
      (∑ t in Finset.range K.chain.T, K.chain.localCMIValue t) ≤
        ∑ _t in Finset.range K.chain.T, K.channelCapacity :=
    Finset.sum_le_sum hterm
  calc
    ∑ t in Finset.range K.chain.T, K.chain.localCMIValue t ≤
        ∑ _t in Finset.range K.chain.T, K.channelCapacity := hsum
    _ = K.chain.T * K.channelCapacity := by simp

end URF.Foundation

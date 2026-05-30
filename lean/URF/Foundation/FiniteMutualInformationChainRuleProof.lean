import Mathlib.Data.Real.Basic

namespace URF

structure FiniteMutualInformationChainRuleProof where
  T : Nat
  RandomVariable : Type
  X : Nat → RandomVariable
  Y : Nat → RandomVariable
  Z : Nat → RandomVariable
  finiteLocalSum : Nat → (Nat → ℝ) → ℝ
  totalMI : ℝ
  localCMIValue : Nat → ℝ
  cmi_nonneg : ∀ t : Nat, 0 ≤ localCMIValue t
  finite_chain_rule :
    totalMI = finiteLocalSum T localCMIValue
  capacity_bound_required : Prop
  global_kernel_required : Prop

theorem finite_mutual_information_chain_rule_proof
    (K : FiniteMutualInformationChainRuleProof) :
    K.totalMI = K.finiteLocalSum K.T K.localCMIValue :=
  K.finite_chain_rule

theorem finite_mutual_information_chain_rule_local_nonneg
    (K : FiniteMutualInformationChainRuleProof)
    (t : Nat) :
    0 ≤ K.localCMIValue t :=
  K.cmi_nonneg t

def FiniteMutualInformationChainRuleProof.status : String :=
  "FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL"

def FiniteMutualInformationChainRuleProof.nextAdmissibleObject : String :=
  "CHANNEL_CAPACITY_BOUND_DERIVATION"

end URF

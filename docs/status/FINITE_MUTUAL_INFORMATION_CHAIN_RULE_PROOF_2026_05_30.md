# FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF_2026_05_30

Status: `FINITE_CHAIN_RULE_INTERFACE_ONLY_NO_CAPACITY_BOUND_OR_GLOBAL_KERNEL`

## Object

```lean
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
Lean theorem
theorem finite_mutual_information_chain_rule_proof
    (K : FiniteMutualInformationChainRuleProof) :
    K.totalMI = K.finiteLocalSum K.T K.localCMIValue
Mathematical content
I_total = finiteLocalSum(T, CMI)
Boundary
This is a finite chain-rule interface only.
It does not prove:

channel-capacity bound derivation;
global valid kernel theorem;
global URF Law 3;
information-theoretic derivation from probability measures;
Chronos-RR;
H4.1/FGL;
P vs NP;
any Clay problem.
Minimal missing objects
CHANNEL_CAPACITY_BOUND_DERIVATION
GLOBAL_VALID_KERNEL_THEOREM
Next admissible object
CHANNEL_CAPACITY_BOUND_DERIVATION

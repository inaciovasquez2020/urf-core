import Mathlib.Data.Real.Basic

namespace URF

structure CMINonnegativityProof where
  RandomVariable : Type
  ConditionalMutualInformationValue :
    RandomVariable → RandomVariable → RandomVariable → ℝ
  cmi_nonneg :
    ∀ X Y Z : RandomVariable,
      0 ≤ ConditionalMutualInformationValue X Y Z

def CMINonnegativityProof.localCMIValue
    (K : CMINonnegativityProof)
    (X Y Z : K.RandomVariable) : ℝ :=
  K.ConditionalMutualInformationValue X Y Z

theorem cmi_nonnegativity_proof
    (K : CMINonnegativityProof)
    (X Y Z : K.RandomVariable) :
    0 ≤ K.localCMIValue X Y Z :=
  K.cmi_nonneg X Y Z

def CMINonnegativityProof.status : String :=
  "CMI_NONNEGATIVITY_INTERFACE_ONLY_NO_CHAIN_RULE_OR_CAPACITY_BOUND"

def CMINonnegativityProof.nextAdmissibleObject : String :=
  "FINITE_MUTUAL_INFORMATION_CHAIN_RULE_PROOF"

end URF

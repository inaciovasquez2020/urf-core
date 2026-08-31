import URF.Foundation.FiniteConditionalEntropyDefinition

namespace URF.Foundation.FiniteConditionalMutualInformationDefinition

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteConditionalEntropyDefinition

universe u

/--
Finite conditional mutual information of `X` and `Y` given `Z`, defined from
already-verified conditional-entropy objects by

  I(X;Y | Z) = H(X | Z) - H(X | Y,Z).

The conditioning pair `(Y,Z)` is represented as the finite-valued random
variable `fun a => (Y a, Z a)`. This definition alone does not establish
nonnegativity, symmetry, a chain rule, or any capacity bound.
-/
def finiteConditionalMutualInformation
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) : ℝ :=
  finiteConditionalEntropy μ X Z -
    finiteConditionalEntropy μ X (fun a => (Y a, Z a))

/-- The defining conditional-entropy identity for finite CMI. -/
theorem finiteConditionalMutualInformation_eq_conditional_entropies
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteConditionalMutualInformation μ X Y Z =
      finiteConditionalEntropy μ X Z -
        finiteConditionalEntropy μ X (fun a => (Y a, Z a)) := by
  rfl

def status : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_DEFINED_FROM_VERIFIED_CONDITIONAL_ENTROPIES"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_NONNEGATIVITY_DERIVATION"

end URF.Foundation.FiniteConditionalMutualInformationDefinition

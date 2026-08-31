import URF.Foundation.FiniteConditionalKLSumEntropyGap

namespace URF.Foundation.FiniteConditionalMutualInformationNonnegativity

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteConditionalMutualInformationDefinition
open URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction
open URF.Foundation.FiniteConditionalKLSumEntropyGap

universe u

/--
Concrete finite conditional mutual information is nonnegative.  This theorem
uses the probability-derived finite entropy strong-subadditivity theorem and
the earlier algebraic CMI reduction; it does not use the abstract
`CMINonnegativityProof.cmi_nonneg` assumption.
-/
theorem finiteConditionalMutualInformation_nonnegative
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    0 ≤ finiteConditionalMutualInformation μ X Y Z := by
  exact
    finiteConditionalMutualInformation_nonnegative_of_entropy_submodularity
      μ X Y Z (finiteEntropySubmodularity_from_conditionalGibbs μ X Y Z)

def status : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_NONNEGATIVITY_PROVED"

def nextAdmissibleObject : String :=
  "FINITE_PROBABILITY_DERIVED_INFORMATION_CHAIN_RULE"

end URF.Foundation.FiniteConditionalMutualInformationNonnegativity

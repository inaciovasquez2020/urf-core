import URF.Foundation.FiniteJointDistributionEntropy

namespace URF.Foundation.FiniteMutualInformationDefinition

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteJointDistributionEntropy

universe u

/--
Finite mutual information of two finite random variables, defined from the
already-verified marginal and joint Shannon entropy objects.  This definition
alone does not establish nonnegativity or any chain rule.
-/
def finiteMutualInformation
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) : ℝ :=
  finiteRandomVariableEntropy μ X +
    finiteRandomVariableEntropy μ Y -
      finiteJointEntropy μ X Y

/-- The defining entropy identity for finite mutual information. -/
theorem finiteMutualInformation_eq_entropies
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    finiteMutualInformation μ X Y =
      finiteRandomVariableEntropy μ X +
        finiteRandomVariableEntropy μ Y -
          finiteJointEntropy μ X Y := by
  rfl

def status : String :=
  "FINITE_MUTUAL_INFORMATION_DEFINED_FROM_VERIFIED_ENTROPIES"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_ENTROPY_AND_CONDITIONAL_MUTUAL_INFORMATION_DEFINITIONS"

end URF.Foundation.FiniteMutualInformationDefinition

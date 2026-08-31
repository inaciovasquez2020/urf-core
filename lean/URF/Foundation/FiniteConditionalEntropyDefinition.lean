import URF.Foundation.FiniteJointDistributionEntropy

namespace URF.Foundation.FiniteConditionalEntropyDefinition

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteJointDistributionEntropy

universe u

/--
Finite conditional entropy of `X` given `Y`, defined only from the
already-verified marginal and joint Shannon entropy objects. This definition
alone does not establish nonnegativity or any information-theoretic chain rule.
-/
def finiteConditionalEntropy
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) : ℝ :=
  finiteJointEntropy μ X Y - finiteRandomVariableEntropy μ Y

/-- The defining entropy identity for finite conditional entropy. -/
theorem finiteConditionalEntropy_eq_entropies
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    finiteConditionalEntropy μ X Y =
      finiteJointEntropy μ X Y - finiteRandomVariableEntropy μ Y := by
  rfl

def status : String :=
  "FINITE_CONDITIONAL_ENTROPY_DEFINED_FROM_VERIFIED_ENTROPIES"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_DEFINITION"

end URF.Foundation.FiniteConditionalEntropyDefinition

import URF.Foundation.FiniteConditionalMutualInformationDefinition

namespace URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteJointDistributionEntropy
open URF.Foundation.FiniteConditionalEntropyDefinition
open URF.Foundation.FiniteConditionalMutualInformationDefinition

universe u

/--
The exact finite entropy-submodularity inequality sufficient for concrete CMI
nonnegativity:

  H(Z) + H(X,Y,Z) ≤ H(X,Z) + H(Y,Z).

Here `H(X,Y,Z)` is represented as the joint entropy of `X` with the pair-valued
random variable `(Y,Z)`.  This predicate contains no information-theoretic
assumption beyond the displayed inequality itself.
-/
def finiteEntropySubmodularity
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) : Prop :=
  finiteRandomVariableEntropy μ Z +
      finiteJointEntropy μ X (fun a => (Y a, Z a)) ≤
    finiteJointEntropy μ X Z + finiteJointEntropy μ Y Z

/-- Entropy of the pair-valued random variable `(Y,Z)` is its joint entropy. -/
theorem pair_entropy_eq_joint_entropy
    {α γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (Y : α → γ) (Z : α → δ) :
    finiteRandomVariableEntropy μ (fun a => (Y a, Z a)) =
      finiteJointEntropy μ Y Z := by
  rfl

/--
Concrete finite CMI is nonnegative once the exact finite entropy-submodularity
inequality is available.  This theorem is an algebraic reduction only; it does
not prove entropy submodularity itself.
-/
theorem finiteConditionalMutualInformation_nonnegative_of_entropy_submodularity
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (h : finiteEntropySubmodularity μ X Y Z) :
    0 ≤ finiteConditionalMutualInformation μ X Y Z := by
  unfold finiteEntropySubmodularity at h
  rw [finiteConditionalMutualInformation_eq_conditional_entropies]
  rw [finiteConditionalEntropy_eq_entropies, finiteConditionalEntropy_eq_entropies]
  rw [pair_entropy_eq_joint_entropy]
  linarith

def status : String :=
  "FINITE_CMI_NONNEGATIVITY_REDUCED_TO_FINITE_ENTROPY_SUBMODULARITY"

def nextAdmissibleObject : String :=
  "FINITE_ENTROPY_SUBMODULARITY_DERIVATION_FROM_GIBBS_INEQUALITY"

end URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction

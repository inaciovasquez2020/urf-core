import URF.Foundation.FiniteConditionalKLSumEntropyGap

namespace URF.Foundation.FiniteConditionalMutualInformationNonnegativity

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteJointDistributionEntropy
open URF.Foundation.FiniteConditionalEntropyDefinition
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

/--
Concrete finite conditional entropy is nonnegative.  This is derived from the
proved CMI nonnegativity theorem by applying it to `I(X;X | Y)`: conditioning
additionally on `X` leaves zero residual entropy because `X` is recovered by
the first projection from `(X,Y)`.
-/
theorem finiteConditionalEntropy_nonnegative
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    0 ≤ finiteConditionalEntropy μ X Y := by
  have hself := finiteConditionalMutualInformation_nonnegative μ X X Y
  have hrecover :
      finiteConditionalEntropy μ X (fun a => (X a, Y a)) = 0 := by
    exact
      finiteConditionalEntropy_eq_zero_of_recoverable
        μ X (fun a => (X a, Y a)) (fun xy : β × γ => xy.1) (by
          intro a
          rfl)
  rw [finiteConditionalMutualInformation_eq_conditional_entropies, hrecover] at hself
  simpa using hself

/--
Concrete finite conditional mutual information is bounded above by the
conditional entropy of its second variable.  The proof uses only conditional
entropy nonnegativity and injective recoding invariance to identify the two
coordinate orderings of the triple joint entropy.
-/
theorem finiteConditionalMutualInformation_le_conditionalEntropy_second
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteConditionalMutualInformation μ X Y Z ≤
      finiteConditionalEntropy μ Y Z := by
  have hYgivenXZ :
      0 ≤ finiteConditionalEntropy μ Y (fun a => (X a, Z a)) :=
    finiteConditionalEntropy_nonnegative μ Y (fun a => (X a, Z a))
  have hTriple :
      finiteJointEntropy μ X (fun a => (Y a, Z a)) =
        finiteJointEntropy μ Y (fun a => (X a, Z a)) := by
    let f : β × (γ × δ) → γ × (β × δ) :=
      fun p => (p.2.1, (p.1, p.2.2))
    let g : γ × (β × δ) → β × (γ × δ) :=
      fun p => (p.2.1, (p.1, p.2.2))
    have hgf : Function.LeftInverse g f := by
      intro p
      rcases p with ⟨x, yz⟩
      rcases yz with ⟨y, z⟩
      rfl
    have hf : Function.Injective f := hgf.injective
    change
      finiteRandomVariableEntropy μ (fun a => (X a, (Y a, Z a))) =
        finiteRandomVariableEntropy μ (fun a => (Y a, (X a, Z a)))
    have h :=
      finiteRandomVariableEntropy_comp_injective
        μ (fun a => (X a, (Y a, Z a))) f hf
    simpa [f] using h.symm
  simp only [
    finiteConditionalMutualInformation_eq_conditional_entropies,
    finiteConditionalEntropy_eq_entropies,
    pair_entropy_eq_joint_entropy] at hYgivenXZ ⊢
  rw [hTriple]
  linarith

def status : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_NONNEGATIVITY_PROVED"

def nextAdmissibleObject : String :=
  "FINITE_PROBABILITY_DERIVED_INFORMATION_CHAIN_RULE"

end URF.Foundation.FiniteConditionalMutualInformationNonnegativity

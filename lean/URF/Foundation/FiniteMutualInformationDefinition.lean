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

/-- A pointwise constant finite random variable carries zero mutual information. -/
theorem finiteMutualInformation_eq_zero_of_constant_second
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ)
    (y₀ : γ) (hY : ∀ a : α, Y a = y₀) :
    finiteMutualInformation μ X Y = 0 := by
  have hUnitEntropy :
      finiteRandomVariableEntropy μ (fun _ : α => PUnit.unit) = 0 := by
    unfold finiteRandomVariableEntropy finiteShannonEntropy
    simp [
      URF.Foundation.FiniteRandomVariablePushforward.finiteRandomVariablePushDistribution_prob,
      URF.Foundation.FiniteRandomVariablePushforward.finiteRandomVariablePushProb_eq_preimage_sum,
      μ.total_mass,
      shannonTerm]
  have hYEntropy : finiteRandomVariableEntropy μ Y = 0 := by
    let f : PUnit → γ := fun _ => y₀
    have hf : Function.Injective f := by
      intro z₁ z₂ _
      exact Subsingleton.elim z₁ z₂
    have h := finiteRandomVariableEntropy_comp_injective
      μ (fun _ : α => PUnit.unit) f hf
    have hcomp : (fun a : α => f PUnit.unit) = Y := by
      funext a
      simpa [f] using (hY a).symm
    rw [hcomp] at h
    linarith
  have hJoint : finiteJointEntropy μ X Y = finiteRandomVariableEntropy μ X := by
    let f : β → β × γ := fun x => (x, y₀)
    have hf : Function.Injective f := by
      intro x₁ x₂ h
      exact congrArg Prod.fst h
    change
      finiteRandomVariableEntropy μ (fun a => (X a, Y a)) =
        finiteRandomVariableEntropy μ X
    have h := finiteRandomVariableEntropy_comp_injective μ X f hf
    have hcomp : (fun a : α => f (X a)) = (fun a => (X a, Y a)) := by
      funext a
      simp [f, hY a]
    rw [hcomp] at h
    exact h
  rw [finiteMutualInformation_eq_entropies, hYEntropy, hJoint]
  ring

def status : String :=
  "FINITE_MUTUAL_INFORMATION_DEFINED_FROM_VERIFIED_ENTROPIES"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_ENTROPY_AND_CONDITIONAL_MUTUAL_INFORMATION_DEFINITIONS"

end URF.Foundation.FiniteMutualInformationDefinition

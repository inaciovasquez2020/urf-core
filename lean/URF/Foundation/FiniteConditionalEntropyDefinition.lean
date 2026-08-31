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

/--
If `X` is deterministically recoverable from `Y`, then the finite conditional
entropy `H(X | Y)` is zero.  The proof identifies `(X,Y)` with an injective
recoding of `Y`, so it uses only the verified entropy invariance under injective
recoding.
-/
theorem finiteConditionalEntropy_eq_zero_of_recoverable
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ)
    (recover : γ → β)
    (hrecover : ∀ a : α, recover (Y a) = X a) :
    finiteConditionalEntropy μ X Y = 0 := by
  have hJoint :
      finiteJointEntropy μ X Y = finiteRandomVariableEntropy μ Y := by
    let f : γ → β × γ := fun y => (recover y, y)
    have hf : Function.Injective f := by
      intro y₁ y₂ h
      exact congrArg (fun z => z.2) h
    change
      finiteRandomVariableEntropy μ (fun a => (X a, Y a)) =
        finiteRandomVariableEntropy μ Y
    have h := finiteRandomVariableEntropy_comp_injective μ Y f hf
    simpa [f, hrecover] using h
  rw [finiteConditionalEntropy_eq_entropies, hJoint]
  ring

def status : String :=
  "FINITE_CONDITIONAL_ENTROPY_DEFINED_FROM_VERIFIED_ENTROPIES"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_DEFINITION"

end URF.Foundation.FiniteConditionalEntropyDefinition
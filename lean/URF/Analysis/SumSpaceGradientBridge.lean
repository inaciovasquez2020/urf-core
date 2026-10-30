import Mathlib

/-!
# Abstract sum-space and gradient-constrained K-functionals

This module isolates the structural distinction needed for the
Bourgain–Brezis sum-space test. It does not formalize any Sobolev space,
Fourier estimate, Hodge projection, or paper-specific lower bound.
-/

namespace URF
namespace Analysis

/--
An ambient sum-space pair consists of two normed additive groups whose
elements are embedded additively into one common ambient additive group.
The embeddings need not be surjective or injective.
-/
structure SumSpacePair (E X₀ X₁ : Type*)
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁] where
  embed₀ : X₀ →+ E
  embed₁ : X₁ →+ E

/-- The set of costs of all ambient decompositions of F. -/
def ambientDecompositionCosts
    {E X₀ X₁ : Type*}
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    (P : SumSpacePair E X₀ X₁) (F : E) : Set ℝ :=
  {r | ∃ x₀ : X₀, ∃ x₁ : X₁,
    P.embed₀ x₀ + P.embed₁ x₁ = F ∧
    (‖x₀‖ + ‖x₁‖) = r}

/-- Ambient sum-space K-functional, using the real infimum convention. -/
noncomputable def ambientKFunctional
    {E X₀ X₁ : Type*}
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    (P : SumSpacePair E X₀ X₁) (F : E) : ℝ :=
  sInf (ambientDecompositionCosts P F)

/--
A gradient-constrained pair refines an ambient pair by specifying two
potential spaces and additive gradient maps into the corresponding
ambient component spaces. Both gradients are compared in the same
target group. No analytic property of the maps is assumed here.
-/
structure GradientConstrainedPair
    (E X₀ X₁ S₀ S₁ : Type*)
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    [NormedAddCommGroup S₀]
    [NormedAddCommGroup S₁]
    extends SumSpacePair E X₀ X₁ where
  gradient₀ : S₀ →+ X₀
  gradient₁ : S₁ →+ X₁

/--
The set of costs of decompositions in which each component is required
to lie in the range of its specified gradient map.
-/
def constrainedDecompositionCosts
    {E X₀ X₁ S₀ S₁ : Type*}
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    [NormedAddCommGroup S₀]
    [NormedAddCommGroup S₁]
    (P : GradientConstrainedPair E X₀ X₁ S₀ S₁) (F : E) : Set ℝ :=
  {r | ∃ u₀ : S₀, ∃ u₁ : S₁,
    P.embed₀ (P.gradient₀ u₀) + P.embed₁ (P.gradient₁ u₁) = F ∧
    (‖P.gradient₀ u₀‖ + ‖P.gradient₁ u₁‖) = r}

/-- Gradient-constrained K-functional. -/
noncomputable def constrainedKFunctional
    {E X₀ X₁ S₀ S₁ : Type*}
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    [NormedAddCommGroup S₀]
    [NormedAddCommGroup S₁]
    (P : GradientConstrainedPair E X₀ X₁ S₀ S₁) (F : E) : ℝ :=
  sInf (constrainedDecompositionCosts P F)

/--
Every gradient-constrained decomposition is an ambient decomposition
with the same cost. This is the basic inclusion required before any
comparison of the two K-functionals can be attempted.
-/
theorem constrainedCosts_subset_ambientCosts
    {E X₀ X₁ S₀ S₁ : Type*}
    [AddCommGroup E]
    [NormedAddCommGroup X₀]
    [NormedAddCommGroup X₁]
    [NormedAddCommGroup S₀]
    [NormedAddCommGroup S₁]
    (P : GradientConstrainedPair E X₀ X₁ S₀ S₁) (F : E) :
    constrainedDecompositionCosts P F ⊆
      ambientDecompositionCosts P.toSumSpacePair F := by
  intro r hr
  rcases hr with ⟨u₀, u₁, hdecomp, hcost⟩
  exact ⟨P.gradient₀ u₀, P.gradient₁ u₁, hdecomp, hcost⟩

end Analysis
end URF

import Mathlib
import URF.Boundary.VertexBoundary
import URF.PSH.BoundedOverlap
import URF.Info.InfoAxioms

axiom entropy_of_set : ℕ → ℝ

axiom entropy_mul_card_bound
  (C n : ℕ) :
  entropy_of_set (C * n) ≤ entropy_of_set n + (C * InfoStepBound)

lemma transport_entropy_bound
  {V : Type} [DecidableEq V]
  (adj : V → Finset V)
  (k Δ : ℕ) :
  ∃ C, ∀ S : Finset V,
    entropy_of_set (vertexBoundary adj S).card
      ≤ entropy_of_set S.card + (C * InfoStepBound) := by
  obtain ⟨C, hC⟩ := PSH_bounded_overlap adj k Δ
  refine ⟨C, ?_⟩
  intro S
  have hbd : (vertexBoundary adj S).card ≤ C * S.card := hC S
  have hmono :
      entropy_of_set (vertexBoundary adj S).card
        ≤ entropy_of_set (C * S.card) :=
    entropy_monotone hbd
  have hlin :
      entropy_of_set (C * S.card)
        ≤ entropy_of_set S.card + (C * InfoStepBound) :=
    entropy_mul_card_bound C S.card
  exact le_trans hmono hlin

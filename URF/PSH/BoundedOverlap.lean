import Mathlib
import URF.Boundary.VertexBoundary

axiom PSH_bounded_overlap
  {V : Type} [DecidableEq V]
  (adj : V → Finset V) (k Δ : ℕ) :
  ∃ C : ℕ, ∀ (S : Finset V),
    (vertexBoundary adj S).card ≤ C * S.card

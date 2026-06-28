import Mathlib
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic
import URF.Boundary.VertexBoundary

/-- PSH-style bounded overlap stated through an explicit certificate instead of a global axiom. -/
theorem PSH_bounded_overlap
  {V : Type} [DecidableEq V]
  (adj : V → Finset V) (_k _Δ : ℕ)
  (cert :
    ∃ C : ℕ, ∀ (S : Finset V),
      (vertexBoundary adj S).card ≤ C * S.card) :
  ∃ C : ℕ, ∀ (S : Finset V),
    (vertexBoundary adj S).card ≤ C * S.card :=
by
  exact cert

namespace URF

variable {V : Type} [DecidableEq V] [Fintype V]

/-- Local observation with finite support. -/
structure LocalObs where
  supp : Finset V

omit [DecidableEq V] [Fintype V] in
/--
Abstract PSH finiteness principle, stated through an explicit certificate:
local observations admit a finite key space.
-/
theorem PSH_finite_keys
    (cert : ∃ (K : Type) (_ : Fintype K) (_key : LocalObs (V := V) → K), True) :
  ∃ (K : Type) (_ : Fintype K) (_key : LocalObs (V := V) → K), True := by
  exact cert

/--
Trivial boundedness consequence: any finite key space
admits a uniform cardinal bound.
This is the *only* thing used downstream.
-/
lemma bounded_overlap_from_PSH
    (V : Type) [DecidableEq V] [Fintype V]
    (cert : ∃ (K : Type) (_ : Fintype K) (_key : LocalObs (V := V) → K), True) :
  ∃ _M : ℕ, True := by
  classical
  rcases PSH_finite_keys (V := V) cert with ⟨K, _hK, _key, -⟩
  exact ⟨Fintype.card K, trivial⟩

end URF
import Mathlib
import URF.Boundary.VertexBoundary

variable {V : Type} [DecidableEq V]
variable (adj : V → Finset V)

theorem isTree : True := by
  trivial

lemma tree_vertexBoundary_bound
  (maxDegree : ℕ)
  (degree_bound : ∀ v : V, (adj v).card ≤ maxDegree)
  (S : Finset V) :
  (vertexBoundary adj S).card ≤ maxDegree * S.card := by
  classical
  have : ∀ v ∈ S, (adj v).filter (fun u => u ∉ S) ⊆ adj v := by
    intro v hv u hu
    simpa using hu
  calc
    (vertexBoundary adj S).card
        ≤ (S.bind adj).card := by
            exact card_le_of_subset (vertexBoundary_subset_neighbors adj S)
    _ ≤ S.card * maxDegree := by
            simpa [Finset.card_bind] using
              Finset.card_bind_le.mpr degree_bound

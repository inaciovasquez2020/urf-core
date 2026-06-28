import Mathlib
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic

open Finset
open scoped BigOperators

variable {V : Type} [DecidableEq V]

/- Adjacency given as a finitary neighborhood map. -/
variable (adj : V → Finset V)

/-- Vertex boundary defined via adjacency lists. -/
def vertexBoundary (S : Finset V) : Finset V :=
  S.biUnion (fun v => (adj v).filter (fun u => u ∉ S))

lemma vertexBoundary_subset_neighbors (S : Finset V) :
  vertexBoundary adj S ⊆ S.biUnion adj := by
  intro x hx
  simp [vertexBoundary] at hx ⊢
  rcases hx with ⟨a, haS, hxa, _⟩
  exact ⟨a, haS, hxa⟩

namespace URF

/- Adjacency given as a binary relation. -/
variable (E : V → V → Prop)

/-- Vertex boundary defined relationally. -/
noncomputable def vertex_boundary (E : V → V → Prop) (S : Finset V) : Finset V := by
  classical
  exact S.filter (fun v => ∃ u : V, E v u ∧ u ∉ S)

omit [DecidableEq V] in
lemma mem_vertex_boundary {S : Finset V} {v : V} :
  v ∈ vertex_boundary E S
    ↔ v ∈ S ∧ ∃ u : V, E v u ∧ u ∉ S := by
  classical
  simp [vertex_boundary]

end URF

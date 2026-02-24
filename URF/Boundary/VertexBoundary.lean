import Mathlib

open Finset

variable {V : Type} [DecidableEq V]
variable (adj : V → Finset V)

def vertexBoundary (S : Finset V) : Finset V :=
  S.bind (fun v => (adj v).filter (fun u => u ∉ S))

lemma vertexBoundary_subset_neighbors (S : Finset V) :
  vertexBoundary adj S ⊆ S.bind adj := by
  intro x hx
  simpa [vertexBoundary] using hx

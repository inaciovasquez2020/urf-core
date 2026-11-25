import Mathlib
import URF.Foundation.CyclePartitionExtremizersCandidate

/-!
A concrete finite simple graph for a list of cycle lengths.
Vertices carry a component label and a position modulo the corresponding
component length. No connected-component or locality assertion is assumed.
-/

namespace URF.EntropyBridge

/-- Vertices of the disjoint union of the cycles specified by a length list. -/
abbrev CyclePartitionVertex (sizes : List ℕ) :=
  Σ i : Fin sizes.length, Fin (sizes.get i)

/-- Clockwise successor relation, including the last-to-first edge. -/
def cyclePartitionSuccessorRel (sizes : List ℕ)
    (u v : CyclePartitionVertex sizes) : Prop :=
  u.1 = v.1 ∧
    (u.2.val + 1 = v.2.val ∨
      (u.2.val + 1 = sizes.get u.1 ∧ v.2.val = 0))

/-- An actual finite simple graph: the symmetric, irreflexive closure of
the successor edges within each listed cycle. -/
def cyclePartitionSimpleGraph (sizes : List ℕ) :
    SimpleGraph (CyclePartitionVertex sizes) :=
  SimpleGraph.fromRel (cyclePartitionSuccessorRel sizes)

/-- Each edge preserves the explicit component label. -/
theorem cyclePartition_adj_same_component (sizes : List ℕ)
    (u v : CyclePartitionVertex sizes)
    (h : (cyclePartitionSimpleGraph sizes).Adj u v) :
    u.1 = v.1 := by
  change u ≠ v ∧
    (cyclePartitionSuccessorRel sizes u v ∨
      cyclePartitionSuccessorRel sizes v u) at h
  rcases h.2 with huv | hvu
  · exact huv.1
  · exact hvu.1.symm

/-- The resulting graph has a finite vertex set, even when the list
contains zero-sized entries (the intended cycle class additionally
requires all lengths at least three). -/
theorem cyclePartition_vertices_finite (sizes : List ℕ) :
    Finite (CyclePartitionVertex sizes) := inferInstance

/-- Exact cardinality of the dependent vertex carrier, indexed by
the lengths of its constituent cycle components. -/
theorem cyclePartition_vertices_card (sizes : List ℕ) :
    Fintype.card (CyclePartitionVertex sizes) =
      ∑ i : Fin sizes.length, sizes.get i := by
  simp only [CyclePartitionVertex, Fintype.card_sigma, Fintype.card_fin]

/-- Reachability cannot cross between separately indexed cycle blocks. -/
theorem cyclePartition_reachable_same_component (sizes : List ℕ)
    (u v : CyclePartitionVertex sizes)
    (h : (cyclePartitionSimpleGraph sizes).Reachable u v) :
    u.1 = v.1 := by
  obtain ⟨w⟩ := h
  induction w with
  | nil => rfl
  | @cons a b c hab w ih =>
    exact (cyclePartition_adj_same_component sizes a b hab).trans ih

/-- Two consecutive positions in a listed cycle are joined by a graph edge. -/
theorem cyclePartition_consecutive_adj (sizes : List ℕ)
    (i : Fin sizes.length) (x y : Fin (sizes.get i))
    (hxy : x.val + 1 = y.val) :
    (cyclePartitionSimpleGraph sizes).Adj
      (⟨i, x⟩ : CyclePartitionVertex sizes)
      (⟨i, y⟩ : CyclePartitionVertex sizes) := by
  change (⟨i, x⟩ : CyclePartitionVertex sizes) ≠ ⟨i, y⟩ ∧
    (cyclePartitionSuccessorRel sizes ⟨i, x⟩ ⟨i, y⟩ ∨
      cyclePartitionSuccessorRel sizes ⟨i, y⟩ ⟨i, x⟩)
  constructor
  · intro he
    have hv : x.val = y.val :=
      congrArg (fun z : CyclePartitionVertex sizes => z.2.val) he
    omega
  · exact Or.inl ⟨rfl, Or.inl hxy⟩

#print axioms URF.EntropyBridge.cyclePartition_consecutive_adj

#print axioms URF.EntropyBridge.cyclePartition_reachable_same_component

#print axioms URF.EntropyBridge.cyclePartition_vertices_card

#print axioms URF.EntropyBridge.cyclePartition_adj_same_component
#print axioms URF.EntropyBridge.cyclePartition_vertices_finite

end URF.EntropyBridge

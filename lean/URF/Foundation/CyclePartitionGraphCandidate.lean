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

/-- The last position of a cycle block is adjacent to its first position. -/
theorem cyclePartition_wrap_adj (sizes : List ℕ)
    (i : Fin sizes.length) (x y : Fin (sizes.get i))
    (hsize : 2 ≤ sizes.get i)
    (hlast : x.val + 1 = sizes.get i) (hfirst : y.val = 0) :
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
  · exact Or.inl ⟨rfl, Or.inr ⟨hlast, hfirst⟩⟩

#print axioms URF.EntropyBridge.cyclePartition_wrap_adj

/-- Every position in a nonempty cycle block is reachable from its
zero position, using only consecutive edges. -/
theorem cyclePartition_zero_reachable (sizes : List ℕ)
    (i : Fin sizes.length) (hpos : 0 < sizes.get i)
    (x : Fin (sizes.get i)) :
    (cyclePartitionSimpleGraph sizes).Reachable
      (⟨i, ⟨0, hpos⟩⟩ : CyclePartitionVertex sizes)
      (⟨i, x⟩ : CyclePartitionVertex sizes) := by
  have haux : ∀ n (hn : n < sizes.get i),
      (cyclePartitionSimpleGraph sizes).Reachable
        (⟨i, ⟨0, hpos⟩⟩ : CyclePartitionVertex sizes)
        (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes) := by
    intro n
    induction n with
    | zero =>
        intro hn
        exact ⟨SimpleGraph.Walk.nil⟩
    | succ n ih =>
        intro hn
        have hn' : n < sizes.get i := by omega
        obtain ⟨w⟩ := ih hn'
        have hed := cyclePartition_consecutive_adj sizes i
          (⟨n, hn'⟩ : Fin (sizes.get i))
          (⟨n + 1, hn⟩ : Fin (sizes.get i)) (by rfl)
        exact ⟨w.concat hed⟩
  exact haux x.val x.isLt

/-- Any two vertices in the same nonempty indexed cycle are connected. -/
theorem cyclePartition_same_index_reachable (sizes : List ℕ)
    (i : Fin sizes.length) (hpos : 0 < sizes.get i)
    (x y : Fin (sizes.get i)) :
    (cyclePartitionSimpleGraph sizes).Reachable
      (⟨i, x⟩ : CyclePartitionVertex sizes)
      (⟨i, y⟩ : CyclePartitionVertex sizes) := by
  exact (cyclePartition_zero_reachable sizes i hpos x).symm.trans
    (cyclePartition_zero_reachable sizes i hpos y)

/-- For nonempty blocks, graph reachability is exactly equality of
the explicit cycle component indices. -/
theorem cyclePartition_reachable_iff_index_eq (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (u v : CyclePartitionVertex sizes) :
    (cyclePartitionSimpleGraph sizes).Reachable u v ↔ u.1 = v.1 := by
  constructor
  · exact cyclePartition_reachable_same_component sizes u v
  · intro he
    rcases u with ⟨i, x⟩
    rcases v with ⟨j, y⟩
    change i = j at he
    subst j
    exact cyclePartition_same_index_reachable sizes i (hpos i) x y

#print axioms URF.EntropyBridge.cyclePartition_reachable_iff_index_eq

#print axioms URF.EntropyBridge.cyclePartition_same_index_reachable

#print axioms URF.EntropyBridge.cyclePartition_zero_reachable

#print axioms URF.EntropyBridge.cyclePartition_consecutive_adj

#print axioms URF.EntropyBridge.cyclePartition_reachable_same_component

#print axioms URF.EntropyBridge.cyclePartition_vertices_card

#print axioms URF.EntropyBridge.cyclePartition_adj_same_component
#print axioms URF.EntropyBridge.cyclePartition_vertices_finite

end URF.EntropyBridge

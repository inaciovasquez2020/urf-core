import URF.Foundation.CyclePartitionGraphCandidate

/-!
The connected components of the concrete disjoint-cycle graph are precisely
the indices of its positive-length cycle blocks.
-/

namespace URF.EntropyBridge

/-- A connected component is equivalent to its unique indexed cycle block.
The positive-length condition ensures every block has a representative. -/
noncomputable def cyclePartitionComponentEquiv (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    (cyclePartitionSimpleGraph sizes).ConnectedComponent ≃ Fin sizes.length := by
  let G := cyclePartitionSimpleGraph sizes
  let index : G.ConnectedComponent → Fin sizes.length :=
    Quot.lift (fun v : CyclePartitionVertex sizes => v.1)
      (by
        intro u v huv
        exact cyclePartition_reachable_same_component sizes u v huv)
  refine Equiv.ofBijective index ?_
  constructor
  · intro a b h
    induction a using Quot.inductionOn with
    | _ a =>
      induction b using Quot.inductionOn with
      | _ b =>
        apply Quot.sound
        exact (cyclePartition_reachable_iff_index_eq sizes hpos a b).2 h
  · intro i
    refine ⟨Quot.mk G.Reachable (⟨i, ⟨0, hpos i⟩⟩ :
      CyclePartitionVertex sizes), rfl⟩

/-- Exact number of graph connected components: one per positive-length
entry in the cycle partition. -/
theorem cyclePartition_components_card (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    Nat.card (cyclePartitionSimpleGraph sizes).ConnectedComponent =
      sizes.length := by
  calc
    Nat.card (cyclePartitionSimpleGraph sizes).ConnectedComponent =
      Nat.card (Fin sizes.length) :=
        Nat.card_congr (cyclePartitionComponentEquiv sizes hpos)
    _ = sizes.length := Nat.card_fin _

#print axioms URF.EntropyBridge.cyclePartitionComponentEquiv
#print axioms URF.EntropyBridge.cyclePartition_components_card

end URF.EntropyBridge

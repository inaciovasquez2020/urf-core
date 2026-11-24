import CactusArcCut

namespace URF.EntropyBridge

open SimpleGraph

variable {V : Type*} [LinearOrder V] [Fintype V] {G : SimpleGraph V}

/-- Between two vertices on a cactus cycle, a shortest ambient walk can be
taken entirely on that cycle. -/
theorem UndirectedCycle.exists_shortest_walk_on_cycle
    (C : UndirectedCycle G) (hcat : IsCactus G) {a b : V}
    (ha : a ∈ C.walk.support) (hb : b ∈ C.walk.support) :
    ∃ p : G.Walk a b, p.length = G.dist a b ∧ ∀ e ∈ p.edges, e ∈ C.val := by
  classical
  let q := C.walk.rotate ha
  have hb' : b ∈ q.support := (C.walk.mem_support_rotate_iff ha).mpr hb
  let P := q.takeUntil b hb'
  let Q := q.dropUntil b hb'
  have hrot : q.edges.Perm C.walk.edges := (C.walk.rotate_edges ha).perm
  have hlen : P.length + Q.length = C.length := by
    calc
      _ = (P.append Q).length := (Walk.length_append P Q).symm
      _ = q.length := congrArg Walk.length (q.take_spec hb')
      _ = q.edges.length := (Walk.length_edges q).symm
      _ = C.walk.edges.length := hrot.length_eq
      _ = C.length := (Walk.length_edges C.walk).trans C.walk_length
  have hq {e : Sym2 V} (he : e ∈ q.edges) : e ∈ C.val := by
    rw [← C.walk_spec.2, List.mem_toFinset]
    exact hrot.mem_iff.mp he
  obtain ⟨p, hp⟩ := P.reachable.exists_walk_length_eq_dist
  by_cases hP : P.length ≤ p.length
  · exact ⟨P, le_antisymm (hP.trans_eq hp) (dist_le P),
      fun e he => hq (q.edges_takeUntil_subset hb' he)⟩
  have hPN : P.edges.Nodup :=
    ((C.walk_spec.1.rotate ha).isCircuit.isTrail.takeUntil hb').edges_nodup
  have hmiss : ∃ e ∈ P.edges, e ∉ p.edges := by
    by_contra! hn
    have hsub : P.edges.toFinset ⊆ p.edges.toFinset := by
      intro e he
      exact List.mem_toFinset.mpr (hn e (List.mem_toFinset.mp he))
    have hc := Finset.card_le_card hsub
    rw [List.toFinset_card_of_nodup hPN, Walk.length_edges] at hc
    have hc' := List.toFinset_card_le p.edges
    rw [Walk.length_edges] at hc'
    exact hP (hc.trans hc')
  obtain ⟨e, he, hpe⟩ := hmiss
  have hpr : e ∉ p.reverse.edges := by simpa [Walk.edges_reverse] using hpe
  obtain ⟨u, v, huv, rfl, w, hw, hwlen⟩ :=
    exists_avoiding_complement_of_mem_trail P hPN p.reverse he hpr
  have hbound := C.length_le_of_avoiding_edge hcat huv
    (hq (q.edges_takeUntil_subset hb' he)) w hw
  rw [hwlen, Walk.length_reverse] at hbound
  have hQ : Q.length ≤ p.length := by omega
  refine ⟨Q.reverse, le_antisymm ?_ (dist_le Q.reverse), ?_⟩
  · rw [Walk.length_reverse]
    exact hQ.trans_eq hp
  · intro f hf
    exact hq (q.edges_dropUntil_subset hb' (by simpa [Walk.edges_reverse] using hf))

#print axioms URF.EntropyBridge.UndirectedCycle.exists_shortest_walk_on_cycle

end URF.EntropyBridge

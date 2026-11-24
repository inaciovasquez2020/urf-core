import CactusLength

namespace URF.EntropyBridge

open SimpleGraph

variable {V : Type*} [LinearOrder V] [Fintype V] {G : SimpleGraph V}

/-- An alternate walk around a cycle edge is at least as long as the complementary arc. -/
theorem UndirectedCycle.length_le_of_avoiding_edge (C : UndirectedCycle G)
    (hcat : IsCactus G) {a b : V} (h : G.Adj a b) (he : s(a, b) ∈ C.val)
    (p : G.Walk b a) (hp : s(a, b) ∉ p.edges) : C.length ≤ p.length + 1 := by
  classical
  let q := Walk.cons h p.bypass
  have hq : q.IsCycle := (Walk.cons_isCycle_iff p.bypass h).mpr
    ⟨Walk.bypass_isPath p, fun hm => hp (p.edges_bypass_subset hm)⟩
  let D : UndirectedCycle G := ⟨q.edges.toFinset, ⟨a, q, hq, rfl⟩⟩
  have hm : s(a, b) ∈ D.val := by
    change s(a, b) ∈ (Walk.cons h p.bypass).edges.toFinset
    simp [Walk.edges_cons]
  have hCD : C = D := by
    by_contra hne
    exact (Finset.disjoint_left.mp (hcat hne) he) hm
  rw [hCD]
  change q.edges.toFinset.card ≤ _
  rw [List.toFinset_card_of_nodup hq.isCircuit.isTrail.edges_nodup, Walk.length_edges]
  exact Nat.add_le_add_right (Walk.length_bypass_le p) 1

#print axioms UndirectedCycle.length_le_of_avoiding_edge

end URF.EntropyBridge

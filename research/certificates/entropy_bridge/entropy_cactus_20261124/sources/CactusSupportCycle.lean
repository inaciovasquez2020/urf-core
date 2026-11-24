import CactusCut

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Every nonzero coordinate of a kernel chain belongs to a simple cycle in its support. -/
theorem kernel_support_contains_cycle
    (z : LinearMap.ker (simpleGraphBoundary (K := K) G))
    (e : OrderedEdge G) (he : z.val e ≠ 0) :
    ∃ C : UndirectedCycle G, orderedEdgeKey e ∈ C.val ∧
      ∀ f : OrderedEdge G, orderedEdgeKey f ∈ C.val → z.val f ≠ 0 := by
  classical
  let H : SimpleGraph V := G ⊓ fromEdgeSet (orderedEdgeKey '' {f | z.val f ≠ 0})
  have hle : H ≤ G := inf_le_left
  have hadj (f : OrderedEdge G) : H.Adj f.val.1 f.val.2 ↔ z.val f ≠ 0 := by
    change (G.Adj f.val.1 f.val.2 ∧
      orderedEdgeKey f ∈ (orderedEdgeKey '' {g | z.val g ≠ 0} : Set (Sym2 V)) ∧ f.val.1 ≠ f.val.2) ↔ z.val f ≠ 0
    constructor
    · rintro ⟨_, ⟨g, hg, hkey⟩, _⟩
      exact ((orderedEdgeKey_eq_iff _ _).mp hkey) ▸ hg
    · intro hf
      exact ⟨f.property.2, ⟨f, hf, rfl⟩, ne_of_lt f.property.1⟩
  let H' := H \ fromEdgeSet {s(e.val.1, e.val.2)}
  have hr : H'.Reachable e.val.1 e.val.2 := by
    by_contra hn
    let S : Finset V := Finset.univ.filter (H'.Reachable e.val.1)
    have hmem (v : V) : v ∈ S ↔ H'.Reachable e.val.1 v := by simp [S]
    have h₁ : e.val.1 ∈ S := (hmem _).mpr SimpleGraph.Reachable.rfl
    have h₂ : e.val.2 ∉ S := fun hh => hn ((hmem _).mp hh)
    have hFlux := simpleGraphBoundary_sum_cut z.val S
    rw [LinearMap.mem_ker.mp z.property] at hFlux
    simp only [Pi.zero_apply, Finset.sum_const_zero] at hFlux
    rw [Finset.sum_eq_single e] at hFlux
    · have hz : (0 : K) = -z.val e := by simpa [h₁, h₂] using hFlux
      exact he (neg_eq_zero.mp hz.symm)
    · intro f _ hne
      by_cases hf : z.val f = 0
      · simp [hf]
      · have hmiss : s(f.val.1, f.val.2) ∉ ({s(e.val.1, e.val.2)} : Set (Sym2 V)) := by
          intro hm
          exact hne ((orderedEdgeKey_eq_iff _ _).mp (Set.mem_singleton_iff.mp hm))
        have hfAdj : H'.Adj f.val.1 f.val.2 := by
          change H.Adj f.val.1 f.val.2 ∧
            ¬ (fromEdgeSet {s(e.val.1, e.val.2)}).Adj f.val.1 f.val.2
          exact ⟨(hadj f).mpr hf, fun ha => hmiss ha.1⟩
        have hsame : f.val.2 ∈ S ↔ f.val.1 ∈ S := by
          rw [hmem, hmem]
          exact ⟨fun h => h.trans hfAdj.symm.reachable, fun h => h.trans hfAdj.reachable⟩
        by_cases h : f.val.1 ∈ S <;> simp [hsame, h]
    · simp
  obtain ⟨u, p, hp, hep⟩ :=
    adj_and_reachable_delete_edges_iff_exists_cycle.mp ⟨(hadj e).mpr he, hr⟩
  let c := p.mapLe hle
  have hc : c.IsCycle := hp.mapLe hle
  have hEdges : c.edges = p.edges := p.edges_mapLe_eq_edges hle
  let C : UndirectedCycle G := ⟨c.edges.toFinset, ⟨u, c, hc, rfl⟩⟩
  refine ⟨C, List.mem_toFinset.mpr (hEdges.symm ▸ hep), ?_⟩
  intro f hf
  have hfp : s(f.val.1, f.val.2) ∈ p.edges :=
    hEdges ▸ List.mem_toFinset.mp hf
  exact (hadj f).mp (p.adj_of_mem_edges hfp)

#print axioms URF.EntropyBridge.kernel_support_contains_cycle

end URF.EntropyBridge

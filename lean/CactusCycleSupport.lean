import CactusSupport

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Along a trail, each present edge has exactly one signed contribution. -/
theorem walkChain_ne_zero_iff {a b : V} (p : G.Walk a b) (hp : p.edges.Nodup)
    (e : OrderedEdge G) :
    walkChain (K := K) p e ≠ 0 ↔ orderedEdgeKey e ∈ p.edges := by
  classical
  induction p with
  | nil => simp [walkChain]
  | @cons a b c h p ih =>
    simp only [Walk.edges_cons, List.nodup_cons] at hp
    simp only [walkChain, Pi.add_apply, Walk.edges_cons, List.mem_cons]
    by_cases he : orderedEdgeKey e = s(a, b)
    · have ht : walkChain (K := K) p e = 0 := by
        by_contra hn
        exact hp.1 (he ▸ (ih hp.2).mp hn)
      rw [ht, add_zero, orientedStep_ne_zero_iff]
      simp [he]
    · have hs : orientedStep (K := K) h e = 0 := by
        by_contra hn
        exact he ((orientedStep_ne_zero_iff (K := K) h e).mp hn)
      rw [hs, zero_add, ih hp.2]
      simp [he]

#print axioms URF.EntropyBridge.walkChain_ne_zero_iff

/-- The concrete incidence-kernel chain has exactly the edges defining its cycle. -/
theorem cycleChain_ne_zero_iff (C : UndirectedCycle G) (e : OrderedEdge G) :
    cycleChain (K := K) C e ≠ 0 ↔ orderedEdgeKey e ∈ C.val := by
  classical
  rw [cycleChain, walkChain_ne_zero_iff C.walk C.walk_spec.1.isCircuit.isTrail.edges_nodup,
    ← C.walk_spec.2, List.mem_toFinset]

#print axioms URF.EntropyBridge.cycleChain_ne_zero_iff

end URF.EntropyBridge

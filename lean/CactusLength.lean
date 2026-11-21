import CactusIndex

namespace URF.EntropyBridge

variable {V : Type*} [LinearOrder V] [Fintype V] {G : SimpleGraph V}

theorem UndirectedCycle.walk_length (C : UndirectedCycle G) :
    C.walk.length = C.length := by
  classical
  rw [UndirectedCycle.length, ← C.walk_spec.2,
    List.toFinset_card_of_nodup C.walk_spec.1.isCircuit.isTrail.edges_nodup,
    SimpleGraph.Walk.length_edges]

#print axioms UndirectedCycle.walk_length

end URF.EntropyBridge

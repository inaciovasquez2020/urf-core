import GraphEntropy
import CactusIndex

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V} {u v : V}

/-- The unit chain for traversing an edge, with sign in the fixed edge orientation. -/
noncomputable def orientedStep (h : G.Adj u v) : OrderedEdge G → K := by
  classical
  exact if huv : u < v then Pi.single (⟨(u, v), huv, h⟩ : OrderedEdge G) 1
    else -Pi.single (⟨(v, u), lt_of_le_of_ne (le_of_not_gt huv) h.ne.symm, h.symm⟩ :
      OrderedEdge G) 1

theorem boundary_orientedStep (h : G.Adj u v) :
    simpleGraphBoundary (K := K) G (orientedStep h) =
      Pi.single v 1 - Pi.single u 1 := by
  classical
  unfold orientedStep
  split_ifs with huv
  · funext x
    simp only [simpleGraphBoundary, Matrix.mulVecLin_apply, Matrix.mulVec_single_one]
    by_cases xu : x = u
    · subst x
      simp [simpleGraphIncidence, Pi.single_apply, h.ne]
    · by_cases xv : x = v
      · subst x
        simp [simpleGraphIncidence, Pi.single_apply, xu]
      · simp [simpleGraphIncidence, Pi.single_apply, xu, xv]
  · rw [map_neg]
    funext x
    simp only [Pi.neg_apply, simpleGraphBoundary, Matrix.mulVecLin_apply,
      Matrix.mulVec_single_one]
    by_cases xv : x = v
    · subst x
      simp [simpleGraphIncidence, Pi.single_apply, h.ne.symm]
    · by_cases xu : x = u
      · subst x
        simp [simpleGraphIncidence, Pi.single_apply, xv]
      · simp [simpleGraphIncidence, Pi.single_apply, xu, xv]

#print axioms boundary_orientedStep

/-- Sum of signed edge traversals along a walk. -/
noncomputable def walkChain : {a b : V} → G.Walk a b → OrderedEdge G → K
  | _, _, .nil => 0
  | _, _, .cons h p => orientedStep h + walkChain p

theorem boundary_walkChain (p : G.Walk u v) :
    simpleGraphBoundary (K := K) G (walkChain p) =
      Pi.single v 1 - Pi.single u 1 := by
  induction p with
  | nil => simp [walkChain]
  | cons h p ih =>
    rw [walkChain, map_add, boundary_orientedStep, ih]
    abel

#print axioms boundary_walkChain


/-- The oriented chain of the chosen representative of a simple undirected cycle. -/
noncomputable def cycleChain (C : UndirectedCycle G) : OrderedEdge G → K :=
  walkChain C.walk

theorem boundary_cycleChain (C : UndirectedCycle G) :
    simpleGraphBoundary (K := K) G (cycleChain C) = 0 := by
  rw [cycleChain, boundary_walkChain, sub_self]

/-- A simple-cycle chain bundled as an element of the concrete incidence kernel. -/
noncomputable def cycleVector (C : UndirectedCycle G) :
    LinearMap.ker (simpleGraphBoundary (K := K) G) :=
  ⟨cycleChain C, LinearMap.mem_ker.mpr (boundary_cycleChain C)⟩

#print axioms boundary_cycleChain
#print axioms cycleVector

end URF.EntropyBridge

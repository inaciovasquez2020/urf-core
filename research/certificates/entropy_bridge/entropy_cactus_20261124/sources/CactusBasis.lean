import CactusSpanning

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- The actual oriented cycle chains give a basis of the concrete cactus kernel. -/
noncomputable def cactusCycleBasis (hcat : IsCactus G) :
    Module.Basis (UndirectedCycle G) K (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  Module.Basis.mk (cactus_cycleVector_linearIndependent hcat)
    (le_of_eq (cycleVector_span_eq_top (K := K) (G := G)).symm)

theorem cactusCycleBasis_apply (hcat : IsCactus G) (C : UndirectedCycle G) :
    cactusCycleBasis (K := K) hcat C = cycleVector (K := K) C :=
  Module.Basis.mk_apply _ _ C

#print axioms URF.EntropyBridge.cactusCycleBasis
#print axioms URF.EntropyBridge.cactusCycleBasis_apply

end URF.EntropyBridge

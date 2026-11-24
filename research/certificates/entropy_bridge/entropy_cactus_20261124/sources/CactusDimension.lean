import CactusAssembly

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- The dimension of the true radius-local space counts short cactus cycles. -/
theorem reachableRadiusBallCycleSpace_finrank (hcat : IsCactus G) (r : ℕ) :
    Module.finrank K (reachableRadiusBallCycleSpace (K := K) G r) =
      Fintype.card (ShortCycle G r) := by
  rw [reachableRadiusBallCycleSpace_eq_short_span hcat r]
  exact finrank_span_eq_card ((cactus_cycleVector_linearIndependent (K := K) hcat).comp
    (fun C : ShortCycle G r => C.val) Subtype.val_injective)

#print axioms URF.EntropyBridge.reachableRadiusBallCycleSpace_finrank

end URF.EntropyBridge

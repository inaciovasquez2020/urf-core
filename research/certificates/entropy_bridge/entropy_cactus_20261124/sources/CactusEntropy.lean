import CactusDimension

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Cycles longer than the visibility threshold. -/
def LongCycle (G : SimpleGraph V) (r : ℕ) := {C : UndirectedCycle G // ¬ C.length ≤ 2 * r + 1}

noncomputable instance (r : ℕ) : Fintype (LongCycle G r) := by
  classical
  unfold LongCycle
  infer_instance

/-- Conditional entropy of the uniform dual of the concrete incidence kernel,
given restriction to the actual reachability-corrected radius-local space. -/
noncomputable def reachableRadiusUniformConditionalEntropy [Fintype K]
    (G : SimpleGraph V) (r : ℕ) : ℝ := by
  let P := reachableRadiusGraphChain (K := K) G r
  letI : Finite (Module.Dual K (graphCycles P)) := Module.finite_of_finite K
  letI : Finite (Module.Dual K P.localCycles) := Module.finite_of_finite K
  letI : Fintype (Module.Dual K (graphCycles P)) := Fintype.ofFinite _
  letI : Fintype (Module.Dual K P.localCycles) := Fintype.ofFinite _
  exact ∑ y : Module.Dual K P.localCycles,
    observedMass (uniformFiniteProbability (Module.Dual K (graphCycles P))).mass
      (graphObservation P) y *
    finiteEntropy (conditionalMass
      (uniformFiniteProbability (Module.Dual K (graphCycles P))).mass
      (graphObservation P) y)

/-- Each long cactus cycle contributes exactly log of the field size. -/
theorem cactus_uniform_conditional_entropy_eq [Fintype K] (hcat : IsCactus G) (r : ℕ) :
    reachableRadiusUniformConditionalEntropy (K := K) G r =
      (Fintype.card (LongCycle G r) : ℝ) * Real.log (Fintype.card K) := by
  unfold reachableRadiusUniformConditionalEntropy
  rw [graphObservation_uniform_entropy_eq_finrank_gap]
  change ((Module.finrank K (LinearMap.ker (simpleGraphBoundary (K := K) G)) -
      Module.finrank K (reachableRadiusBallCycleSpace (K := K) G r) : ℕ) : ℝ) *
      Real.log (Fintype.card K) = _
  rw [Module.finrank_eq_card_basis (cactusCycleBasis (K := K) hcat),
    reachableRadiusBallCycleSpace_finrank hcat r]
  have hcard : Fintype.card (LongCycle G r) =
      Fintype.card (UndirectedCycle G) - Fintype.card (ShortCycle G r) :=
    Fintype.card_subtype_compl (fun C : UndirectedCycle G => C.length ≤ 2 * r + 1)
  rw [hcard]

#print axioms URF.EntropyBridge.reachableRadiusUniformConditionalEntropy
#print axioms URF.EntropyBridge.cactus_uniform_conditional_entropy_eq

end URF.EntropyBridge

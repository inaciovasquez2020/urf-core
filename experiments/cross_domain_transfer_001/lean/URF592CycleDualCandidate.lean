import Mathlib

/-!
URF PR #592: concrete graph gauge quotient/cycle duality and finite-field
uniform observation entropy.
PIN: leanprover/lean4:v4.27.0, mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900.
VERIFICATION: load-bearing declarations compiled in pinned GitHub Actions;
#print axioms output permits only propext, Classical.choice, Quot.sound.
SCOPE: finite oriented edge sets, vertex coboundary gauges, locally supported
cycles and uniform conditional distributions on finite-field observation fibers.
Not an unrestricted Shannon identity or a novel general rigidity theorem.
-/

noncomputable section

namespace URF.Transfer.CycleDual

open Module

universe u v
variable {K : Type u} [Field K]
variable {Global Local : Type v}
variable [AddCommGroup Global] [Module K Global]
variable [AddCommGroup Local] [Module K Local]

/-- The dual of local-cycle inclusion evaluates a global functional on the
    included local cycle. This is the restriction/transpose compatibility. -/
theorem restriction_dual_apply
    (includeCycles : Local →ₗ[K] Global)
    (φ : Module.Dual K Global) (z : Local) :
    includeCycles.dualMap φ z = φ (includeCycles z) := rfl

/-- A functional is invisible under the dual restriction exactly when it
    vanishes on every locally included cycle. -/
theorem hidden_iff_annihilates_local_cycles
    (includeCycles : Local →ₗ[K] Global)
    (φ : Module.Dual K Global) :
    φ ∈ LinearMap.ker includeCycles.dualMap ↔
      ∀ z : Local, φ (includeCycles z) = 0 := by
  constructor
  · intro h z
    have hz := congrArg (fun ψ : Module.Dual K Local => ψ z)
      (LinearMap.mem_ker.mp h)
    simpa [restriction_dual_apply] using hz
  · intro h
    apply LinearMap.mem_ker.mpr
    ext z
    exact h z

/-- Rank-nullity for a local-cycle inclusion and its dual observation.
    The rank is the dimension of the span of the included local cycles. -/
theorem observed_add_hidden_eq_global_dual
    [FiniteDimensional K Global] [FiniteDimensional K Local]
    (includeCycles : Local →ₗ[K] Global) :
    Module.finrank K (LinearMap.range includeCycles) +
      Module.finrank K (LinearMap.ker includeCycles.dualMap) =
        Module.finrank K (Module.Dual K Global) := by
  have h := LinearMap.finrank_range_add_finrank_ker includeCycles.dualMap
  rw [LinearMap.finrank_range_dualMap_eq_finrank_range] at h
  exact h

/-- Generic rank-nullity for a surjective measurement into the dual of a
    local space, when the global measurement domain is the dual of a global
    space. This lemma deliberately contains no graph-specific definitions. -/
theorem surjective_dual_observation_hidden_finrank
    {Q GlobalCycles LocalCycles : Type v}
    [AddCommGroup Q] [Module K Q]
    [AddCommGroup GlobalCycles] [Module K GlobalCycles]
    [AddCommGroup LocalCycles] [Module K LocalCycles]
    [FiniteDimensional K Q]
    [FiniteDimensional K GlobalCycles]
    [FiniteDimensional K LocalCycles]
    (f : Q →ₗ[K] Module.Dual K LocalCycles)
    (hf : Function.Surjective f)
    (e : Q ≃ₗ[K] Module.Dual K GlobalCycles) :
    Module.finrank K LocalCycles + Module.finrank K (LinearMap.ker f) =
      Module.finrank K GlobalCycles := by
  classical
  have h := LinearMap.finrank_range_add_finrank_ker f
  rw [LinearMap.range_eq_top.mpr hf, finrank_top] at h
  have hlocal :
      Module.finrank K (Module.Dual K LocalCycles) =
        Module.finrank K LocalCycles :=
    (Basis.ofVectorSpace K LocalCycles).toDualEquiv.symm.finrank_eq
  have hglobal :
      Module.finrank K (Module.Dual K GlobalCycles) =
        Module.finrank K GlobalCycles :=
    (Basis.ofVectorSpace K GlobalCycles).toDualEquiv.symm.finrank_eq
  calc
    _ = Module.finrank K (Module.Dual K LocalCycles) +
        Module.finrank K (LinearMap.ker f) := by rw [hlocal]
    _ = Module.finrank K Q := h
    _ = Module.finrank K (Module.Dual K GlobalCycles) := e.finrank_eq
    _ = Module.finrank K GlobalCycles := hglobal

#print axioms surjective_dual_observation_hidden_finrank

end URF.Transfer.CycleDual

#print axioms URF.Transfer.CycleDual.restriction_dual_apply
#print axioms URF.Transfer.CycleDual.hidden_iff_annihilates_local_cycles
#print axioms URF.Transfer.CycleDual.observed_add_hidden_eq_global_dual

/-!
Graph-specific layer: finite oriented edges represented by endpoint maps.
The cycle predicate, incidence-boundary kernel, gauge quotient/cycle perfect
pairing and local observation compatibility are proved below. The subsequent
uniform finite-field Shannon theorem uses these verified graph declarations.
No abstract proofs above are altered.
-/

namespace URF.Transfer.GraphCochains

universe u₁ u₂ u₃

variable {K : Type u₁} [Field K]
variable {V : Type u₂} {E : Type u₃} [Fintype E]

/-- A choice of source and target for every oriented edge. -/
structure OrientedEdges (V : Type u₂) (E : Type u₃) where
  source : E → V
  target : E → V

/-- Vertex gauge coboundary on actual oriented edges. -/
def coboundary (G : OrientedEdges V E) (g : V → K) (e : E) : K :=
  g (G.target e) - g (G.source e)

/-- Standard finite edge-cochain pairing. -/
def edgePair (a z : E → K) : K :=
  ∑ e : E, a e * z e

/-- The annihilator description of the cycle space.
    Kernel-of-incidence equivalence is not yet formalized. -/
def IsCycle (G : OrientedEdges V E) (z : E → K) : Prop :=
  ∀ g : V → K, edgePair (coboundary G g) z = 0

/-- A local gauge transformation does not change a cycle measurement. -/
theorem cycle_pair_gauge_invariant
    (G : OrientedEdges V E) (a z : E → K)
    (hz : IsCycle G z) (g : V → K) :
    edgePair (fun e => a e + coboundary G g e) z = edgePair a z := by
  calc
    edgePair (fun e => a e + coboundary G g e) z =
        edgePair a z + edgePair (coboundary G g) z := by
          simp [edgePair, add_mul, Finset.sum_add_distrib]
    _ = edgePair a z := by rw [hz g, add_zero]


/-- The oriented edge-incidence boundary, with incoming minus outgoing flow. -/
def incidenceBoundary [Fintype V] [DecidableEq V]
    (G : OrientedEdges V E) (z : E → K) (v : V) : K :=
  (∑ e : E, if G.target e = v then z e else 0) -
  (∑ e : E, if G.source e = v then z e else 0)

/-- The cochain/cycle pairing is the vertex pairing with the incidence boundary. -/
theorem coboundary_edgePair_eq_vertexPair
    [Fintype V] [DecidableEq V]
    (G : OrientedEdges V E) (g : V → K) (z : E → K) :
    edgePair (coboundary G g) z =
      ∑ v : V, g v * incidenceBoundary G z v := by
  have htarget :
      (∑ e : E, g (G.target e) * z e) =
        ∑ v : V, g v * (∑ e : E, if G.target e = v then z e else 0) := by
    calc
      _ = ∑ e : E, ∑ v : V, g v * (if G.target e = v then z e else 0) := by
        apply Finset.sum_congr rfl
        intro e he
        simp
      _ = ∑ v : V, ∑ e : E, g v * (if G.target e = v then z e else 0) := by
        rw [Finset.sum_comm]
      _ = ∑ v : V, g v * (∑ e : E, if G.target e = v then z e else 0) := by
        simp_rw [Finset.mul_sum]
  have hsource :
      (∑ e : E, g (G.source e) * z e) =
        ∑ v : V, g v * (∑ e : E, if G.source e = v then z e else 0) := by
    calc
      _ = ∑ e : E, ∑ v : V, g v * (if G.source e = v then z e else 0) := by
        apply Finset.sum_congr rfl
        intro e he
        simp
      _ = ∑ v : V, ∑ e : E, g v * (if G.source e = v then z e else 0) := by
        rw [Finset.sum_comm]
      _ = ∑ v : V, g v * (∑ e : E, if G.source e = v then z e else 0) := by
        simp_rw [Finset.mul_sum]
  calc
    edgePair (coboundary G g) z =
        (∑ e : E, g (G.target e) * z e) -
        (∑ e : E, g (G.source e) * z e) := by
          simp [edgePair, coboundary, sub_mul, Finset.sum_sub_distrib]
    _ = (∑ v : V, g v * (∑ e : E, if G.target e = v then z e else 0)) -
        (∑ v : V, g v * (∑ e : E, if G.source e = v then z e else 0)) := by
          rw [htarget, hsource]
    _ = ∑ v : V, g v * incidenceBoundary G z v := by
          simp [incidenceBoundary, mul_sub, Finset.sum_sub_distrib]

/-- The annihilator cycle definition is exactly the incidence boundary kernel. -/
theorem isCycle_iff_incidenceBoundary_zero
    [Fintype V] [DecidableEq V]
    (G : OrientedEdges V E) (z : E → K) :
    IsCycle G z ↔ ∀ v : V, incidenceBoundary G z v = 0 := by
  constructor
  · intro hz v
    have h := hz (fun w : V => if w = v then (1 : K) else 0)
    rw [coboundary_edgePair_eq_vertexPair] at h
    simpa using h
  · intro hz g
    rw [coboundary_edgePair_eq_vertexPair]
    simp [hz]


/-! ## Gauge quotient by the span of vertex coboundaries

This avoids a separate linearity elaboration for the coboundary function.
The canonical perfect pairing and graph-restriction map remain OPEN.
-/

/-- The submodule generated by all concrete vertex coboundaries. -/
def gaugeSpan (G : OrientedEdges V E) : Submodule K (E → K) :=
  Submodule.span K (Set.range (coboundary G : (V → K) → (E → K)))

/-- Cycle evaluation as a linear functional on edge assignments. -/
def cycleEvaluation (z : E → K) : (E → K) →ₗ[K] K where
  toFun := fun a => edgePair a z
  map_add' := by
    intro a b
    simp [edgePair, add_mul, Finset.sum_add_distrib]
  map_smul' := by
    intro c a
    simp [edgePair, Finset.mul_sum, mul_assoc]

/-- A cycle evaluation vanishes on every generator of the gauge span. -/
theorem gaugeSpan_le_cycleEvaluation_ker
    (G : OrientedEdges V E) (z : E → K) (hz : IsCycle G z) :
    gaugeSpan G ≤ LinearMap.ker (cycleEvaluation z) := by
  apply Submodule.span_le.mpr
  rintro a ⟨g, rfl⟩
  exact LinearMap.mem_ker.mpr (hz g)

/-- Gauge-invariant cycle measurement descends to the gauge-class quotient. -/
def cycleEvaluationOnGauge
    (G : OrientedEdges V E) (z : E → K) (hz : IsCycle G z) :
    ((E → K) ⧸ gaugeSpan (K := K) G) →ₗ[K] K :=
  (gaugeSpan (K := K) G).liftQ (cycleEvaluation z)
    (gaugeSpan_le_cycleEvaluation_ker G z hz)

/-- The quotient measurement agrees with its chosen edge representative. -/
theorem cycleEvaluationOnGauge_mk
    (G : OrientedEdges V E) (z : E → K) (hz : IsCycle G z)
    (a : E → K) :
    cycleEvaluationOnGauge G z hz ((gaugeSpan (K := K) G).mkQ a) =
      edgePair a z := by
  rfl


/-- The cycle predicate is precisely the orthogonality condition against
    the entire submodule generated by vertex coboundaries. -/
theorem isCycle_iff_annihilates_gaugeSpan
    (G : OrientedEdges V E) (z : E → K) :
    IsCycle G z ↔
      ∀ a : E → K, a ∈ gaugeSpan G → edgePair a z = 0 := by
  constructor
  · intro hz a ha
    exact LinearMap.mem_ker.mp (gaugeSpan_le_cycleEvaluation_ker G z hz ha)
  · intro h g
    apply h (coboundary G g)
    change coboundary G g ∈
      Submodule.span K (Set.range (coboundary G : (V → K) → (E → K)))
    exact Submodule.subset_span (Set.mem_range_self g)


/-! This is a noncanonical finite-dimensional quotient equivalence supplied
by mathlib. It is NOT the natural graph pairing or the graph restriction theorem. -/

/-- Annihilator subspace of the concrete gauge submodule in the cochain dual. -/
def gaugeDualAnnihilator (G : OrientedEdges V E) :
    Submodule K (Module.Dual K (E → K)) :=
  (gaugeSpan (K := K) G).dualAnnihilator

/-- A basis-dependent linear equivalence, not the desired canonical pairing. -/
noncomputable def gaugeQuotientAnnihilatorEquiv
    [FiniteDimensional K (E → K)] (G : OrientedEdges V E) :
    ((E → K) ⧸ gaugeSpan (K := K) G) ≃ₗ[K]
      gaugeDualAnnihilator (K := K) G :=
  Subspace.quotEquivAnnihilator (gaugeSpan (K := K) G)

/-- The finite-dimensional complement formula for actual vertex gauge spans. -/
theorem gauge_finrank_plus_annihilator
    [FiniteDimensional K (E → K)] (G : OrientedEdges V E) :
    Module.finrank K (gaugeSpan (K := K) G) +
      Module.finrank K (gaugeDualAnnihilator (K := K) G) =
        Module.finrank K (E → K) := by
  exact Subspace.finrank_add_finrank_dualAnnihilator_eq (gaugeSpan (K := K) G)


/-- The standard edge-coordinate basis identifies cochains with linear functionals. -/
noncomputable def edgeCoordinateDualEquiv :
    (E → K) ≃ₗ[K] Module.Dual K (E → K) := by
  classical
  exact (Pi.basisFun K E).toDualEquiv

/-- The coordinate-dual equivalence evaluates by the concrete finite edge pairing. -/
theorem edgeCoordinateDualEquiv_apply (z a : E → K) :
    edgeCoordinateDualEquiv (K := K) (E := E) z a = edgePair a z := by
  classical
  have h : edgeCoordinateDualEquiv (K := K) (E := E) z =
      cycleEvaluation z := by
    apply (Pi.basisFun K E).ext
    intro e
    change ((Pi.basisFun K E).toDual z) ((Pi.basisFun K E) e) =
      edgePair ((Pi.basisFun K E) e) z
    rw [Module.Basis.toDual_apply_left]
    simp [edgePair, Pi.basisFun_apply, Pi.single_apply]
  exact congrArg (fun φ : Module.Dual K (E → K) => φ a) h


/-- Concrete graph cycles are the inverse image of the gauge annihilator
    under the standard coordinate duality. -/
noncomputable def cycleSubspace (G : OrientedEdges V E) : Submodule K (E → K) :=
  (gaugeSpan (K := K) G).dualAnnihilator.comap
    (edgeCoordinateDualEquiv (K := K) (E := E)).toLinearMap

/-- Cycle-submodule membership equals the existing graph cycle predicate. -/
theorem mem_cycleSubspace_iff (G : OrientedEdges V E) (z : E → K) :
    z ∈ cycleSubspace G ↔ IsCycle G z := by
  rw [isCycle_iff_annihilates_gaugeSpan]
  simp only [cycleSubspace, Submodule.mem_comap, Submodule.mem_dualAnnihilator]
  constructor
  · intro hz a ha
    exact (edgeCoordinateDualEquiv_apply (K := K) (E := E) z a).symm.trans (hz a ha)
  · intro hz a ha
    exact (edgeCoordinateDualEquiv_apply (K := K) (E := E) z a).trans (hz a ha)

/-- The graph cycle submodule is precisely the incidence-boundary kernel. -/
theorem mem_cycleSubspace_iff_incidence_zero
    [Fintype V] [DecidableEq V] (G : OrientedEdges V E) (z : E → K) :
    z ∈ cycleSubspace G ↔ ∀ v : V, incidenceBoundary G z v = 0 := by
  rw [mem_cycleSubspace_iff, isCycle_iff_incidenceBoundary_zero]


/-- Evaluation of an edge assignment on the concrete cycle submodule. -/
noncomputable def graphPairingLinear (G : OrientedEdges V E) :
    (E → K) →ₗ[K] Module.Dual K (cycleSubspace (K := K) G) :=
  (cycleSubspace (K := K) G).dualRestrict.comp
    (edgeCoordinateDualEquiv (K := K) (E := E)).toLinearMap

/-- Graph pairing is exactly the finite edge dot product. -/
theorem graphPairingLinear_apply (G : OrientedEdges V E)
    (a : E → K) (z : cycleSubspace (K := K) G) :
    graphPairingLinear G a z = edgePair a (z : E → K) := by
  calc
    graphPairingLinear G a z = edgePair (z : E → K) a := by
      exact edgeCoordinateDualEquiv_apply (K := K) (E := E) a (z : E → K)
    _ = edgePair a (z : E → K) := by
      simp [edgePair, mul_comm]

/-- Every functional on the graph cycle submodule arises from an edge cochain. -/
theorem graphPairingLinear_surjective (G : OrientedEdges V E) :
    Function.Surjective (graphPairingLinear (K := K) G) := by
  intro φ
  have hsurj : Function.Surjective ((cycleSubspace (K := K) G).dualRestrict) :=
    Subspace.dualRestrict_surjective
  obtain ⟨ψ, hψ⟩ := hsurj φ
  obtain ⟨a, ha⟩ :=
    (edgeCoordinateDualEquiv (K := K) (E := E)).surjective ψ
  refine ⟨a, ?_⟩
  change (cycleSubspace (K := K) G).dualRestrict
    (edgeCoordinateDualEquiv (K := K) (E := E) a) = φ
  rw [ha]
  exact hψ


/-- Vanishing on every graph cycle is equivalent to being a vertex gauge cochain. -/
theorem graphPairingLinear_ker_eq_gaugeSpan (G : OrientedEdges V E) :
    LinearMap.ker (graphPairingLinear (K := K) G) = gaugeSpan (K := K) G := by
  ext a
  constructor
  · intro ha
    apply (Subspace.forall_mem_dualAnnihilator_apply_eq_zero_iff
      (gaugeSpan (K := K) G) a).mp
    intro φ hφ
    let z : E → K := (edgeCoordinateDualEquiv (K := K) (E := E)).symm φ
    have hz : z ∈ cycleSubspace (K := K) G := by
      change edgeCoordinateDualEquiv (K := K) (E := E) z ∈
        (gaugeSpan (K := K) G).dualAnnihilator
      simpa [z] using hφ
    have hzero : graphPairingLinear (K := K) G a ⟨z, hz⟩ = 0 := by
      have h := LinearMap.mem_ker.mp ha
      simpa using congrArg (fun ψ : Module.Dual K (cycleSubspace (K := K) G) =>
        ψ ⟨z, hz⟩) h
    have hpair : edgePair a z = 0 := by
      rw [graphPairingLinear_apply] at hzero
      exact hzero
    calc
      φ a = edgeCoordinateDualEquiv (K := K) (E := E) z a := by simp [z]
      _ = edgePair a z := edgeCoordinateDualEquiv_apply z a
      _ = 0 := hpair
  · intro ha
    apply LinearMap.mem_ker.mpr
    ext z
    have hz : IsCycle G (z : E → K) :=
      (mem_cycleSubspace_iff G (z : E → K)).mp z.property
    have hpair := (isCycle_iff_annihilates_gaugeSpan G (z : E → K)).mp hz a ha
    simpa only [graphPairingLinear_apply, LinearMap.zero_apply] using hpair


/-- The natural perfect graph pairing: edge cochains modulo vertex gauges
    are linearly equivalent to functionals on the concrete graph cycle space. -/
noncomputable def graphGaugeQuotientEquivCycleDual
    (G : OrientedEdges V E) :
    ((E → K) ⧸ gaugeSpan (K := K) G) ≃ₗ[K]
      Module.Dual K (cycleSubspace (K := K) G) :=
  (Submodule.quotEquivOfEq
    (gaugeSpan (K := K) G)
    (LinearMap.ker (graphPairingLinear (K := K) G))
    (graphPairingLinear_ker_eq_gaugeSpan G).symm).trans
    ((graphPairingLinear (K := K) G).quotKerEquivOfSurjective
      (graphPairingLinear_surjective G))


/-- The perfect graph pairing on a gauge class is the finite edge dot product
    of any representative with a concrete cycle. -/
theorem graphGaugeQuotientEquivCycleDual_mk
    (G : OrientedEdges V E) (a : E → K)
    (z : cycleSubspace (K := K) G) :
    graphGaugeQuotientEquivCycleDual (K := K) G
      ((gaugeSpan (K := K) G).mkQ a) z =
        edgePair a (z : E → K) := by
  change graphPairingLinear G a z = edgePair a (z : E → K)
  exact graphPairingLinear_apply G a z


/-- Cycles supported entirely inside a selected set of graph edges. -/
noncomputable def supportedLocalCycles
    (G : OrientedEdges V E) (S : Set E) :
    Submodule K (cycleSubspace (K := K) G) where
  carrier := {z | ∀ e : E, e ∉ S → (z : E → K) e = 0}
  zero_mem' := by
    intro e he
    rfl
  add_mem' := by
    intro a b ha hb e he
    simp [ha e he, hb e he]
  smul_mem' := by
    intro c a ha e he
    simp [ha e he]

/-- Local gauge-class observations are dual restriction to supported cycles. -/
noncomputable def localCycleObservation
    (G : OrientedEdges V E) (S : Set E) :
    ((E → K) ⧸ gaugeSpan (K := K) G) →ₗ[K]
      Module.Dual K (supportedLocalCycles (K := K) G S) :=
  (supportedLocalCycles (K := K) G S).dualRestrict.comp
    (graphGaugeQuotientEquivCycleDual (K := K) G).toLinearMap

/-- Graph restriction is precisely the dual of local-cycle inclusion. -/
theorem localCycleObservation_eq_dual_inclusion
    (G : OrientedEdges V E) (S : Set E) :
    localCycleObservation (K := K) G S =
      (supportedLocalCycles (K := K) G S).subtype.dualMap.comp
        (graphGaugeQuotientEquivCycleDual (K := K) G).toLinearMap := rfl

/-- A local cycle measures an edge cochain by its original edge pairing. -/
theorem localCycleObservation_mk
    (G : OrientedEdges V E) (S : Set E)
    (a : E → K) (z : supportedLocalCycles (K := K) G S) :
    localCycleObservation (K := K) G S ((gaugeSpan (K := K) G).mkQ a) z =
      edgePair a (z : E → K) := by
  change graphGaugeQuotientEquivCycleDual (K := K) G
    ((gaugeSpan (K := K) G).mkQ a) (z : cycleSubspace (K := K) G) =
      edgePair a (z : E → K)
  exact graphGaugeQuotientEquivCycleDual_mk G a z


/-- Every local-cycle functional comes from a global gauge class. -/
theorem localCycleObservation_surjective
    (G : OrientedEdges V E) (S : Set E) :
    Function.Surjective (localCycleObservation (K := K) G S) := by
  intro φ
  have hlocal : Function.Surjective
      ((supportedLocalCycles (K := K) G S).dualRestrict) :=
    Subspace.dualRestrict_surjective
  obtain ⟨ψ, hψ⟩ := hlocal φ
  obtain ⟨q, hq⟩ :=
    (graphGaugeQuotientEquivCycleDual (K := K) G).surjective ψ
  refine ⟨q, ?_⟩
  change (supportedLocalCycles (K := K) G S).dualRestrict
    (graphGaugeQuotientEquivCycleDual (K := K) G q) = φ
  rw [hq]
  exact hψ

set_option maxHeartbeats 800000

/-- Concrete graph-local rank/nullity, instantiated from the verified abstract
    result without unfolding the local-cycle observation definitions. -/
theorem localCycleObservation_hidden_finrank
    (G : OrientedEdges V E) (S : Set E) :
    Module.finrank K (supportedLocalCycles (K := K) G S) +
      Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) =
        Module.finrank K (cycleSubspace (K := K) G) := by
  let f : ((E → K) ⧸ gaugeSpan (K := K) G) →ₗ[K]
      Module.Dual K (supportedLocalCycles (K := K) G S) :=
    localCycleObservation (K := K) G S
  let e : ((E → K) ⧸ gaugeSpan (K := K) G) ≃ₗ[K]
      Module.Dual K (cycleSubspace (K := K) G) :=
    graphGaugeQuotientEquivCycleDual (K := K) G
  have hf : Function.Surjective f :=
    localCycleObservation_surjective (K := K) G S
  have h := URF.Transfer.CycleDual.surjective_dual_observation_hidden_finrank
    (K := K)
    (Q := ((E → K) ⧸ gaugeSpan (K := K) G))
    (GlobalCycles := cycleSubspace (K := K) G)
    (LocalCycles := supportedLocalCycles (K := K) G S)
    f hf e
  exact h

#print axioms localCycleObservation_hidden_finrank

#print axioms localCycleObservation_surjective

#print axioms localCycleObservation_eq_dual_inclusion
#print axioms localCycleObservation_mk

#print axioms graphGaugeQuotientEquivCycleDual_mk

#print axioms graphGaugeQuotientEquivCycleDual

#print axioms graphPairingLinear_ker_eq_gaugeSpan

#print axioms graphPairingLinear_apply
#print axioms graphPairingLinear_surjective

#print axioms mem_cycleSubspace_iff
#print axioms mem_cycleSubspace_iff_incidence_zero

#print axioms edgeCoordinateDualEquiv_apply

#print axioms gaugeQuotientAnnihilatorEquiv
#print axioms gauge_finrank_plus_annihilator

#print axioms isCycle_iff_annihilates_gaugeSpan

#print axioms gaugeSpan_le_cycleEvaluation_ker
#print axioms cycleEvaluationOnGauge
#print axioms cycleEvaluationOnGauge_mk

#print axioms coboundary_edgePair_eq_vertexPair
#print axioms isCycle_iff_incidenceBoundary_zero

#print axioms cycle_pair_gauge_invariant

end URF.Transfer.GraphCochains


/-!
Uniform finite-field observation: any populated fiber is an affine translate
of the linear kernel. The cardinality and logarithmic results below require
finite-field structure and finite-dimensional domain. Arbitrary probability
distributions are not covered by these results.
-/
namespace URF.Transfer.UniformObservationEntropy

universe u v w

variable {K : Type u} [Field K] [Finite K]
variable {Q : Type v} {Y : Type w}
variable [AddCommGroup Q] [Module K Q] [FiniteDimensional K Q]
variable [AddCommGroup Y] [Module K Y]

/-- The fiber above an attained value is an affine copy of the kernel. -/
noncomputable def fiberEquivKernel (f : Q →ₗ[K] Y) (x : Q) :
    {z : Q // f z = f x} ≃ LinearMap.ker f where
  toFun := fun z => ⟨z.val - x, by
    change f (z.val - x) = 0
    rw [map_sub, z.property, sub_self]⟩
  invFun := fun z => ⟨z.val + x, by
    change f (z.val + x) = f x
    rw [map_add, (LinearMap.mem_ker.mp z.property), zero_add]⟩
  left_inv := by
    intro z
    apply Subtype.ext
    simp
  right_inv := by
    intro z
    apply Subtype.ext
    simp

/-- Exact finite-field cardinality of any populated observation fiber. -/
theorem fiber_natCard_eq_pow_ker_finrank
    (f : Q →ₗ[K] Y) (x : Q) :
    Nat.card {z : Q // f z = f x} =
      (Nat.card K) ^ Module.finrank K (LinearMap.ker f) := by
  calc
    Nat.card {z : Q // f z = f x} = Nat.card (LinearMap.ker f) :=
      Nat.card_congr (fiberEquivKernel f x)
    _ = (Nat.card K) ^ Module.finrank K (LinearMap.ker f) :=
      Module.natCard_eq_pow_finrank

/-- Pointwise entropy of the uniform conditional fiber, expressed as a log
    cardinality; the probability distribution is required to be uniform. -/
theorem uniform_fiber_log_card_eq_ker_finrank
    (f : Q →ₗ[K] Y) (x : Q) :
    Real.log (Nat.card {z : Q // f z = f x} : ℝ) =
      (Module.finrank K (LinearMap.ker f) : ℝ) *
        Real.log (Nat.card K : ℝ) := by
  rw [fiber_natCard_eq_pow_ker_finrank]
  rw [Nat.cast_pow, Real.log_pow]

/-- Shannon's discrete entropy of the uniform conditional distribution on an
    attained fiber. It is the sum of -p log p over exactly those states. -/
noncomputable def uniformFiberShannonEntropy
    [Fintype Q] (f : Q →ₗ[K] Y) (x : Q) : ℝ := by
  classical
  exact ∑ _z : {z : Q // f z = f x},
    -((1 : ℝ) / (Nat.card {z : Q // f z = f x} : ℝ)) *
      Real.log ((1 : ℝ) / (Nat.card {z : Q // f z = f x} : ℝ))

/-- Exact Shannon entropy of a uniform nonempty observation fiber. -/
theorem uniformFiberShannonEntropy_eq_log_card
    [Fintype Q] (f : Q →ₗ[K] Y) (x : Q) :
    uniformFiberShannonEntropy f x =
      Real.log (Nat.card {z : Q // f z = f x} : ℝ) := by
  classical
  let F := {z : Q // f z = f x}
  have hne : Nonempty F := ⟨⟨x, rfl⟩⟩
  have hn : (Nat.card F : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.card_pos (α := F)).ne'
  have hcard : (Fintype.card F : ℝ) = (Nat.card F : ℝ) := by
    simp [Nat.card_eq_fintype_card]
  have hlog :
      Real.log ((1 : ℝ) / (Nat.card F : ℝ)) =
        -Real.log (Nat.card F : ℝ) := by
    simp [one_div, Real.log_inv]
  unfold uniformFiberShannonEntropy
  change (∑ _z : F, -((1 : ℝ) / (Nat.card F : ℝ)) *
      Real.log ((1 : ℝ) / (Nat.card F : ℝ))) =
        Real.log (Nat.card F : ℝ)
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  rw [hcard, hlog]
  field_simp

/-- Uniform conditional Shannon entropy is exactly the lost linear dimension
    times the natural logarithm of the finite-field cardinality. -/
theorem uniformFiberShannonEntropy_eq_ker_finrank
    [Fintype Q] (f : Q →ₗ[K] Y) (x : Q) :
    uniformFiberShannonEntropy f x =
      (Module.finrank K (LinearMap.ker f) : ℝ) *
        Real.log (Nat.card K : ℝ) := by
  rw [uniformFiberShannonEntropy_eq_log_card,
    uniform_fiber_log_card_eq_ker_finrank]

/-- Aggregate conditional Shannon entropy for a uniformly sampled input X:
    average of the conditional fiber entropies using p(X = x) = 1 / |Q|.
    This equals H(X | f(X)) by the finite conditional-entropy identity. -/
noncomputable def uniformConditionalShannonEntropy
    [Fintype Q] (f : Q →ₗ[K] Y) : ℝ := by
  classical
  exact ∑ x : Q, ((1 : ℝ) / (Fintype.card Q : ℝ)) *
    uniformFiberShannonEntropy f x

/-- Aggregate conditional Shannon entropy for a uniformly sampled finite-field
    vector is exactly the kernel dimension times log of the field size. -/
theorem uniformConditionalShannonEntropy_eq_ker_finrank
    [Fintype Q] (f : Q →ₗ[K] Y) :
    uniformConditionalShannonEntropy f =
      (Module.finrank K (LinearMap.ker f) : ℝ) *
        Real.log (Nat.card K : ℝ) := by
  classical
  have hn : (Fintype.card Q : ℝ) ≠ 0 := by
    haveI : Nonempty Q := ⟨0⟩
    exact_mod_cast (Fintype.card_pos (α := Q)).ne'
  unfold uniformConditionalShannonEntropy
  simp_rw [uniformFiberShannonEntropy_eq_ker_finrank]
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  field_simp

#print axioms uniformConditionalShannonEntropy_eq_ker_finrank

#print axioms uniformFiberShannonEntropy_eq_log_card
#print axioms uniformFiberShannonEntropy_eq_ker_finrank

#print axioms fiber_natCard_eq_pow_ker_finrank
#print axioms uniform_fiber_log_card_eq_ker_finrank

end URF.Transfer.UniformObservationEntropy


/-! Specialization of finite-field uniform Shannon entropy to actual graph
gauge classes and locally supported cycle observations. -/
namespace URF.Transfer.GraphCochains

universe u₁ u₂ u₃
variable {K : Type u₁} [Field K] [Finite K]
variable {V : Type u₂} {E : Type u₃} [Fintype E]

/-- Shannon entropy on the uniformly distributed fiber of the local graph
observation through a chosen gauge class, with its finite type constructed
from finite-field finite-dimensionality. -/
noncomputable def graphUniformFiberShannonEntropy
    (G : OrientedEdges V E) (S : Set E)
    (q : ((E → K) ⧸ gaugeSpan (K := K) G)) : ℝ := by
  classical
  haveI : Finite (E → K) := inferInstance
  haveI : Finite ((E → K) ⧸ gaugeSpan (K := K) G) :=
    Finite.of_surjective (gaugeSpan (K := K) G).mkQ
      (Submodule.mkQ_surjective _)
  letI : Fintype ((E → K) ⧸ gaugeSpan (K := K) G) := Fintype.ofFinite _
  exact URF.Transfer.UniformObservationEntropy.uniformFiberShannonEntropy
    (localCycleObservation (K := K) G S) q

set_option maxHeartbeats 800000

/-- Exact graph information budget for uniform gauge classes over finite fields.
The Shannon entropy is the explicit discrete sum over a nonempty fiber. -/
theorem graphUniformFiberShannonEntropy_add_observed
    (G : OrientedEdges V E) (S : Set E)
    (q : ((E → K) ⧸ gaugeSpan (K := K) G)) :
    graphUniformFiberShannonEntropy G S q +
      (Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) *
        Real.log (Nat.card K : ℝ) =
      (Module.finrank K (cycleSubspace (K := K) G) : ℝ) *
        Real.log (Nat.card K : ℝ) := by
  classical
  haveI : Finite (E → K) := inferInstance
  haveI : Finite ((E → K) ⧸ gaugeSpan (K := K) G) :=
    Finite.of_surjective (gaugeSpan (K := K) G).mkQ
      (Submodule.mkQ_surjective _)
  letI : Fintype ((E → K) ⧸ gaugeSpan (K := K) G) := Fintype.ofFinite _
  have hentropy :
      graphUniformFiberShannonEntropy (K := K) G S q =
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) *
          Real.log (Nat.card K : ℝ) := by
    unfold graphUniformFiberShannonEntropy
    exact URF.Transfer.UniformObservationEntropy.uniformFiberShannonEntropy_eq_ker_finrank
      (localCycleObservation (K := K) G S) q
  have hdim :
      (Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) +
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) =
          (Module.finrank K (cycleSubspace (K := K) G) : ℝ) := by
    exact_mod_cast (localCycleObservation_hidden_finrank (K := K) G S)
  calc
    _ = ((Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) *
        Real.log (Nat.card K : ℝ)) +
        ((Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) *
        Real.log (Nat.card K : ℝ)) := by rw [hentropy]
    _ = ((Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) +
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ)) *
        Real.log (Nat.card K : ℝ) := by ring
    _ = (Module.finrank K (cycleSubspace (K := K) G) : ℝ) *
        Real.log (Nat.card K : ℝ) := by rw [hdim]

/-- Aggregate Shannon conditional entropy of a uniformly sampled graph
gauge class after local-cycle observation. -/
noncomputable def graphUniformConditionalShannonEntropy
    (G : OrientedEdges V E) (S : Set E) : ℝ := by
  classical
  haveI : Finite (E → K) := inferInstance
  haveI : Finite ((E → K) ⧸ gaugeSpan (K := K) G) :=
    Finite.of_surjective (gaugeSpan (K := K) G).mkQ
      (Submodule.mkQ_surjective _)
  letI : Fintype ((E → K) ⧸ gaugeSpan (K := K) G) := Fintype.ofFinite _
  exact URF.Transfer.UniformObservationEntropy.uniformConditionalShannonEntropy
    (localCycleObservation (K := K) G S)

/-- The full uniform conditional Shannon entropy of a graph gauge class,
averaged over all observations, plus observable cycle dimensions gives the
global cycle information budget over a finite field. -/
theorem graphUniformConditionalShannonEntropy_add_observed
    (G : OrientedEdges V E) (S : Set E) :
    graphUniformConditionalShannonEntropy (K := K) G S +
      (Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) *
        Real.log (Nat.card K : ℝ) =
      (Module.finrank K (cycleSubspace (K := K) G) : ℝ) *
        Real.log (Nat.card K : ℝ) := by
  classical
  haveI : Finite (E → K) := inferInstance
  haveI : Finite ((E → K) ⧸ gaugeSpan (K := K) G) :=
    Finite.of_surjective (gaugeSpan (K := K) G).mkQ
      (Submodule.mkQ_surjective _)
  letI : Fintype ((E → K) ⧸ gaugeSpan (K := K) G) := Fintype.ofFinite _
  have hentropy :
      graphUniformConditionalShannonEntropy (K := K) G S =
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) *
          Real.log (Nat.card K : ℝ) := by
    unfold graphUniformConditionalShannonEntropy
    exact URF.Transfer.UniformObservationEntropy.uniformConditionalShannonEntropy_eq_ker_finrank
      (localCycleObservation (K := K) G S)
  have hdim :
      (Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) +
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) =
          (Module.finrank K (cycleSubspace (K := K) G) : ℝ) := by
    exact_mod_cast (localCycleObservation_hidden_finrank (K := K) G S)
  calc
    _ = ((Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ) *
        Real.log (Nat.card K : ℝ)) +
        ((Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) *
        Real.log (Nat.card K : ℝ)) := by rw [hentropy]
    _ = ((Module.finrank K (supportedLocalCycles (K := K) G S) : ℝ) +
        (Module.finrank K (LinearMap.ker (localCycleObservation (K := K) G S)) : ℝ)) *
        Real.log (Nat.card K : ℝ) := by ring
    _ = (Module.finrank K (cycleSubspace (K := K) G) : ℝ) *
        Real.log (Nat.card K : ℝ) := by rw [hdim]

#print axioms graphUniformConditionalShannonEntropy_add_observed

#print axioms graphUniformFiberShannonEntropy_add_observed

end URF.Transfer.GraphCochains

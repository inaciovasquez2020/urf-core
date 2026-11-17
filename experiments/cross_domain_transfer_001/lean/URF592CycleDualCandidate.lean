import Mathlib

/-!
URF PR #592: abstract cycle-observation duality kernel and dimension.
PIN: leanprover/lean4:v4.27.0, mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900.
STATUS: NOT_RUN; SOURCE CANDIDATE ONLY.
The graph quotient/cycle perfect pairing is NOT constructed in this file.
Any claim of full graph-specific Lean verification is therefore OPEN.
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

end URF.Transfer.CycleDual

#print axioms URF.Transfer.CycleDual.restriction_dual_apply
#print axioms URF.Transfer.CycleDual.hidden_iff_annihilates_local_cycles
#print axioms URF.Transfer.CycleDual.observed_add_hidden_eq_global_dual

/-!
First graph-specific layer. Here a finite oriented graph is represented by
its edge endpoint maps. Cycle predicate is stated as annihilation of all
vertex coboundaries; equivalence with the incidence-boundary kernel and the
perfect quotient pairing remains OPEN. None of the abstract proofs above
are altered.
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


/-- Standard basis identifies each finite edge cochain with its dual. -/
noncomputable def edgeCoordinateDualEquiv : (E → K) ≃ₗ[K] Module.Dual K (E → K) := by
  classical
  exact (Pi.basisFun K E).toDualEquiv

/-- The standard coordinate duality is the graph's dot-product pairing. -/
theorem edgeCoordinateDualEquiv_apply (z a : E → K) :
    edgeCoordinateDualEquiv (K := K) (E := E) z a = edgePair a z := by
  classical
  have h : (edgeCoordinateDualEquiv (K := K) (E := E) z) =
      cycleEvaluation z := by
    apply (Pi.basisFun K E).ext
    intro e
    change ((Pi.basisFun K E).toDual z) ((Pi.basisFun K E) e) =
      edgePair ((Pi.basisFun K E) e) z
    rw [Module.Basis.toDual_apply_left]
    simp [edgePair, Pi.basisFun_apply]
  exact congrArg (fun φ : Module.Dual K (E → K) => φ a) h

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

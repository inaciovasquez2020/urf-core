import URF.Foundation.CyclePartitionMinimaxAssemblyCandidate
import URF.Foundation.CyclePartitionNeighborhood

namespace URF.EntropyBridge

/-- Orient the edges using the lexicographic order on component and position. -/
local instance cyclePartitionVertexOrder (sizes : List ℕ) : LinearOrder (CyclePartitionVertex sizes) :=
  Sigma.Lex.linearOrder

noncomputable abbrev AdmissibleCycleSpace (K : Type*) [Field K] {N L : ℕ}
    (g : AdmissibleCycleFamily N L) :=
  LinearMap.ker (simpleGraphBoundary (K := K) (cyclePartitionSimpleGraph g.sizes))

noncomputable instance admissibleCycleSpaceFintype (K : Type*) [Field K] [Fintype K]
    {N L : ℕ} (g : AdmissibleCycleFamily N L) : Fintype (AdmissibleCycleSpace K g) :=
  Fintype.ofFinite _

noncomputable def admissibleCycleEntropy (K : Type*) [Field K] [Fintype K]
    {N L : ℕ} (g : AdmissibleCycleFamily N L) : ℝ :=
  finiteEntropy (fun _ : AdmissibleCycleSpace K g =>
    (1 : ℝ) / Fintype.card (AdmissibleCycleSpace K g))

theorem admissibleCycleEntropy_eq (K : Type*) [Field K] [Fintype K]
    {N L : ℕ} (hL : 3 ≤ L) (g : AdmissibleCycleFamily N L) :
    admissibleCycleEntropy K g = (admissibleGraphComponentCount g : ℝ) *
      Real.log (Fintype.card K) := by
  have h3 (i : Fin g.sizes.length) : 3 ≤ g.sizes.get i :=
    hL.trans (g.minLength _ (List.get_mem _ _))
  have hp (i : Fin g.sizes.length) : 0 < g.sizes.get i := by have := h3 i; omega
  unfold admissibleCycleEntropy
  rw [uniform_entropy_exact_candidate, Module.card_eq_pow_finrank (K := K),
    Nat.cast_pow, Real.log_pow, admissibleGraphComponentCount_eq_length (by omega : 0 < L)]
  change (Module.finrank K (LinearMap.ker
    (simpleGraphBoundary (K := K) (cyclePartitionSimpleGraph g.sizes))) : ℝ) * _ = _
  rw [cyclePartition_incidenceKernel_finrank h3 hp K]

noncomputable def admissibleCycleObservation {N L : ℕ} (r : ℕ)
    (g : AdmissibleCycleFamily N L) : Multiset RootedNeighborhoodClass :=
  rootedNeighborhoodObservation (cyclePartitionSimpleGraph g.sizes) r

theorem admissibleCycleObservation_eq {N L r : ℕ}
    (hL : max 3 (2 * r + 2) ≤ L) (g : AdmissibleCycleFamily N L) :
    admissibleCycleObservation r g = Multiset.replicate N (centeredPathClass r) := by
  have hm (i : Fin g.sizes.length) : max 3 (2 * r + 2) ≤ g.sizes.get i :=
    hL.trans (g.minLength _ (List.get_mem _ _))
  unfold admissibleCycleObservation
  rw [cyclePartition_neighborhoodObservation_eq_replicate r
    (fun i => (le_max_left _ _).trans (hm i)) (fun i => (le_max_right _ _).trans (hm i)),
    cyclePartition_vertices_card, ← List.sum_ofFn, List.ofFn_get, g.total]

/-- Sharp worst-case absolute error for deterministic estimation from the
multiset of actual rooted induced radius balls. -/
theorem cyclePartition_radius_minimax
    (K : Type*) [Field K] [Fintype K] (N L r : ℕ)
    (hNL : L ≤ N) (hL : max 3 (2 * r + 2) ≤ L) :
    (∀ estimate : Multiset RootedNeighborhoodClass → ℝ,
      ∃ g : AdmissibleCycleFamily N L,
        ((((N / L : ℕ) : ℝ) - 1) * Real.log (Fintype.card K)) / 2 ≤
          |estimate (admissibleCycleObservation r g) - admissibleCycleEntropy K g|) ∧
    (∃ estimate : Multiset RootedNeighborhoodClass → ℝ,
      ∀ g : AdmissibleCycleFamily N L,
        |estimate (admissibleCycleObservation r g) - admissibleCycleEntropy K g| ≤
          ((((N / L : ℕ) : ℝ) - 1) * Real.log (Fintype.card K)) / 2) := by
  have h3 := (le_max_left 3 (2 * r + 2)).trans hL
  have hp : 0 < L := by omega
  have hw : 0 ≤ Real.log (Fintype.card K : ℝ) :=
    Real.log_nonneg (by exact_mod_cast Fintype.card_pos (α := K))
  obtain ⟨⟨lo, hloN, hloCount, hloMin⟩, ⟨hi, hhiN, hhiCount, hhiMin⟩⟩ :=
    cyclePartition_extremizers N L hNL hp
  let glo : AdmissibleCycleFamily N L := ⟨lo, hloN, hloMin⟩
  let ghi : AdmissibleCycleFamily N L := ⟨hi, hhiN, hhiMin⟩
  have hrange (g : AdmissibleCycleFamily N L) :
      1 ≤ admissibleGraphComponentCount g ∧ admissibleGraphComponentCount g ≤ N / L := by
    rw [admissibleGraphComponentCount_eq_length hp]
    refine ⟨?_, cyclePartition_count_le N L hp g.sizes g.total g.minLength⟩
    by_contra hn
    have hempty := List.length_eq_zero_iff.mp (show g.sizes.length = 0 by omega)
    have hzero : N = 0 := by simpa [hempty] using g.total.symm
    omega
  simpa only [admissibleCycleEntropy_eq K h3] using
    (cycle_count_observation_minimax (admissibleCycleObservation r) admissibleGraphComponentCount
      (N / L) (Nat.div_pos hNL hp) (Real.log (Fintype.card K)) hw glo ghi
      ((admissibleCycleObservation_eq hL glo).trans (admissibleCycleObservation_eq hL ghi).symm)
      ((admissibleGraphComponentCount_eq_length hp glo).trans hloCount)
      ((admissibleGraphComponentCount_eq_length hp ghi).trans hhiCount)
      hrange)

/-- The least achievable worst-case error, with an attaining estimator. -/
theorem cyclePartition_radius_minimax_value
    (K : Type*) [Field K] [Fintype K] (N L r : ℕ)
    (hNL : L ≤ N) (hL : max 3 (2 * r + 2) ≤ L) :
    IsLeast {E : ℝ | ∃ estimate : Multiset RootedNeighborhoodClass → ℝ,
      ∀ g : AdmissibleCycleFamily N L,
        |estimate (admissibleCycleObservation r g) - admissibleCycleEntropy K g| ≤ E}
      (((((N / L : ℕ) : ℝ) - 1) * Real.log (Fintype.card K)) / 2) := by
  obtain ⟨lower, upper⟩ := cyclePartition_radius_minimax K N L r hNL hL
  refine ⟨upper, ?_⟩
  rintro E ⟨estimate, hestimate⟩
  obtain ⟨g, hg⟩ := lower estimate
  exact hg.trans (hestimate g)

#print axioms admissibleCycleEntropy
#print axioms admissibleCycleEntropy_eq
#print axioms admissibleCycleObservation_eq
#print axioms cyclePartition_radius_minimax
#print axioms cyclePartition_radius_minimax_value

end URF.EntropyBridge

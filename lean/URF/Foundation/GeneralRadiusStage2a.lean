import URF.Foundation.GeneralRadiusStage1

/-! Stage 2a candidate: short closed walk locality. This is NOT the full
bounded-support cycle-space equivalence. No cycle decomposition is assumed. -/
namespace URF.EntropyBridge.Multiscale

theorem walkVertex_mem_radius {V : Type*} (G : SimpleGraph V)
    (p : ℕ → V) (n : ℕ)
    (hadj : ∀ j < n, G.Adj (p j) (p (j + 1))) :
    p n ∈ closedRadiusBall G (p 0) n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    have hp : p n ∈ closedRadiusBall G (p 0) n :=
      ih (fun j hj => hadj j (by omega))
    exact Or.inr ⟨p n, hp, hadj n (by omega)⟩

theorem shortClosedWalk_vertex_mem_radius {V : Type*}
    (G : SimpleGraph V) (p : ℕ → V) (n r : ℕ)
    (hadj : ∀ j < n, G.Adj (p j) (p (j + 1)))
    (hclosed : p n = p 0) (hlen : n ≤ 2 * r + 1)
    (i : ℕ) (hi : i ≤ n) :
    p i ∈ closedRadiusBall G (p 0) r := by
  by_cases hir : i ≤ r
  · exact closedRadiusBall_mono G (p 0) hir
      (walkVertex_mem_radius G p i (fun j hj => hadj j (by omega)))
  · have hrevAdj : ∀ j < n - i,
        G.Adj (p (n - j)) (p (n - (j + 1))) := by
      intro j hj
      have he : n - j = n - (j + 1) + 1 := by omega
      have h := (hadj (n - (j + 1)) (by omega)).symm
      simpa only [← he] using h
    have hrev := walkVertex_mem_radius G (fun j => p (n - j)) (n - i) hrevAdj
    change p (n - (n - i)) ∈ closedRadiusBall G (p (n - 0)) (n - i) at hrev
    have he : n - (n - i) = i := by omega
    rw [he, Nat.sub_zero, hclosed] at hrev
    exact closedRadiusBall_mono G (p 0) (by omega : n - i ≤ r) hrev

/-- Concrete circulation whose nonzero edges are traversed by a short closed
walk belongs to the actual radius-local cycle subspace. -/
theorem shortClosedWalk_circulation_mem_radiusCycles
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r n : ℕ) (p : ℕ → V)
    (z : LinearMap.ker (simpleGraphBoundary (K := K) G))
    (hadj : ∀ j < n, G.Adj (p j) (p (j + 1)))
    (hclosed : p n = p 0) (hlen : n ≤ 2 * r + 1)
    (hsupp : ∀ e : OrderedEdge G, z.val e ≠ 0 →
      ∃ i < n, (p i = e.val.1 ∧ p (i + 1) = e.val.2) ∨
        (p i = e.val.2 ∧ p (i + 1) = e.val.1)) :
    z ∈ radiusCycles (K := K) G r := by
  change z.val ∈ radiusAmbient (K := K) G r
  unfold radiusAmbient
  apply Submodule.subset_span
  refine ⟨LinearMap.mem_ker.mp z.property, p 0, ?_⟩
  intro e he
  obtain ⟨i, hi, h | h⟩ := hsupp e he
  · constructor
    · rw [← h.1]
      exact shortClosedWalk_vertex_mem_radius G p n r hadj hclosed hlen i (by omega)
    · rw [← h.2]
      exact shortClosedWalk_vertex_mem_radius G p n r hadj hclosed hlen (i+1) (by omega)
  · constructor
    · rw [← h.2]
      exact shortClosedWalk_vertex_mem_radius G p n r hadj hclosed hlen (i+1) (by omega)
    · rw [← h.1]
      exact shortClosedWalk_vertex_mem_radius G p n r hadj hclosed hlen i (by omega)

/-- Span of actual circulations supported on traversed edges of short closed walks. -/
noncomputable def shortWalkCycles
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (k : ℕ) :
    Submodule K (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  Submodule.span K {z | ∃ (n : ℕ) (p : ℕ → V), n ≤ k ∧
    (∀ j < n, G.Adj (p j) (p (j + 1))) ∧ p n = p 0 ∧
    (∀ e : OrderedEdge G, z.val e ≠ 0 →
      ∃ i < n, (p i = e.val.1 ∧ p (i + 1) = e.val.2) ∨
        (p i = e.val.2 ∧ p (i + 1) = e.val.1))}

theorem shortWalkCycles_le_radiusCycles
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) :
    shortWalkCycles (K := K) G (2 * r + 1) ≤ radiusCycles (K := K) G r := by
  unfold shortWalkCycles
  apply Submodule.span_le.mpr
  intro z hz
  obtain ⟨n, p, hn, ha, hc, hs⟩ := hz
  exact shortClosedWalk_circulation_mem_radiusCycles G r n p z ha hc hn hs

#print axioms walkVertex_mem_radius
#print axioms shortClosedWalk_vertex_mem_radius
#print axioms shortClosedWalk_circulation_mem_radiusCycles
#print axioms shortWalkCycles_le_radiusCycles

end URF.EntropyBridge.Multiscale

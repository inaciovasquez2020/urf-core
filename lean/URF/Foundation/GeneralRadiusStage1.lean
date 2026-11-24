import URF.Foundation.SharpCliqueEntropy

/-! Stage 1 candidate, NOT_RUN. Base 07cb92d98b67cc56e21acf18aef40d2a41fb9d31.
Uses the existing incidence boundary and radius-one span, not a replacement graph model. -/
namespace URF.EntropyBridge.Multiscale

/-- Vertices reachable from `v` by at most `r` adjacency steps. -/
def closedRadiusBall {V : Type*} (G : SimpleGraph V) (v : V) : ℕ → Set V
  | 0 => {w | w = v}
  | r + 1 => {w | w ∈ closedRadiusBall G v r ∨
      ∃ u ∈ closedRadiusBall G v r, G.Adj u w}

theorem closedRadiusBall_step {V : Type*} (G : SimpleGraph V) (v : V)
    (r : ℕ) : closedRadiusBall G v r ⊆ closedRadiusBall G v (r + 1) := by
  intro w hw
  exact Or.inl hw

theorem closedRadiusBall_mono {V : Type*} (G : SimpleGraph V) (v : V)
    {r s : ℕ} (h : r ≤ s) : closedRadiusBall G v r ⊆ closedRadiusBall G v s := by
  induction h with
  | refl => intro w hw; exact hw
  | step h ih => exact fun _ hw => closedRadiusBall_step G v _ (ih hw)

theorem closedRadiusBall_one_iff {V : Type*} (G : SimpleGraph V) (v w : V) :
    w ∈ closedRadiusBall G v 1 ↔ w = v ∨ G.Adj v w := by
  change (w = v ∨ ∃ u : V, u = v ∧ G.Adj u w) ↔ (w = v ∨ G.Adj v w)
  constructor
  · rintro (h | ⟨u, hu, huw⟩)
    · exact Or.inl h
    · subst u
      exact Or.inr huw
  · rintro (h | h)
    · exact Or.inl h
    · exact Or.inr ⟨v, rfl, h⟩

/-- Ambient span of actual circulations supported in an induced closed ball. -/
noncomputable def radiusAmbient {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) : Submodule K (OrderedEdge G → K) :=
  Submodule.span K {z | simpleGraphBoundary (K := K) G z = 0 ∧
    ∃ v : V, ∀ e : OrderedEdge G, z e ≠ 0 →
      e.val.1 ∈ closedRadiusBall G v r ∧ e.val.2 ∈ closedRadiusBall G v r}

theorem radiusAmbient_le_kernel {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) : radiusAmbient (K := K) G r ≤
      LinearMap.ker (simpleGraphBoundary (K := K) G) := by
  unfold radiusAmbient
  apply Submodule.span_le.mpr
  intro z hz
  exact LinearMap.mem_ker.mpr hz.1

theorem radiusAmbient_mono {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) {r s : ℕ} (h : r ≤ s) :
    radiusAmbient (K := K) G r ≤ radiusAmbient (K := K) G s := by
  unfold radiusAmbient
  apply Submodule.span_le.mpr
  intro z hz
  obtain ⟨hc, v, hv⟩ := hz
  apply Submodule.subset_span
  exact ⟨hc, v, fun e he => ⟨closedRadiusBall_mono G v h (hv e he).1,
    closedRadiusBall_mono G v h (hv e he).2⟩⟩

theorem radiusAmbient_one {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) : radiusAmbient (K := K) G 1 =
      radiusOneAmbientCandidate (K := K) G := by
  simp only [radiusAmbient, radiusOneAmbientCandidate, closedRadiusBall_one_iff]

/-- Subspace of the actual incidence kernel, not the ambient edge-chain space. -/
noncomputable def radiusCycles {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) : Submodule K
      (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  (radiusAmbient (K := K) G r).comap (LinearMap.ker (simpleGraphBoundary (K := K) G)).subtype

theorem radiusCycles_mono {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) {r s : ℕ} (h : r ≤ s) :
    radiusCycles (K := K) G r ≤ radiusCycles (K := K) G s := by
  intro z hz
  exact radiusAmbient_mono (K := K) G h hz

noncomputable def radiusGraphChain {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) : GraphChainPresentation K V (OrderedEdge G) where
  boundary := simpleGraphBoundary (K := K) G
  localCycles := radiusCycles (K := K) G r

theorem radiusCycles_one {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) : radiusCycles (K := K) G 1 =
      (radiusOneGraphChainCandidate (K := K) G).localCycles := by
  change (radiusAmbient (K := K) G 1).comap _ =
    (radiusOneAmbientCandidate (K := K) G).comap _
  rw [radiusAmbient_one G]

#print axioms closedRadiusBall_step
#print axioms closedRadiusBall_mono
#print axioms closedRadiusBall_one_iff
#print axioms radiusAmbient_le_kernel
#print axioms radiusAmbient_mono
#print axioms radiusAmbient_one
#print axioms radiusCycles_mono
#print axioms radiusCycles_one

end URF.EntropyBridge.Multiscale


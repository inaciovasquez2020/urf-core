import URF.Foundation.GeneralRadiusStage2b2a

/-! Stage 2b2b: extract a simple cycle in the actual nonzero support graph. -/
namespace URF.EntropyBridge.Multiscale

def circulationSupportGraph {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (z : OrderedEdge G → K) : SimpleGraph V where
  Adj u v := ∃ e : OrderedEdge G, z e ≠ 0 ∧
    ((e.val.1 = u ∧ e.val.2 = v) ∨ (e.val.1 = v ∧ e.val.2 = u))
  symm := by
    intro u v h
    obtain ⟨e, he, h⟩ := h
    exact ⟨e, he, (Or.comm.mp h)⟩
  loopless := by
    intro u h
    obtain ⟨e, _, h | h⟩ := h
    · exact (ne_of_lt e.property.1) (h.1.trans h.2.symm)
    · exact (ne_of_lt e.property.1) (h.1.trans h.2.symm)

theorem circulationSupportGraph_le {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (z : OrderedEdge G → K) :
    circulationSupportGraph G z ≤ G := by
  intro u v h
  obtain ⟨e, _, h | h⟩ := h
  · simpa only [h.1, h.2] using e.property.2
  · simpa only [h.1, h.2] using e.property.2.symm

theorem circulationSupportGraph_branch
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (u v : V) (huv : (circulationSupportGraph G z).Adj u v) :
    ∃ w, (circulationSupportGraph G z).Adj u w ∧ w ≠ v := by
  obtain ⟨e, he, h⟩ := huv
  have heu : e.val.1 = u ∨ e.val.2 = u := by
    rcases h with h | h
    · exact Or.inl h.1
    · exact Or.inr h.2
  have hev : e.val.1 = v ∨ e.val.2 = v := by
    rcases h with h | h
    · exact Or.inr h.2
    · exact Or.inl h.1
  have huvne : u ≠ v := by
    intro huv
    rcases h with h | h
    · exact (ne_of_lt e.property.1) (h.1.trans (huv.trans h.2.symm))
    · exact (ne_of_lt e.property.1) (h.1.trans (huv.symm.trans h.2.symm))
  obtain ⟨d, hde, hd, hdu⟩ := circulation_support_second_incident G z hz e he u heu
  rcases hdu with hdu | hdu
  · refine ⟨d.val.2, ⟨d, hd, Or.inl ⟨hdu, rfl⟩⟩, ?_⟩
    intro hdv
    exact hde (orderedEdge_unique_incident_pair_candidate e d u v huvne
      heu hev (Or.inl hdu) (Or.inr hdv))
  · refine ⟨d.val.1, ⟨d, hd, Or.inr ⟨rfl, hdu⟩⟩, ?_⟩
    intro hdv
    exact hde (orderedEdge_unique_incident_pair_candidate e d u v huvne
      heu hev (Or.inr hdu) (Or.inl hdv))

theorem nonzero_circulation_support_has_cycle
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0) (hne : z ≠ 0) :
    ∃ v : V, ∃ p : (circulationSupportGraph G z).Walk v v, p.IsCycle := by
  classical
  have he : ∃ e : OrderedEdge G, z e ≠ 0 := by
    by_contra hn
    apply hne
    funext e
    by_contra h
    exact hn ⟨e, h⟩
  obtain ⟨e, he⟩ := he
  apply exists_cycle_of_two_neighbors (circulationSupportGraph G z)
  · exact ⟨e.val.1, e.val.2, e, he, Or.inl ⟨rfl, rfl⟩⟩
  · exact circulationSupportGraph_branch G z hz

#print axioms circulationSupportGraph_le
#print axioms circulationSupportGraph_branch
#print axioms nonzero_circulation_support_has_cycle

end URF.EntropyBridge.Multiscale

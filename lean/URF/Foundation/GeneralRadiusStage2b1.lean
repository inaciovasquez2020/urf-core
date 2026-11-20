import URF.Foundation.GeneralRadiusStage2a

/-! Stage 2b1: concrete support has no degree-one vertex.
This is a prerequisite to cycle extraction, not cycle decomposition itself. -/
namespace URF.EntropyBridge.Multiscale

theorem incidence_ne_zero_of_endpoint
    {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (v : V) (e : OrderedEdge G)
    (hv : e.val.1 = v ∨ e.val.2 = v) :
    simpleGraphIncidence (K := K) G v e ≠ 0 := by
  classical
  rcases hv with h | h
  · simp [simpleGraphIncidence, h]
  · have hn : v ≠ e.val.1 := by
      intro he
      exact (ne_of_lt e.property.1) (he.symm.trans h.symm)
    simp [simpleGraphIncidence, hn, h]

theorem circulation_support_second_incident
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (e : OrderedEdge G) (he : z e ≠ 0) (v : V)
    (hv : e.val.1 = v ∨ e.val.2 = v) :
    ∃ d : OrderedEdge G, d ≠ e ∧ z d ≠ 0 ∧
      (d.val.1 = v ∨ d.val.2 = v) := by
  classical
  by_contra hn
  have hoff : ∀ d : OrderedEdge G, d ≠ e →
      simpleGraphIncidence (K := K) G v d * z d = 0 := by
    intro d hde
    by_cases hd : z d = 0
    · simp [hd]
    · have hnot : ¬ (d.val.1 = v ∨ d.val.2 = v) :=
        fun h => hn ⟨d, hde, hd, h⟩
      have h1 : v ≠ d.val.1 := fun h => hnot (Or.inl h.symm)
      have h2 : v ≠ d.val.2 := fun h => hnot (Or.inr h.symm)
      simp [simpleGraphIncidence, h1, h2]
  have hrow := congrFun hz v
  change (∑ d : OrderedEdge G, simpleGraphIncidence (K := K) G v d * z d) = 0 at hrow
  have hsingle : (∑ d : OrderedEdge G, simpleGraphIncidence (K := K) G v d * z d) =
      simpleGraphIncidence (K := K) G v e * z e := by
    apply Finset.sum_eq_single e
    · intro d _ hd
      exact hoff d hd
    · intro h
      exact False.elim (h (Finset.mem_univ e))
  rw [hsingle] at hrow
  exact (mul_ne_zero (incidence_ne_zero_of_endpoint G v e hv) he) hrow

#print axioms incidence_ne_zero_of_endpoint
#print axioms circulation_support_second_incident

end URF.EntropyBridge.Multiscale

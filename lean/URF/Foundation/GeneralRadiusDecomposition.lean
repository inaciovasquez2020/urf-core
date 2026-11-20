import URF.Foundation.GeneralRadiusStage2b3a

namespace URF.EntropyBridge.Multiscale

open SimpleGraph

noncomputable def chainSupport {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    {G : SimpleGraph V} (z : OrderedEdge G → K) : Finset (OrderedEdge G) := by
  classical
  exact Finset.univ.filter fun e => z e ≠ 0

@[simp] theorem mem_chainSupport {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    {G : SimpleGraph V} {z : OrderedEdge G → K} {e : OrderedEdge G} :
    e ∈ chainSupport z ↔ z e ≠ 0 := by
  classical
  simp [chainSupport]

theorem directedEdgeChain_ne_zero_iff {V K : Type*} [LinearOrder V] [Field K]
    {G : SimpleGraph V} (a b : V) (e : OrderedEdge G) :
    directedEdgeChainCandidate (K := K) a b e ≠ 0 ↔
      (e.val.1 = a ∧ e.val.2 = b) ∨ (e.val.1 = b ∧ e.val.2 = a) := by
  classical
  by_cases hf : e.val.1 = a ∧ e.val.2 = b
  · rw [directedEdgeChainCandidate, if_pos hf]
    exact ⟨fun _ => Or.inl hf, fun _ => one_ne_zero⟩
  · by_cases hr : e.val.1 = b ∧ e.val.2 = a
    · rw [directedEdgeChainCandidate, if_neg hf, if_pos hr]
      exact ⟨fun _ => Or.inr hr, fun _ => neg_ne_zero.mpr one_ne_zero⟩
    · rw [directedEdgeChainCandidate, if_neg hf, if_neg hr]
      exact ⟨fun h => False.elim (h rfl), fun h => False.elim (h.elim hf hr)⟩

theorem walk_edge_at {V : Type*} {H : SimpleGraph V} {u v : V}
    (p : H.Walk u v) (i : ℕ) (hi : i < p.length) :
    p.edges[i]'(p.length_edges ▸ hi) = s(p.getVert i, p.getVert (i + 1)) := by
  have hd : i < p.darts.length := p.length_darts ▸ hi
  change (p.darts.map Dart.edge)[i]'(p.length_edges ▸ hi) = _
  rw [List.getElem_map, Walk.darts_getElem_eq_getVert, Dart.edge_mk]

theorem walk_edge_at_of_coefficient {V K : Type*} [LinearOrder V] [Field K]
    {G H : SimpleGraph V} {u v : V} {p : H.Walk u v} (e : OrderedEdge G)
    {i : ℕ} (hi : i < p.length)
    (he : directedEdgeChainCandidate (K := K) (p.getVert i) (p.getVert (i + 1)) e ≠ 0) :
    p.edges[i]'(p.length_edges ▸ hi) = s(e.val.1, e.val.2) := by
  rw [walk_edge_at p i hi]
  rcases (directedEdgeChain_ne_zero_iff _ _ _).mp he with h | h
  · rw [h.1, h.2]
  · rw [h.1, h.2]
    exact Sym2.eq_swap

theorem cycle_walkChain_coefficient {V K : Type*} [LinearOrder V] [Field K]
    {G H : SimpleGraph V} {v : V} {p : H.Walk v v} (hp : p.IsCycle)
    (e : OrderedEdge G) {i : ℕ} (hi : i < p.length)
    (he : directedEdgeChainCandidate (K := K) (p.getVert i) (p.getVert (i + 1)) e ≠ 0) :
    walkChain (K := K) G p.getVert p.length e =
      directedEdgeChainCandidate (p.getVert i) (p.getVert (i + 1)) e := by
  classical
  unfold walkChain
  rw [Finset.sum_apply]
  apply Finset.sum_eq_single_of_mem i (Finset.mem_range.mpr hi)
  intro j hj hji
  by_contra hn
  exact hji (hp.isCircuit.isTrail.edges_nodup.getElem_inj_iff.mp
    ((walk_edge_at_of_coefficient e (Finset.mem_range.mp hj) hn).trans
      (walk_edge_at_of_coefficient e hi he).symm))

theorem cycle_walkChain_coefficient_eq_sign {V K : Type*} [LinearOrder V] [Field K]
    {G H : SimpleGraph V} {v : V} {p : H.Walk v v} (hp : p.IsCycle)
    (e : OrderedEdge G) {i : ℕ} (hi : i < p.length)
    (he : directedEdgeChainCandidate (K := K) (p.getVert i) (p.getVert (i + 1)) e ≠ 0) :
    walkChain (K := K) G p.getVert p.length e = 1 ∨
      walkChain (K := K) G p.getVert p.length e = -1 := by
  classical
  rw [cycle_walkChain_coefficient hp e hi he]
  have hm := (directedEdgeChain_ne_zero_iff _ _ _).mp he
  by_cases hf : e.val.1 = p.getVert i ∧ e.val.2 = p.getVert (i+1)
  · exact Or.inl (by simp [directedEdgeChainCandidate, hf])
  · exact Or.inr (by rw [directedEdgeChainCandidate, if_neg hf, if_pos (hm.resolve_left hf)])

theorem card_chainSupport_walkChain {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (p : ℕ → V) (n : ℕ) :
    (chainSupport (walkChain (K := K) G p n)).card ≤ n := by
  classical
  let index (e : OrderedEdge G) : ℕ :=
    if he : walkChain (K := K) G p n e ≠ 0 then
      (walkChain_nonzero_traversed G p n e he).choose else n
  have spec (e : OrderedEdge G) (he : e ∈ chainSupport (walkChain (K := K) G p n)) :
      index e < n ∧ ((p (index e) = e.val.1 ∧ p (index e + 1) = e.val.2) ∨
        (p (index e) = e.val.2 ∧ p (index e + 1) = e.val.1)) := by
    simpa only [index, dif_pos (mem_chainSupport.mp he)] using
      (walkChain_nonzero_traversed G p n e (mem_chainSupport.mp he)).choose_spec
  refine le_trans ?_ (le_of_eq (Finset.card_range n))
  apply Finset.card_le_card_of_injOn index
  · intro e he
    exact Finset.mem_range.mpr (spec e he).1
  · intro e he d hd h
    have he' := (spec e he).2
    have hd' := (spec d hd).2
    rw [← h] at hd'
    apply Subtype.ext
    rcases he' with he' | he' <;> rcases hd' with hd' | hd'
    · exact Prod.ext (he'.1.symm.trans hd'.1) (he'.2.symm.trans hd'.2)
    · exact False.elim (lt_asymm e.property.1
        (show e.val.2 < e.val.1 by rw [← he'.2, ← he'.1, hd'.1, hd'.2]; exact d.property.1))
    · exact False.elim (lt_asymm e.property.1
        (show e.val.2 < e.val.1 by rw [← he'.1, ← he'.2, hd'.1, hd'.2]; exact d.property.1))
    · exact Prod.ext (he'.2.symm.trans hd'.2) (he'.1.symm.trans hd'.1)

theorem cancel_chain_coefficient {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    {G : SimpleGraph V} (z c : OrderedEdge G → K) (e : OrderedEdge G)
    (hz : z e ≠ 0) (hc : c e ≠ 0) (hs : chainSupport c ⊆ chainSupport z) :
    (z - (z e / c e) • c) e = 0 ∧
      chainSupport (z - (z e / c e) • c) ⊂ chainSupport z := by
  classical
  have he : (z - (z e / c e) • c) e = 0 := by
    change z e - z e / c e * c e = 0
    rw [div_mul_cancel₀ _ hc, sub_self]
  refine ⟨he, Finset.ssubset_iff_subset_ne.mpr ⟨?_, ?_⟩⟩
  · intro d hd
    rw [mem_chainSupport] at hd ⊢
    intro h
    have h' : c d = 0 := by
      by_contra hn
      exact (mem_chainSupport.mp (hs (mem_chainSupport.mpr hn))) h
    exact hd (show z d - (z e / c e) * c d = 0 by rw [h, h', mul_zero, sub_zero])
  · intro h
    have hm : e ∈ chainSupport z := mem_chainSupport.mpr hz
    rw [← h] at hm
    exact (mem_chainSupport.mp hm) he

/-- Span of the actual signed chains of simple cycles of length at most `k`. -/
noncomputable def shortSimpleCycleSpan {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (k : ℕ) :
    Submodule K (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  Submodule.span K {z | ∃ (v : V) (p : G.Walk v v),
    p.IsCycle ∧ p.length ≤ k ∧ z.val = walkChain G p.getVert p.length}

theorem shortSimpleCycleSpan_le_shortWalkCycles {V K : Type*}
    [LinearOrder V] [Fintype V] [Field K] (G : SimpleGraph V) (k : ℕ) :
    shortSimpleCycleSpan (K := K) G k ≤ shortWalkCycles G k := by
  apply Submodule.span_le.mpr
  rintro z ⟨v, p, _, hlen, hz⟩
  apply Submodule.subset_span
  exact ⟨p.length, p.getVert, hlen, fun _ hi => p.adj_getVert_succ hi,
    by rw [Walk.getVert_length, Walk.getVert_zero],
    fun d hd => walkChain_nonzero_traversed G p.getVert p.length d (by rwa [← hz])⟩

theorem circulation_mem_shortSimpleCycleSpan {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (k : ℕ)
    (z : LinearMap.ker (simpleGraphBoundary (K := K) G))
    (hk : (chainSupport z.val).card ≤ k) : z ∈ shortSimpleCycleSpan G k := by
  classical
  generalize hn : (chainSupport z.val).card = n at *
  induction n using Nat.strong_induction_on generalizing z with
  | h n ih =>
    by_cases hz : z.val = 0
    · have he : z = 0 := Subtype.ext hz
      simpa only [he] using (shortSimpleCycleSpan G k).zero_mem
    obtain ⟨v, p, hp⟩ := nonzero_circulation_support_has_cycle G z.val
      (LinearMap.mem_ker.mp z.property) hz
    have ha : ∀ i < p.length, G.Adj (p.getVert i) (p.getVert (i+1)) :=
      fun i hi => circulationSupportGraph_le G z.val (p.adj_getVert_succ hi)
    have hclosed : p.getVert p.length = p.getVert 0 := by simp
    let c : LinearMap.ker (simpleGraphBoundary (K := K) G) :=
      ⟨walkChain G p.getVert p.length, LinearMap.mem_ker.mpr
        (closedWalkChain_boundary_zero G p.getVert p.length ha hclosed)⟩
    have edgeAt (i : ℕ) (hi : i < p.length) :
        ∃ e : OrderedEdge G, z.val e ≠ 0 ∧
          directedEdgeChainCandidate (K := K) (p.getVert i) (p.getVert (i+1)) e ≠ 0 := by
      obtain ⟨e, he, hf | hr⟩ := p.adj_getVert_succ hi
      · exact ⟨e, he, (directedEdgeChain_ne_zero_iff _ _ _).2 (Or.inl hf)⟩
      · exact ⟨e, he, (directedEdgeChain_ne_zero_iff _ _ _).2 (Or.inr hr)⟩
    have hlen : p.length ≤ n := by
      let edge (i : ℕ) : OrderedEdge G :=
        if hi : i < p.length then (edgeAt i hi).choose
        else (edgeAt 0 (by have := hp.three_le_length; omega)).choose
      have spec (i : ℕ) (hi : i < p.length) := (edgeAt i hi).choose_spec
      have hm : (Finset.range p.length).card ≤ (chainSupport z.val).card := by
        apply Finset.card_le_card_of_injOn edge
        · intro i hi
          have hi' := Finset.mem_range.mp hi
          exact mem_chainSupport.mpr (by simpa only [edge, dif_pos hi'] using (spec i hi').1)
        · intro i hi j hj hij
          have hi' := Finset.mem_range.mp hi
          have hj' := Finset.mem_range.mp hj
          have hei : directedEdgeChainCandidate (K := K) (p.getVert i) (p.getVert (i+1)) (edge i) ≠ 0 := by
            simpa only [edge, dif_pos hi'] using (spec i hi').2
          have hej : directedEdgeChainCandidate (K := K) (p.getVert j) (p.getVert (j+1)) (edge i) ≠ 0 := by
            rw [hij]
            simpa only [edge, dif_pos hj'] using (spec j hj').2
          exact hp.isCircuit.isTrail.edges_nodup.getElem_inj_iff.mp
            ((walk_edge_at_of_coefficient _ hi' hei).trans
              (walk_edge_at_of_coefficient _ hj' hej).symm)
      simpa only [Finset.card_range, hn] using hm
    have hs : chainSupport c.val ⊆ chainSupport z.val := by
      intro d hd
      obtain ⟨i, hi, ht⟩ := walkChain_nonzero_traversed G p.getVert p.length d
        (mem_chainSupport.mp hd)
      obtain ⟨e, he, h⟩ := p.adj_getVert_succ hi
      have hd₁ : d.val.1 = p.getVert i ∨ d.val.2 = p.getVert i :=
        ht.elim (fun h => Or.inl h.1.symm) (fun h => Or.inr h.1.symm)
      have hd₂ : d.val.1 = p.getVert (i + 1) ∨ d.val.2 = p.getVert (i + 1) :=
        ht.elim (fun h => Or.inr h.2.symm) (fun h => Or.inl h.2.symm)
      have he₁ : e.val.1 = p.getVert i ∨ e.val.2 = p.getVert i :=
        h.elim (fun h => Or.inl h.1) (fun h => Or.inr h.2)
      have he₂ : e.val.1 = p.getVert (i + 1) ∨ e.val.2 = p.getVert (i + 1) :=
        h.elim (fun h => Or.inr h.2) (fun h => Or.inl h.1)
      have hed := orderedEdge_unique_incident_pair_candidate d e
        (p.getVert i) (p.getVert (i+1)) (ha i hi).ne hd₁ hd₂ he₁ he₂
      exact mem_chainSupport.mpr (hed ▸ he)
    have hzero : 0 < p.length := by have := hp.three_le_length; omega
    obtain ⟨e, he, hce⟩ := edgeAt 0 hzero
    have hcn : c.val e ≠ 0 := by
      change walkChain (K := K) G p.getVert p.length e ≠ 0
      rw [cycle_walkChain_coefficient hp e hzero hce]
      exact hce
    let a := z.val e / c.val e
    let w := z - a • c
    have hlt : (chainSupport w.val).card < n := by
      rw [← hn]
      exact Finset.card_lt_card (cancel_chain_coefficient z.val c.val e he hcn hs).2
    have hw := ih _ hlt w rfl (by omega)
    let hle := circulationSupportGraph_le G z.val
    have hc : c ∈ shortSimpleCycleSpan G k := by
      apply Submodule.subset_span
      refine ⟨v, p.mapLe hle, hp.mapLe hle, ?_, ?_⟩
      · have hpk : p.length ≤ k := by omega
        simpa [Walk.mapLe] using hpk
      · change walkChain G p.getVert p.length =
          walkChain G (p.mapLe hle).getVert (p.mapLe hle).length
        have hverts : (p.mapLe hle).getVert = p.getVert := by
          funext j
          exact Walk.getVert_map (SimpleGraph.Hom.ofLE hle) p j
        rw [hverts, Walk.length_map]
    have hsum : z = w + a • c := (sub_add_cancel z (a • c)).symm
    rw [hsum]
    exact (shortSimpleCycleSpan G k).add_mem hw ((shortSimpleCycleSpan G k).smul_mem a hc)

theorem circulation_mem_shortWalkCycles {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (k : ℕ)
    (z : LinearMap.ker (simpleGraphBoundary (K := K) G))
    (hk : (chainSupport z.val).card ≤ k) : z ∈ shortWalkCycles G k :=
  shortSimpleCycleSpan_le_shortWalkCycles G k (circulation_mem_shortSimpleCycleSpan G k z hk)

theorem boundedSupportCycleSpace_le_radiusCycles
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K] (G : SimpleGraph V) (r : ℕ) :
    boundedSupportCycleSpace (K := K) G (2 * r + 1) ≤ radiusCycles G r := by
  classical
  apply Submodule.span_le.mpr
  intro z hz
  exact shortWalkCycles_le_radiusCycles G r (circulation_mem_shortWalkCycles G _ z hz)

#print axioms mem_chainSupport
#print axioms directedEdgeChain_ne_zero_iff
#print axioms walk_edge_at
#print axioms walk_edge_at_of_coefficient
#print axioms cycle_walkChain_coefficient
#print axioms cycle_walkChain_coefficient_eq_sign
#print axioms card_chainSupport_walkChain
#print axioms cancel_chain_coefficient
#print axioms shortSimpleCycleSpan_le_shortWalkCycles
#print axioms circulation_mem_shortSimpleCycleSpan
#print axioms circulation_mem_shortWalkCycles
#print axioms boundedSupportCycleSpace_le_radiusCycles

end URF.EntropyBridge.Multiscale

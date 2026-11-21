import URF.Foundation.GeneralRadiusDecomposition

namespace URF.EntropyBridge.Multiscale

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

open scoped Classical in
theorem chainSupport_add_subset (a b : OrderedEdge G → K) :
    chainSupport (a + b) ⊆ chainSupport a ∪ chainSupport b := by
  classical
  intro e he
  simp only [Finset.mem_union, mem_chainSupport, Pi.add_apply] at *
  by_contra! h
  exact he (by rw [h.1, h.2, add_zero])

theorem chainSupport_neg (a : OrderedEdge G → K) :
    chainSupport (-a) = chainSupport a := by
  ext e
  simp

theorem card_chainSupport_add (a b : OrderedEdge G → K) :
    (chainSupport (a + b)).card ≤ (chainSupport a).card + (chainSupport b).card := by
  classical
  exact (Finset.card_le_card (chainSupport_add_subset a b)).trans
    (Finset.card_union_le _ _)

theorem directedEdgeChain_swap (a b : V) :
    directedEdgeChainCandidate (K := K) (G := G) b a =
      -directedEdgeChainCandidate (G := G) a b := by
  classical
  funext e
  by_cases hf : e.val.1 = a ∧ e.val.2 = b
  · have hr : ¬ (e.val.1 = b ∧ e.val.2 = a) := by
      intro hr
      exact (ne_of_lt e.property.1) (hf.1.trans hr.2.symm)
    simp only [Pi.neg_apply, directedEdgeChainCandidate, if_pos hf, if_neg hr]
  · by_cases hr : e.val.1 = b ∧ e.val.2 = a
    · simp only [Pi.neg_apply, directedEdgeChainCandidate, if_neg hf, if_pos hr, neg_neg]
    · simp only [Pi.neg_apply, directedEdgeChainCandidate, if_neg hf, if_neg hr, neg_zero]

open scoped Classical in
theorem orderedEdgeChain_apply (e d : OrderedEdge G) :
    directedEdgeChainCandidate (K := K) e.val.1 e.val.2 d = if d = e then 1 else 0 := by
  classical
  have hr : ¬ (d.val.1 = e.val.2 ∧ d.val.2 = e.val.1) := by
    rintro ⟨h₁, h₂⟩
    exact lt_asymm e.property.1 (by simpa only [h₁, h₂] using d.property.1)
  have hf : (d.val.1 = e.val.1 ∧ d.val.2 = e.val.2) ↔ d = e := by
    constructor
    · rintro ⟨a, b⟩
      exact Subtype.ext (Prod.ext a b)
    · rintro rfl
      exact ⟨rfl, rfl⟩
  simp [directedEdgeChainCandidate, hf, hr]

/-- Minimal ball layers are breadth-first distances from the root. -/
noncomputable def ballDepth (root : V) (r : ℕ) (x : closedRadiusBall G root r) : ℕ := by
  classical
  exact Nat.find (show ∃ n, x.val ∈ closedRadiusBall G root n from ⟨r, x.property⟩)

theorem ballDepth_spec (root : V) (r : ℕ) (x : closedRadiusBall G root r) :
    x.val ∈ closedRadiusBall G root (ballDepth root r x) ∧ ballDepth root r x ≤ r := by
  classical
  let hex : ∃ n, x.val ∈ closedRadiusBall G root n := ⟨r, x.property⟩
  unfold ballDepth
  exact ⟨Nat.find_spec hex, Nat.find_min' hex x.property⟩

theorem ballDepth_parent_exists (root : V) (r : ℕ) (x : closedRadiusBall G root r)
    (hx : ballDepth root r x ≠ 0) :
    ∃ y : closedRadiusBall G root r, G.Adj y.val x.val ∧
      ballDepth root r y + 1 = ballDepth root r x := by
  classical
  obtain ⟨m, hm⟩ := Nat.exists_eq_succ_of_ne_zero hx
  have hd := (ballDepth_spec root r x).1
  rw [hm] at hd
  change x.val ∈ closedRadiusBall G root m ∨
    ∃ y ∈ closedRadiusBall G root m, G.Adj y x.val at hd
  rcases hd with hd | ⟨v, hv, ha⟩
  · have h := Nat.find_min' (show ∃ n, x.val ∈ closedRadiusBall G root n from
        ⟨r, x.property⟩) hd
    change ballDepth root r x ≤ m at h
    omega
  · let y : closedRadiusBall G root r :=
      ⟨v, closedRadiusBall_mono G root (by have := (ballDepth_spec root r x).2; omega) hv⟩
    refine ⟨y, ha, ?_⟩
    have hy := Nat.find_min' (show ∃ n, y.val ∈ closedRadiusBall G root n from
        ⟨r, y.property⟩) hv
    change ballDepth root r y ≤ m at hy
    have hxy : x.val ∈ closedRadiusBall G root (ballDepth root r y + 1) :=
      Or.inr ⟨y.val, (ballDepth_spec root r y).1, ha⟩
    have h := Nat.find_min' (show ∃ n, x.val ∈ closedRadiusBall G root n from
        ⟨r, x.property⟩) hxy
    change ballDepth root r x ≤ ballDepth root r y + 1 at h
    omega

/-- The breadth-first tree uses one predecessor in the previous layer for each
positive-depth vertex. Its root paths are obtained by following predecessors. -/
noncomputable def ballParent (root : V) (r : ℕ) (x : closedRadiusBall G root r)
    (hx : ballDepth root r x ≠ 0) : closedRadiusBall G root r :=
  (ballDepth_parent_exists root r x hx).choose

theorem ballParent_spec (root : V) (r : ℕ) (x : closedRadiusBall G root r)
    (hx : ballDepth root r x ≠ 0) :
    G.Adj (ballParent root r x hx).val x.val ∧
      ballDepth root r (ballParent root r x hx) + 1 = ballDepth root r x :=
  (ballDepth_parent_exists root r x hx).choose_spec

def IsBallTreeEdge (root : V) (r : ℕ) (e : OrderedEdge G) : Prop :=
  ∃ (x : closedRadiusBall G root r) (hx : ballDepth root r x ≠ 0),
    (e.val.1 = (ballParent root r x hx).val ∧ e.val.2 = x.val) ∨
    (e.val.2 = (ballParent root r x hx).val ∧ e.val.1 = x.val)

noncomputable def ballPathChain (root : V) (r : ℕ) (x : closedRadiusBall G root r) :
    OrderedEdge G → K := by
  classical
  exact if hx : ballDepth root r x = 0 then 0 else
    ballPathChain root r (ballParent root r x hx) +
      directedEdgeChainCandidate (ballParent root r x hx).val x.val
termination_by ballDepth root r x
decreasing_by have := (ballParent_spec root r x hx).2; omega

theorem ballPathChain_spec (root : V) (r : ℕ) (x : closedRadiusBall G root r) :
    (∀ u, simpleGraphBoundary (K := K) G (ballPathChain root r x) u =
      (if u = x.val then 1 else 0) - (if u = root then 1 else 0)) ∧
    (chainSupport (ballPathChain (K := K) root r x)).card ≤ ballDepth root r x ∧
    ∀ e ∈ chainSupport (ballPathChain (K := K) root r x), IsBallTreeEdge root r e := by
  classical
  rw [ballPathChain]
  split
  · rename_i h
    have hx := (ballDepth_spec root r x).1
    rw [h] at hx
    change x.val = root at hx
    simp [hx, chainSupport]
  · rename_i hx
    let y := ballParent root r x hx
    have hy := ballParent_spec root r x hx
    have ih := ballPathChain_spec root r y
    have hs : ∀ e ∈ chainSupport (directedEdgeChainCandidate (K := K) y.val x.val : OrderedEdge G → K),
        IsBallTreeEdge root r e := by
      intro e he
      rcases (directedEdgeChain_ne_zero_iff _ _ _).1 (mem_chainSupport.mp he) with h | h
      · exact ⟨x, hx, Or.inl h⟩
      · exact ⟨x, hx, Or.inr ⟨h.2, h.1⟩⟩
    refine ⟨?_, ?_, ?_⟩
    · intro u
      rw [map_add]
      change simpleGraphBoundary (K := K) G (ballPathChain root r y) u +
        simpleGraphBoundary (K := K) G (directedEdgeChainCandidate y.val x.val) u = _
      rw [ih.1, directed_edge_boundary_candidate G _ _ hy.1]
      ring
    · have hcard : (chainSupport
          (directedEdgeChainCandidate (K := K) y.val x.val : OrderedEdge G → K)).card ≤ 1 := by
        simpa [walkChain] using card_chainSupport_walkChain (K := K) G
          (fun i => if i = 0 then y.val else x.val) 1
      have hdepth : ballDepth root r y + 1 = ballDepth root r x := hy.2
      have hpath := ih.2.1
      exact (card_chainSupport_add (ballPathChain (K := K) root r y)
        (directedEdgeChainCandidate y.val x.val)).trans (by omega)
    · intro e he
      rcases Finset.mem_union.mp (chainSupport_add_subset _ _ he) with h | h
      · exact ih.2.2 e h
      · exact hs e h
termination_by ballDepth root r x
decreasing_by
  exact Nat.lt_of_succ_le (le_of_eq (ballParent_spec root r x (by assumption)).2)

noncomputable def ballFundamentalChain (root : V) (r : ℕ) (e : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r) :
    OrderedEdge G → K :=
  ballPathChain root r ⟨e.val.1, ha⟩ + directedEdgeChainCandidate e.val.1 e.val.2 -
    ballPathChain root r ⟨e.val.2, hb⟩

theorem ballFundamentalChain_boundary (root : V) (r : ℕ) (e : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r) :
    simpleGraphBoundary (K := K) G (ballFundamentalChain root r e ha hb) = 0 := by
  classical
  funext u
  simp only [ballFundamentalChain, map_sub, map_add, Pi.sub_apply, Pi.add_apply, Pi.zero_apply]
  rw [(ballPathChain_spec root r ⟨e.val.1, ha⟩).1,
    (ballPathChain_spec root r ⟨e.val.2, hb⟩).1,
    directed_edge_boundary_candidate G _ _ e.property.2]
  ring

theorem card_ballFundamentalChain (root : V) (r : ℕ) (e : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r) :
    (chainSupport (ballFundamentalChain (K := K) root r e ha hb)).card ≤ 2 * r + 1 := by
  classical
  have hcard : (chainSupport (directedEdgeChainCandidate (K := K)
      e.val.1 e.val.2 : OrderedEdge G → K)).card = 1 := by
    have h : chainSupport (directedEdgeChainCandidate (K := K) e.val.1 e.val.2) = {e} := by
      ext d
      simp [orderedEdgeChain_apply]
    rw [h, Finset.card_singleton]
  have ha' := (ballPathChain_spec (K := K) root r ⟨e.val.1, ha⟩).2.1
  have hb' := (ballPathChain_spec (K := K) root r ⟨e.val.2, hb⟩).2.1
  have hda := (ballDepth_spec root r ⟨e.val.1, ha⟩).2
  have hdb := (ballDepth_spec root r ⟨e.val.2, hb⟩).2
  unfold ballFundamentalChain
  rw [sub_eq_add_neg]
  refine (card_chainSupport_add _ _).trans ?_
  rw [chainSupport_neg]
  have := card_chainSupport_add (ballPathChain (K := K) root r ⟨e.val.1, ha⟩)
    (directedEdgeChainCandidate e.val.1 e.val.2)
  omega

open scoped Classical in
theorem ballFundamentalChain_chord (root : V) (r : ℕ) (e d : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r)
    (hd : ¬ IsBallTreeEdge root r d) :
    ballFundamentalChain (K := K) root r e ha hb d = if d = e then 1 else 0 := by
  classical
  have vanish (x : closedRadiusBall G root r) : ballPathChain (K := K) root r x d = 0 := by
    by_contra h
    exact hd ((ballPathChain_spec root r x).2.2 d (mem_chainSupport.mpr h))
  simp [ballFundamentalChain, vanish, orderedEdgeChain_apply]

theorem ballFundamentalChain_tree (root : V) (r : ℕ) (e : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r)
    (he : IsBallTreeEdge root r e) :
    ballFundamentalChain (K := K) root r e ha hb = 0 := by
  obtain ⟨x, hx, h | h⟩ := he
  · have ea : (⟨e.val.1, ha⟩ : closedRadiusBall G root r) = ballParent root r x hx :=
      Subtype.ext h.1
    have eb : (⟨e.val.2, hb⟩ : closedRadiusBall G root r) = x := Subtype.ext h.2
    unfold ballFundamentalChain
    rw [ea, eb, h.1, h.2]
    have heq : ballPathChain (K := K) root r x =
        ballPathChain root r (ballParent root r x hx) +
          directedEdgeChainCandidate (ballParent root r x hx).val x.val := by
      rw [ballPathChain, dif_neg hx]
    rw [heq, sub_self]
  · have ea : (⟨e.val.1, ha⟩ : closedRadiusBall G root r) = x := Subtype.ext h.2
    have eb : (⟨e.val.2, hb⟩ : closedRadiusBall G root r) = ballParent root r x hx :=
      Subtype.ext h.1
    unfold ballFundamentalChain
    rw [ea, eb, h.1, h.2]
    have heq : ballPathChain (K := K) root r x =
        ballPathChain root r (ballParent root r x hx) +
          directedEdgeChainCandidate (ballParent root r x hx).val x.val := by
      rw [ballPathChain, dif_neg hx]
    rw [heq, directedEdgeChain_swap (ballParent root r x hx).val x.val]
    abel

/-- The normalized fundamental circulations sum to the original circulation,
with the coefficient on each chord read directly from the original chain. -/
theorem ballFundamentalChain_expansion (root : V) (r : ℕ) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (hs : ∀ e, z e ≠ 0 → e.val.1 ∈ closedRadiusBall G root r ∧
      e.val.2 ∈ closedRadiusBall G root r) :
    z = ∑ e ∈ (chainSupport z).attach,
      z e.val • ballFundamentalChain root r e.val
        (hs _ (mem_chainSupport.mp e.property)).1
        (hs _ (mem_chainSupport.mp e.property)).2 := by
  classical
  let P (u : V) : OrderedEdge G → K :=
    if hu : u ∈ closedRadiusBall G root r then ballPathChain root r ⟨u, hu⟩ else 0
  funext d
  have hformula (e : OrderedEdge G) (h : e ∈ chainSupport z) :
      (z e • ballFundamentalChain root r e
        (hs _ (mem_chainSupport.mp h)).1 (hs _ (mem_chainSupport.mp h)).2) d =
      z e * (if d = e then 1 else 0) + z e * (P e.val.1 d - P e.val.2 d) := by
    have he := hs e (mem_chainSupport.mp h)
    simp only [ballFundamentalChain, Pi.smul_apply, smul_eq_mul, Pi.sub_apply, Pi.add_apply,
      P, dif_pos he.1, dif_pos he.2, orderedEdgeChain_apply]
    ring
  rw [Finset.sum_apply]
  have hrewrite :
      (∑ e ∈ (chainSupport z).attach,
        (z e.val • ballFundamentalChain root r e.val
          (hs _ (mem_chainSupport.mp e.property)).1
          (hs _ (mem_chainSupport.mp e.property)).2) d) =
      ∑ e ∈ (chainSupport z).attach,
        (z e.val * (if d = e.val then 1 else 0) +
          z e.val * (P e.val.val.1 d - P e.val.val.2 d)) :=
    Finset.sum_congr rfl fun e _ => hformula e.val e.property
  rw [hrewrite, Finset.sum_attach (chainSupport z) (fun e : OrderedEdge G =>
    z e * (if d = e then 1 else 0) + z e * (P e.val.1 d - P e.val.2 d))]
  have hext : (∑ e ∈ chainSupport z,
        (z e * (if d = e then 1 else 0) + z e * (P e.val.1 d - P e.val.2 d))) =
      ∑ e : OrderedEdge G,
        (z e * (if d = e then 1 else 0) + z e * (P e.val.1 d - P e.val.2 d)) := by
    apply Finset.sum_subset (Finset.subset_univ _)
    intro e _ he
    have h : z e = 0 := by simpa using he
    simp [h]
  rw [hext, Finset.sum_add_distrib]
  have hdiag : (∑ e : OrderedEdge G, z e * (if d = e then 1 else 0)) = z d := by
    rw [Finset.sum_eq_single d]
    · simp
    · intro e _ he
      simp [Ne.symm he]
    · simp
  rw [hdiag]
  have hzero : (∑ e : OrderedEdge G, z e * (P e.val.1 d - P e.val.2 d)) = 0 := by
    have h := congrArg (fun f : V → K => ∑ u : V, P u d * f u) hz
    change (∑ u : V, P u d * (∑ e : OrderedEdge G,
      simpleGraphIncidence (K := K) G u e * z e)) = _ at h
    simp only [Pi.zero_apply, mul_zero, Finset.sum_const_zero, Finset.mul_sum] at h
    rw [Finset.sum_comm] at h
    have hterm (e : OrderedEdge G) :
        (∑ u : V, P u d * (simpleGraphIncidence (K := K) G u e * z e)) =
          -(z e * (P e.val.1 d - P e.val.2 d)) := by
      have he : e.val.1 ≠ e.val.2 := ne_of_lt e.property.1
      have hinc (u : V) : simpleGraphIncidence (K := K) G u e =
          (if u = e.val.2 then 1 else 0) - (if u = e.val.1 then 1 else 0) := by
        by_cases h₁ : u = e.val.1
        · subst u
          simp [simpleGraphIncidence, he]
        · simp [simpleGraphIncidence, h₁]
      simp only [hinc, sub_mul, mul_sub, Finset.sum_sub_distrib]
      simp only [ite_mul, one_mul, zero_mul, mul_ite, mul_zero, Finset.sum_ite_eq',
        Finset.mem_univ, if_true]
      ring
    simp only [hterm, Finset.sum_neg_distrib, neg_eq_zero] at h
    exact h
  rw [hzero, add_zero]

theorem ballFundamentalChain_supported (root : V) (r : ℕ) (e : OrderedEdge G)
    (ha : e.val.1 ∈ closedRadiusBall G root r) (hb : e.val.2 ∈ closedRadiusBall G root r)
    (d : OrderedEdge G) (hd : ballFundamentalChain (K := K) root r e ha hb d ≠ 0) :
    d.val.1 ∈ closedRadiusBall G root r ∧ d.val.2 ∈ closedRadiusBall G root r := by
  classical
  by_cases ht : IsBallTreeEdge root r d
  · obtain ⟨x, hx, h | h⟩ := ht
    · rw [h.1, h.2]
      exact ⟨(ballParent root r x hx).property, x.property⟩
    · rw [h.1, h.2]
      exact ⟨x.property, (ballParent root r x hx).property⟩
  · have he : d = e := by
      by_contra h
      exact hd (by rw [ballFundamentalChain_chord root r e d ha hb ht, if_neg h])
    subst d
    exact ⟨ha, hb⟩

/-- Circulations in the induced ball, embedded in the ambient edge chains. -/
noncomputable def ballCirculations (root : V) (r : ℕ) : Submodule K (OrderedEdge G → K) where
  carrier := {z | simpleGraphBoundary (K := K) G z = 0 ∧
    ∀ e, z e ≠ 0 → e.val.1 ∈ closedRadiusBall G root r ∧
      e.val.2 ∈ closedRadiusBall G root r}
  zero_mem' := ⟨map_zero _, fun _ h => False.elim (h rfl)⟩
  add_mem' := by
    rintro a b ⟨ha, hsa⟩ ⟨hb, hsb⟩
    refine ⟨by rw [map_add, ha, hb, add_zero], ?_⟩
    intro e he
    by_cases h : a e = 0
    · exact hsb e (by simpa only [Pi.add_apply, h, zero_add] using he)
    · exact hsa e h
  smul_mem' := by
    rintro a z ⟨hz, hs⟩
    refine ⟨by rw [map_smul, hz, smul_zero], ?_⟩
    intro e he
    apply hs e
    intro h
    exact he (by simp [h])

def BallChord (root : V) (r : ℕ) (G : SimpleGraph V) :=
  {e : OrderedEdge G // (e.val.1 ∈ closedRadiusBall G root r ∧
      e.val.2 ∈ closedRadiusBall G root r) ∧ ¬ IsBallTreeEdge root r e}

noncomputable def ballFundamentalVector (root : V) (r : ℕ) (e : BallChord root r G) :
    ballCirculations (K := K) (G := G) root r :=
  ⟨ballFundamentalChain root r e.val e.property.1.1 e.property.1.2,
    ballFundamentalChain_boundary root r e.val e.property.1.1 e.property.1.2,
    ballFundamentalChain_supported root r e.val e.property.1.1 e.property.1.2⟩

theorem ballFundamentalVector_independent (root : V) (r : ℕ) :
    LinearIndependent K (ballFundamentalVector (K := K) (G := G) root r) := by
  classical
  letI : Fintype (BallChord root r G) := by
    unfold BallChord
    infer_instance
  apply Fintype.linearIndependent_iff.mpr
  intro c hc d
  have h := congrArg (fun z : ballCirculations (K := K) (G := G) root r => z.val d.val) hc
  let eval : ballCirculations (K := K) (G := G) root r →ₗ[K] K :=
    (LinearMap.proj d.val).comp (ballCirculations (K := K) (G := G) root r).subtype
  change eval (∑ i, c i • ballFundamentalVector root r i) = eval 0 at h
  simp only [map_sum, map_smul, map_zero, smul_eq_mul] at h
  have hval (e : BallChord root r G) :
      eval (ballFundamentalVector root r e) = if d.val = e.val then 1 else 0 :=
    ballFundamentalChain_chord root r e.val d.val e.property.1.1 e.property.1.2 d.property.2
  simp only [hval] at h
  rw [Finset.sum_eq_single d] at h
  · simpa using h
  · intro e _ he
    have hne : d.val ≠ e.val := fun hde => he (Subtype.ext hde.symm)
    simp [hne]
  · simp

theorem ballFundamentalVector_spans (root : V) (r : ℕ) :
    ⊤ ≤ Submodule.span K (Set.range (ballFundamentalVector (K := K) (G := G) root r)) := by
  classical
  intro z _
  obtain ⟨hz, hs⟩ := z.property
  let term (e : {e // e ∈ chainSupport z.val}) :
      ballCirculations (K := K) (G := G) root r :=
    if ht : IsBallTreeEdge root r e.val then 0 else
      z.val e.val • ballFundamentalVector root r ⟨e.val, hs _ (mem_chainSupport.mp e.property), ht⟩
  have heq : z = ∑ e ∈ (chainSupport z.val).attach, term e := by
    apply Subtype.ext
    change z.val = (ballCirculations (K := K) (G := G) root r).subtype (∑ e ∈ _, term e)
    rw [map_sum]
    refine (ballFundamentalChain_expansion root r z.val hz hs).trans ?_
    apply Finset.sum_congr rfl
    intro e _
    by_cases ht : IsBallTreeEdge root r e.val
    · simp [term, ht, ballFundamentalChain_tree root r e.val _ _ ht]
    · simp only [term, dif_neg ht] <;> rfl
  rw [heq]
  apply Submodule.sum_mem
  intro e _
  by_cases ht : IsBallTreeEdge root r e.val
  · simp [term, ht]
  · simp only [term, dif_neg ht]
    exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨_, rfl⟩)

/-- A basis of the induced ball's circulation space indexed by its non-tree edges. -/
noncomputable def ballFundamentalBasis (root : V) (r : ℕ) :
    Module.Basis (BallChord root r G) K (ballCirculations (K := K) (G := G) root r) :=
  Module.Basis.mk (ballFundamentalVector_independent root r) (ballFundamentalVector_spans root r)

theorem card_ballFundamentalBasis (root : V) (r : ℕ) (e : BallChord root r G) :
    (chainSupport (ballFundamentalBasis (K := K) root r e).val).card ≤ 2 * r + 1 := by
  unfold ballFundamentalBasis
  rw [Module.Basis.mk_apply]
  exact card_ballFundamentalChain root r e.val e.property.1.1 e.property.1.2

theorem radiusCycles_le_boundedSupportCycleSpace (G : SimpleGraph V) (r : ℕ) :
    radiusCycles (K := K) G r ≤ boundedSupportCycleSpace G (2 * r + 1) := by
  classical
  let B := boundedSupportCycleSpace (K := K) G (2 * r + 1)
  let i := (LinearMap.ker (simpleGraphBoundary (K := K) G)).subtype
  have hle : radiusAmbient (K := K) G r ≤ B.map i := by
    apply Submodule.span_le.mpr
    rintro z ⟨hz, root, hs⟩
    rw [ballFundamentalChain_expansion root r z hz hs]
    apply Submodule.sum_mem
    intro e _
    have he := hs e.val (mem_chainSupport.mp e.property)
    let c : LinearMap.ker (simpleGraphBoundary (K := K) G) :=
      ⟨ballFundamentalChain root r e.val he.1 he.2,
        LinearMap.mem_ker.mpr (ballFundamentalChain_boundary root r e.val he.1 he.2)⟩
    apply (B.map i).smul_mem
    exact ⟨c, Submodule.subset_span (card_ballFundamentalChain root r e.val he.1 he.2), rfl⟩
  intro z hz
  obtain ⟨w, hw, he⟩ := hle hz
  simpa only [(Subtype.ext he : w = z)] using hw

theorem radiusCycles_eq_boundedSupportCycleSpace (G : SimpleGraph V) (r : ℕ) :
    radiusCycles (K := K) G r = boundedSupportCycleSpace G (2 * r + 1) :=
  le_antisymm (radiusCycles_le_boundedSupportCycleSpace G r)
    (boundedSupportCycleSpace_le_radiusCycles G r)

#print axioms chainSupport_add_subset
#print axioms chainSupport_neg
#print axioms card_chainSupport_add
#print axioms directedEdgeChain_swap
#print axioms orderedEdgeChain_apply
#print axioms ballDepth_spec
#print axioms ballDepth_parent_exists
#print axioms ballParent_spec
#print axioms ballPathChain_spec
#print axioms ballFundamentalChain_boundary
#print axioms card_ballFundamentalChain
#print axioms ballFundamentalChain_chord
#print axioms ballFundamentalChain_tree
#print axioms ballFundamentalChain_expansion
#print axioms ballFundamentalChain_supported
#print axioms ballFundamentalVector_independent
#print axioms ballFundamentalVector_spans
#print axioms ballFundamentalBasis
#print axioms card_ballFundamentalBasis
#print axioms radiusCycles_le_boundedSupportCycleSpace
#print axioms radiusCycles_eq_boundedSupportCycleSpace

end URF.EntropyBridge.Multiscale

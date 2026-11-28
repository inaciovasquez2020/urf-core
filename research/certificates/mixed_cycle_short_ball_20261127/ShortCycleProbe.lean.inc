
namespace URF.EntropyBridge

/-- Candidate: a short cycle's rooted induced ball contains exactly its
connected component. Verification pending the isolated Lean CI replay. -/
theorem cyclePartition_shortBall_eq_component
    {sizes : List ℕ}
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
    (r : ℕ) (u : CyclePartitionVertex sizes)
    (hshort : sizes.get u.1 ≤ 2 * r + 1) :
    rootedBallVertices (cyclePartitionSimpleGraph sizes) r u =
      {v | v.1 = u.1} := by
  let hp : ∀ i : Fin sizes.length, 0 < sizes.get i :=
    fun i => by have := h3 i; omega
  ext v
  constructor
  · intro hv
    exact (cyclePartition_reachable_same_component sizes u v hv.1).symm
  · intro hv
    rcases u with ⟨i, x⟩
    rcases v with ⟨j, y⟩
    change j = i at hv
    subst j
    let u' : CyclePartitionVertex sizes := ⟨i, x⟩
    let v' : CyclePartitionVertex sizes := ⟨i, y⟩
    let d : ℤ := (y.val : ℤ) - x.val
    let m : ℤ := sizes.get i
    have hx : (x.val : ℤ) < m := by
      dsimp only [m]
      exact_mod_cast x.isLt
    have hy : (y.val : ℤ) < m := by
      dsimp only [m]
      exact_mod_cast y.isLt
    have hs : m ≤ 2 * (r : ℤ) + 1 := by
      dsimp only [m]
      have hsNat : sizes.get i ≤ 2 * r + 1 := hshort
      exact_mod_cast hsNat
    have hdlo : -m < d := by dsimp [d]; omega
    have hdhi : d < m := by dsimp [d]; omega
    have hbase : cycleOffset hp u' d = v' := by
      apply congrArg (Sigma.mk i)
      apply Fin.ext
      have h := cycleOffset_val hp u' d
      change ((cycleOffset hp u' d).2.val : ℤ) =
        ((x.val : ℤ) + d) % m at h
      have he : (x.val : ℤ) + d = y.val := by dsimp [d]; ring
      rw [he, Int.emod_eq_of_lt (by positivity) hy] at h
      exact_mod_cast h
    change v' ∈ rootedBallVertices (cyclePartitionSimpleGraph sizes) r u'
    by_cases hpos : (r : ℤ) < d
    · have he : cycleOffset hp u' (d - m) = v' := by
        calc
          _ = cycleOffset hp u' d := by
            apply (cycleOffset_eq hp u' _ _).2
            change d - m ≡ d [ZMOD m]
            apply Int.modEq_iff_dvd.mpr
            exact ⟨1, by ring⟩
          _ = v' := hbase
      rw [← he]
      exact cycleOffset_mem_ball hp h3 u' r (d - m) (by omega) (by omega)
    · by_cases hneg : d < -(r : ℤ)
      · have he : cycleOffset hp u' (d + m) = v' := by
          calc
            _ = cycleOffset hp u' d := by
              apply (cycleOffset_eq hp u' _ _).2
              change d + m ≡ d [ZMOD m]
              apply Int.modEq_iff_dvd.mpr
              exact ⟨-1, by ring⟩
            _ = v' := hbase
        rw [← he]
        exact cycleOffset_mem_ball hp h3 u' r (d + m) (by omega) (by omega)
      · rw [← hbase]
        exact cycleOffset_mem_ball hp h3 u' r d (by omega) (by omega)

#print axioms cyclePartition_shortBall_eq_component

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- Canonical cycle on residue representatives, with clockwise modular
successor and its symmetric, irreflexive closure. -/
def canonicalShortCycle (m : ℕ) : SimpleGraph (Fin m) :=
  SimpleGraph.fromRel (fun a b : Fin m =>
    (a.val : ℤ) + 1 ≡ (b.val : ℤ) [ZMOD (m : ℤ)])

/-- Candidate: the entire short-cycle ball is rooted-isomorphic to the
canonical modular cycle, rooted at residue zero. -/
theorem cyclePartition_shortBall_rootedIso
    {sizes : List ℕ}
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
    (r : ℕ) (u : CyclePartitionVertex sizes)
    (hshort : sizes.get u.1 ≤ 2 * r + 1) :
    ∃ e : canonicalShortCycle (sizes.get u.1) ≃g
        (cyclePartitionSimpleGraph sizes).induce
          (rootedBallVertices (cyclePartitionSimpleGraph sizes) r u),
      e ⟨0, lt_of_lt_of_le (by decide : 0 < 3) (h3 u.1)⟩ =
        rootedBallRoot (cyclePartitionSimpleGraph sizes) r u := by
  let hp : ∀ i : Fin sizes.length, 0 < sizes.get i :=
    fun i => lt_of_lt_of_le (by decide : 0 < 3) (h3 i)
  let f : Fin (sizes.get u.1) →
      rootedBallVertices (cyclePartitionSimpleGraph sizes) r u :=
    fun a => ⟨cycleOffset hp u (a.val : ℤ), by
      rw [cyclePartition_shortBall_eq_component h3 r u hshort]
      rfl⟩
  have hf : Function.Bijective f := by
    constructor
    · intro a b hab
      apply Fin.ext
      have hm := (cycleOffset_eq hp u (a.val : ℤ) (b.val : ℤ)).1
        (congrArg Subtype.val hab)
      have ha := a.isLt
      have hb := b.isLt
      have he := cycleOffset_modEq_eq hm (by omega)
      exact_mod_cast he
    · intro v
      obtain ⟨w⟩ := v.property.1
      obtain ⟨d, _, _, hd⟩ := cycleOffset_walk hp h3 w
      let z : ℤ := d % (sizes.get u.1 : ℤ)
      have hm : (0 : ℤ) < (sizes.get u.1 : ℤ) := by
        exact_mod_cast hp u.1
      have hznonneg : 0 ≤ z := Int.emod_nonneg _ hm.ne'
      have hzlt : z < (sizes.get u.1 : ℤ) := Int.emod_lt_of_pos _ hm
      let a : Fin (sizes.get u.1) := ⟨z.toNat, by omega⟩
      have ha : (a.val : ℤ) = z := Int.toNat_of_nonneg hznonneg
      refine ⟨a, Subtype.ext ?_⟩
      change cycleOffset hp u (a.val : ℤ) = v.val
      calc
        _ = cycleOffset hp u d := by
          apply (cycleOffset_eq hp u _ _).2
          rw [ha]
          change (d % (sizes.get u.1 : ℤ)) % (sizes.get u.1 : ℤ) =
            d % (sizes.get u.1 : ℤ)
          simp
        _ = v.val := hd
  let e : canonicalShortCycle (sizes.get u.1) ≃g
      (cyclePartitionSimpleGraph sizes).induce
        (rootedBallVertices (cyclePartitionSimpleGraph sizes) r u) :=
    ⟨Equiv.ofBijective f hf, by
      intro a b
      change (cyclePartitionSimpleGraph sizes).Adj
          (cycleOffset hp u (a.val : ℤ)) (cycleOffset hp u (b.val : ℤ)) ↔
        a ≠ b ∧
          (((a.val : ℤ) + 1 ≡ (b.val : ℤ) [ZMOD (sizes.get u.1 : ℤ)]) ∨
           ((b.val : ℤ) + 1 ≡ (a.val : ℤ) [ZMOD (sizes.get u.1 : ℤ)]))
      have hrev :
          ((a.val : ℤ) + (-1) ≡ (b.val : ℤ) [ZMOD (sizes.get u.1 : ℤ)]) ↔
          ((b.val : ℤ) + 1 ≡ (a.val : ℤ) [ZMOD (sizes.get u.1 : ℤ)]) := by
        constructor
        · intro h
          have hh := h.symm.add_left (1 : ℤ)
          have he : 1 + ((a.val : ℤ) + (-1)) = (a.val : ℤ) := by ring
          rw [he, add_comm (1 : ℤ) (b.val : ℤ)] at hh
          exact hh
        · intro h
          have hh := h.symm.add_left (-1 : ℤ)
          have he : -1 + ((b.val : ℤ) + 1) = (b.val : ℤ) := by ring
          rw [he, add_comm (-1 : ℤ) (a.val : ℤ)] at hh
          exact hh
      constructor
      · intro h
        have hab : a ≠ b := by
          intro hab
          subst b
          exact (cyclePartitionSimpleGraph sizes).loopless _ h
        rw [cycleOffset_adj hp h3, cycleOffset_add, cycleOffset_add,
          cycleOffset_eq, cycleOffset_eq] at h
        refine ⟨hab, ?_⟩
        rcases h with h | h
        · exact Or.inl h
        · exact Or.inr (hrev.mp h)
      · rintro ⟨_, h⟩
        rw [cycleOffset_adj hp h3, cycleOffset_add, cycleOffset_add,
          cycleOffset_eq, cycleOffset_eq]
        rcases h with h | h
        · exact Or.inl h
        · exact Or.inr (hrev.mpr h)⟩
  refine ⟨e, ?_⟩
  apply Subtype.ext
  change cycleOffset hp u 0 = u
  exact cycleOffset_zero hp u

#print axioms cyclePartition_shortBall_rootedIso

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- The rooted isomorphism class of the canonical modular cycle. -/
def canonicalShortCycleClass (m : ℕ) (hm : 0 < m) :
    RootedNeighborhoodClass :=
  Quotient.mk _ ⟨Fin m, canonicalShortCycle m, ⟨0, hm⟩⟩

/-- Candidate: equality of canonical rooted cycle classes detects their lengths. -/
theorem canonicalShortCycleClass_eq_iff
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n) :
    canonicalShortCycleClass m hm = canonicalShortCycleClass n hn ↔ m = n := by
  constructor
  · intro h
    have hIso : RootedNeighborhood.isoSetoid.r
        ⟨Fin m, canonicalShortCycle m, ⟨0, hm⟩⟩
        ⟨Fin n, canonicalShortCycle n, ⟨0, hn⟩⟩ := by
      apply Quotient.exact
      exact h
    obtain ⟨e, _⟩ := hIso
    simpa only [Fintype.card_fin] using Fintype.card_congr e.toEquiv
  · intro h
    subst n
    rfl

#print axioms canonicalShortCycleClass_eq_iff

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- Candidate: a canonical simple cycle cannot have the rooted class
of a centered path, even when their vertex cardinalities coincide. -/
theorem canonicalShortCycleClass_ne_centeredPathClass
    (m r : ℕ) (hm : 3 ≤ m) :
    canonicalShortCycleClass m (by omega) ≠ centeredPathClass r := by
  intro heq
  have hIso : RootedNeighborhood.isoSetoid.r
      ⟨Fin m, canonicalShortCycle m, ⟨0, by omega⟩⟩
      ⟨CenteredPathVertex r, centeredPath r, centeredPathRoot r⟩ := by
    apply Quotient.exact
    exact heq
  obtain ⟨e, _⟩ := hIso
  have hforward (x y : Fin m)
      (h : x.val + 1 = y.val ∨ (x.val + 1 = m ∧ y.val = 0)) :
      (canonicalShortCycle m).Adj x y := by
    change x ≠ y ∧
      (((x.val : ℤ) + 1 ≡ (y.val : ℤ) [ZMOD (m : ℤ)]) ∨
       ((y.val : ℤ) + 1 ≡ (x.val : ℤ) [ZMOD (m : ℤ)]))
    refine ⟨?_, Or.inl ?_⟩
    · intro hxy
      subst y
      rcases h with h | ⟨h1, h2⟩ <;> omega
    · apply Int.modEq_iff_dvd.mpr
      rcases h with h | ⟨h1, h2⟩
      · exact ⟨0, by omega⟩
      · exact ⟨-1, by omega⟩
  let p : CenteredPathVertex r :=
    ⟨-(r : ℤ), by constructor <;> omega⟩
  let x : Fin m := e.symm p
  have hx : e x = p := e.toEquiv.apply_symm_apply p
  let a : Fin m :=
    if h : x.val + 1 < m then ⟨x.val + 1, h⟩ else ⟨0, by omega⟩
  let b : Fin m :=
    if h : 0 < x.val then ⟨x.val - 1, by have := x.isLt; omega⟩
    else ⟨m - 1, by omega⟩
  have ha : x.val + 1 = a.val ∨ (x.val + 1 = m ∧ a.val = 0) := by
    by_cases h : x.val + 1 < m
    · left
      simp [a, h]
    · right
      constructor
      · have := x.isLt
        omega
      · simp [a, h]
  have hb : b.val + 1 = x.val ∨ (b.val + 1 = m ∧ x.val = 0) := by
    by_cases h : 0 < x.val
    · left
      simp only [b, dif_pos h]
      omega
    · right
      constructor
      · simp only [b, dif_neg h]
        omega
      · omega
  have hab : a ≠ b := by
    intro h
    have hv := congrArg Fin.val h
    rcases ha with ha | ⟨ha1, ha2⟩ <;>
      rcases hb with hb | ⟨hb1, hb2⟩ <;> omega
  have hap : (centeredPath r).Adj p (e a) := by
    rw [← hx]
    exact (e.map_rel_iff).2 (hforward x a ha)
  have hbp : (centeredPath r).Adj p (e b) := by
    rw [← hx]
    exact (e.map_rel_iff).2 ((canonicalShortCycle m).symm (hforward b x hb))
  change p.val + 1 = (e a).val ∨ (e a).val + 1 = p.val at hap
  change p.val + 1 = (e b).val ∨ (e b).val + 1 = p.val at hbp
  have hla := (e a).property.1
  have hlb := (e b).property.1
  change -(r : ℤ) ≤ (e a).val at hla
  change -(r : ℤ) ≤ (e b).val at hlb
  have hval : (e a).val = (e b).val := by
    dsimp only [p] at hap hbp
    rcases hap with hap | hap <;> rcases hbp with hbp | hbp <;> omega
  exact hab (e.injective (Subtype.ext hval))

#print axioms canonicalShortCycleClass_ne_centeredPathClass

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- The local observation determined by a component length. Short cycles
retain their length; long cycles share the centered-path class. -/
def cycleLengthNeighborhoodClass (r m : ℕ) (hm : 3 ≤ m) :
    RootedNeighborhoodClass :=
  if h : m ≤ 2 * r + 1 then
    canonicalShortCycleClass m (by omega)
  else centeredPathClass r

/-- Candidate: the actual observation deck factors through the component
length at each vertex, with no replacement of the graph observation model. -/
theorem cyclePartition_mixedObservation_eq_lengthMap
    (sizes : List ℕ) (r : ℕ)
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i) :
    rootedNeighborhoodObservation (cyclePartitionSimpleGraph sizes) r =
      (Finset.univ : Finset (CyclePartitionVertex sizes)).val.map
        (fun u => cycleLengthNeighborhoodClass r (sizes.get u.1) (h3 u.1)) := by
  unfold rootedNeighborhoodObservation
  apply congrArg (fun f : CyclePartitionVertex sizes → RootedNeighborhoodClass =>
    (Finset.univ : Finset (CyclePartitionVertex sizes)).val.map f)
  funext u
  unfold cycleLengthNeighborhoodClass
  by_cases hs : sizes.get u.1 ≤ 2 * r + 1
  · simp only [dif_pos hs]
    obtain ⟨e, he⟩ := cyclePartition_shortBall_rootedIso h3 r u hs
    symm
    exact Quotient.sound ⟨e, he⟩
  · simp only [dif_neg hs]
    have hl : 2 * r + 2 ≤ sizes.get u.1 := by omega
    symm
    exact Quotient.sound ⟨cyclePartition_rootedBallIso h3 r u hl,
      cyclePartition_rootedBallIso_root h3 r u hl⟩

#print axioms cyclePartition_mixedObservation_eq_lengthMap

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- Candidate: each cycle contributes its length times the weight of its
actual rooted-neighborhood class. Arbitrary weights allow both multiplicity
recovery and observation-dependent estimators. -/
theorem cyclePartition_mixedObservation_weightSum
    (sizes : List ℕ) (r : ℕ)
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
    (w : RootedNeighborhoodClass → ℝ) :
    ((rootedNeighborhoodObservation (cyclePartitionSimpleGraph sizes) r).map w).sum =
      ∑ i : Fin sizes.length,
        (sizes.get i : ℝ) * w (cycleLengthNeighborhoodClass r (sizes.get i) (h3 i)) := by
  classical
  rw [cyclePartition_mixedObservation_eq_lengthMap sizes r h3, Multiset.map_map]
  change (∑ u : CyclePartitionVertex sizes,
      w (cycleLengthNeighborhoodClass r (sizes.get u.1) (h3 u.1))) = _
  have hu :
      (Finset.univ : Finset (CyclePartitionVertex sizes)) =
        (Finset.univ : Finset (Fin sizes.length)).sigma
          (fun i => (Finset.univ : Finset (Fin (sizes.get i)))) := by
    ext u
    simp
  rw [hu, Finset.sum_sigma]
  apply Finset.sum_congr rfl
  intro i _
  change (∑ _x : Fin (sizes.get i),
    w (cycleLengthNeighborhoodClass r (sizes.get i) (h3 i))) = _
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]

#print axioms cyclePartition_mixedObservation_weightSum

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- Vertex cardinality is an invariant of the actual rooted neighborhood class. -/
noncomputable def rootedNeighborhoodCarrierCard : RootedNeighborhoodClass → ℕ :=
  Quotient.lift (fun b : RootedNeighborhood => Nat.card b.carrier) (by
    intro a b h
    obtain ⟨e, _⟩ := h
    exact Nat.card_congr e.toEquiv)

/-- Weight each short-cycle vertex by the reciprocal of its component size. -/
noncomputable def mixedCycleShortWeight (r : ℕ)
    (c : RootedNeighborhoodClass) : ℝ := by
  classical
  exact if c = centeredPathClass r then 0 else
    1 / (rootedNeighborhoodCarrierCard c : ℝ)

/-- Indicator of a long-cycle observation. -/
noncomputable def mixedCycleLongWeight (r : ℕ)
    (c : RootedNeighborhoodClass) : ℝ := by
  classical
  exact if c = centeredPathClass r then 1 else 0

/-- Candidate: the two statistics needed by the mixed-cycle minimax
estimator are determined by the actual observation multiset. -/
theorem cyclePartition_mixedObservation_recoverStatistics
    (sizes : List ℕ) (r : ℕ)
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i) :
    let D := rootedNeighborhoodObservation (cyclePartitionSimpleGraph sizes) r
    ((D.map (mixedCycleShortWeight r)).sum =
      ∑ i : Fin sizes.length, (if sizes.get i ≤ 2 * r + 1 then (1 : ℝ) else 0)) ∧
    ((D.map (mixedCycleLongWeight r)).sum =
      ∑ i : Fin sizes.length,
        (if sizes.get i ≤ 2 * r + 1 then (0 : ℝ) else (sizes.get i : ℝ))) := by
  classical
  dsimp only
  constructor
  · rw [cyclePartition_mixedObservation_weightSum sizes r h3]
    apply Finset.sum_congr rfl
    intro i _
    by_cases hs : sizes.get i ≤ 2 * r + 1
    · have hp : 0 < sizes.get i := by have := h3 i; omega
      have hc : rootedNeighborhoodCarrierCard
          (canonicalShortCycleClass (sizes.get i) hp) = sizes.get i := by
        change Nat.card (Fin (sizes.get i)) = sizes.get i
        rw [Nat.card_eq_fintype_card, Fintype.card_fin]
      have hn : canonicalShortCycleClass (sizes.get i) hp ≠ centeredPathClass r :=
        canonicalShortCycleClass_ne_centeredPathClass (sizes.get i) r (h3 i)
      simp only [cycleLengthNeighborhoodClass, dif_pos hs, if_pos hs,
        mixedCycleShortWeight, if_neg hn, hc]
      have hm : (sizes.get i : ℝ) ≠ 0 := by exact_mod_cast hp.ne'
      field_simp
    · simp only [cycleLengthNeighborhoodClass, dif_neg hs, if_neg hs,
        mixedCycleShortWeight]
      simp
  · rw [cyclePartition_mixedObservation_weightSum sizes r h3]
    apply Finset.sum_congr rfl
    intro i _
    by_cases hs : sizes.get i ≤ 2 * r + 1
    · have hn := canonicalShortCycleClass_ne_centeredPathClass (sizes.get i) r (h3 i)
      simp only [cycleLengthNeighborhoodClass, dif_pos hs, if_pos hs,
        mixedCycleLongWeight, if_neg hn, mul_zero]
    · simp only [cycleLengthNeighborhoodClass, dif_neg hs, if_neg hs,
        mixedCycleLongWeight]
      simp

#print axioms cyclePartition_mixedObservation_recoverStatistics

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- Candidate: the hidden component count minus the observed short-component
count is zero when no long vertices are observed, and otherwise lies in the
sharp global interval from one to the long-cycle packing bound. -/
theorem cyclePartition_mixedCount_bounds
    (sizes : List ℕ) (N L r : ℕ) (hL : 3 ≤ L)
    (hsum : sizes.sum = N)
    (hmin : ∀ i : Fin sizes.length, L ≤ sizes.get i) :
    let D := rootedNeighborhoodObservation (cyclePartitionSimpleGraph sizes) r
    let S := (D.map (mixedCycleShortWeight r)).sum
    let M := (D.map (mixedCycleLongWeight r)).sum
    let k := (sizes.length : ℝ) - S
    (M = 0 → k = 0) ∧
    (M ≠ 0 → 1 ≤ k ∧ k ≤ ((N / max L (2 * r + 2) : ℕ) : ℝ)) := by
  classical
  dsimp only
  let A := max L (2 * r + 2)
  let c (i : Fin sizes.length) : ℕ := if sizes.get i ≤ 2 * r + 1 then 0 else 1
  let t (i : Fin sizes.length) : ℕ :=
    if sizes.get i ≤ 2 * r + 1 then 0 else sizes.get i
  let C := ∑ i, c i
  let T := ∑ i, t i
  have h3 (i : Fin sizes.length) : 3 ≤ sizes.get i := hL.trans (hmin i)
  obtain ⟨hs, hm⟩ := cyclePartition_mixedObservation_recoverStatistics sizes r h3
  have hC : (C : ℝ) = ∑ i : Fin sizes.length,
      (if sizes.get i ≤ 2 * r + 1 then (0 : ℝ) else 1) := by
    unfold C
    rw [Nat.cast_sum]
    apply Finset.sum_congr rfl
    intro i _
    by_cases h : sizes.get i ≤ 2 * r + 1
    · simp only [c, if_pos h, Nat.cast_zero]
    · simp only [c, if_neg h, Nat.cast_one]
  have hT : (T : ℝ) = ∑ i : Fin sizes.length,
      (if sizes.get i ≤ 2 * r + 1 then (0 : ℝ) else (sizes.get i : ℝ)) := by
    unfold T
    rw [Nat.cast_sum]
    apply Finset.sum_congr rfl
    intro i _
    by_cases h : sizes.get i ≤ 2 * r + 1
    · simp only [t, if_pos h, Nat.cast_zero]
    · simp only [t, if_neg h]
  rw [hs, hm, ← hT]
  have hcount : (∑ i : Fin sizes.length,
        (if sizes.get i ≤ 2 * r + 1 then (1 : ℝ) else 0)) + (C : ℝ) =
      (sizes.length : ℝ) := by
    rw [hC, ← Finset.sum_add_distrib]
    calc
      _ = ∑ _i : Fin sizes.length, (1 : ℝ) := by
        apply Finset.sum_congr rfl
        intro i _
        by_cases h : sizes.get i ≤ 2 * r + 1
        · simp only [if_pos h, add_zero]
        · simp only [if_neg h, zero_add]
      _ = _ := by rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin,
          nsmul_eq_mul, mul_one]
  have hk : (sizes.length : ℝ) -
      (∑ i : Fin sizes.length, (if sizes.get i ≤ 2 * r + 1 then (1 : ℝ) else 0)) =
      (C : ℝ) := by linarith
  rw [hk]
  have hmul : A * C ≤ T := by
    unfold C T
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro i _
    by_cases h : sizes.get i ≤ 2 * r + 1
    · simp only [c, t, if_pos h, mul_zero, le_refl]
    · simp only [c, t, if_neg h, mul_one]
      exact max_le (hmin i) (by omega)
  have hTN : T ≤ N := by
    calc
      T ≤ ∑ i : Fin sizes.length, sizes.get i := by
        unfold T
        apply Finset.sum_le_sum
        intro i _
        by_cases h : sizes.get i ≤ 2 * r + 1
        · simp only [t, if_pos h, Nat.zero_le]
        · simp only [t, if_neg h, le_refl]
      _ = N := by rw [← List.sum_ofFn, List.ofFn_get, hsum]
  have hA : 0 < A := by
    exact lt_of_lt_of_le (by omega : 0 < L) (le_max_left _ _)
  have hCT : C ≤ T := by
    calc
      C = 1 * C := by rw [one_mul]
      _ ≤ A * C := Nat.mul_le_mul_right C (by omega)
      _ ≤ T := hmul
  constructor
  · intro hzero
    have ht : T = 0 := by exact_mod_cast hzero
    have hc : C = 0 := by omega
    exact_mod_cast hc
  · intro hn
    have hc : C ≠ 0 := by
      intro hc
      have hall := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i (_ : i ∈ (Finset.univ : Finset (Fin sizes.length))) =>
          Nat.zero_le (c i))).mp hc
      have ht : T = 0 := by
        unfold T
        apply Finset.sum_eq_zero
        intro i hi
        have hz := hall i hi
        by_cases h : sizes.get i ≤ 2 * r + 1
        · simp only [t, if_pos h]
        · simp only [c, if_neg h] at hz
          omega
      exact hn (by exact_mod_cast ht)
    have hb : C ≤ N / A := (Nat.le_div_iff_mul_le hA).2
      (by rw [Nat.mul_comm]; exact hmul.trans hTN)
    constructor
    · exact_mod_cast (show 1 ≤ C by omega)
    · exact_mod_cast hb

#print axioms cyclePartition_mixedCount_bounds

end URF.EntropyBridge


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

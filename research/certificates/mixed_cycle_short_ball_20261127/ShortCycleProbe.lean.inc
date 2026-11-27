
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

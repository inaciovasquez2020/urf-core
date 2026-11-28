
namespace URF.EntropyBridge

/-- Candidate for the established generalized global minimax value on the
same admissible cycle families, entropy, and actual rooted observation deck.
The short-component count is exactly observable; long components are bounded
by their minimum admissible length. The all-long subclass supplies sharpness. -/
theorem cyclePartition_mixed_radius_minimax_value
    (K : Type*) [Field K] [Fintype K] (N L r : ℕ)
    (hNL : L ≤ N) (hL : 3 ≤ L) :
    IsLeast {E : ℝ | ∃ estimate : Multiset RootedNeighborhoodClass → ℝ,
      ∀ g : AdmissibleCycleFamily N L,
        |estimate (admissibleCycleObservation r g) - admissibleCycleEntropy K g| ≤ E}
      (((((N / max L (2 * r + 2) - 1 : ℕ) : ℝ) *
        Real.log (Fintype.card K)) / 2)) := by
  classical
  let A : ℕ := max L (2 * r + 2)
  let B : ℕ := N / A
  let w : ℝ := Real.log (Fintype.card K)
  change IsLeast {E : ℝ | ∃ estimate : Multiset RootedNeighborhoodClass → ℝ,
      ∀ g : AdmissibleCycleFamily N L,
        |estimate (admissibleCycleObservation r g) - admissibleCycleEntropy K g| ≤ E}
    (((B - 1 : ℕ) : ℝ) * w / 2)
  have hp : 0 < L := by omega
  have hAp : 0 < A := lt_of_lt_of_le hp (le_max_left L (2 * r + 2))
  have hAL : L ≤ A := le_max_left L (2 * r + 2)
  have hA3 : 3 ≤ A := hL.trans hAL
  have hw : 0 ≤ w :=
    Real.log_nonneg (by exact_mod_cast Fintype.card_pos (α := K))
  constructor
  · refine ⟨fun D =>
      ((D.map (mixedCycleShortWeight r)).sum +
        (if (D.map (mixedCycleLongWeight r)).sum = 0 then 0
          else (1 + (B : ℝ)) / 2)) * w, ?_⟩
    intro g
    have hmin (i : Fin g.sizes.length) : L ≤ g.sizes.get i :=
      g.minLength _ (List.get_mem _ _)
    have hb := cyclePartition_mixedCount_bounds g.sizes N L r hL g.total hmin
    let D := admissibleCycleObservation r g
    let S := (D.map (mixedCycleShortWeight r)).sum
    let M := (D.map (mixedCycleLongWeight r)).sum
    change (M = 0 → (g.sizes.length : ℝ) - S = 0) ∧
      (M ≠ 0 → 1 ≤ (g.sizes.length : ℝ) - S ∧
        (g.sizes.length : ℝ) - S ≤ (B : ℝ)) at hb
    rw [admissibleCycleEntropy_eq K hL,
      admissibleGraphComponentCount_eq_length hp]
    change |(S + (if M = 0 then 0 else (1 + (B : ℝ)) / 2)) * w -
      (g.sizes.length : ℝ) * w| ≤ (((B - 1 : ℕ) : ℝ) * w / 2)
    by_cases hz : M = 0
    · have hk : (g.sizes.length : ℝ) = S := sub_eq_zero.mp (hb.1 hz)
      rw [if_pos hz, add_zero, hk, sub_self, abs_zero]
      exact div_nonneg (mul_nonneg (Nat.cast_nonneg _) hw) (by norm_num)
    · obtain ⟨hl, hu⟩ := hb.2 hz
      have hB : 1 ≤ B := by exact_mod_cast (hl.trans hu)
      have hcast : ((B - 1 : ℕ) : ℝ) = (B : ℝ) - 1 := by
        rw [Nat.cast_sub hB, Nat.cast_one]
      have habs :
          |S + (1 + (B : ℝ)) / 2 - (g.sizes.length : ℝ)| ≤
            ((B : ℝ) - 1) / 2 := by
        apply abs_le.mpr
        constructor <;> linarith
      rw [if_neg hz, hcast, ← sub_mul, abs_mul, abs_of_nonneg hw]
      calc
        _ ≤ (((B : ℝ) - 1) / 2) * w :=
          mul_le_mul_of_nonneg_right habs hw
        _ = _ := by ring
  · rintro E ⟨estimate, hestimate⟩
    by_cases hAN : A ≤ N
    · have hAr : max 3 (2 * r + 2) ≤ A :=
        max_le hA3 (le_max_right L (2 * r + 2))
      obtain ⟨g, hg⟩ :=
        (cyclePartition_radius_minimax K N A r hAN hAr).1 estimate
      let g' : AdmissibleCycleFamily N L :=
        ⟨g.sizes, g.total, fun t ht => hAL.trans (g.minLength t ht)⟩
      have hObs : admissibleCycleObservation r g' =
          admissibleCycleObservation r g := rfl
      have hEntropy : admissibleCycleEntropy K g' =
          admissibleCycleEntropy K g := by
        rw [admissibleCycleEntropy_eq K hL g',
          admissibleCycleEntropy_eq K hA3 g,
          admissibleGraphComponentCount_eq_length hp g',
          admissibleGraphComponentCount_eq_length hAp g]
      have hB : 1 ≤ B := Nat.div_pos hAN hAp
      have hcast : ((B - 1 : ℕ) : ℝ) = (B : ℝ) - 1 := by
        rw [Nat.cast_sub hB, Nat.cast_one]
      rw [hcast]
      exact hg.trans (by simpa only [hObs, hEntropy] using hestimate g')
    · have hB : B = 0 := Nat.div_eq_of_lt (lt_of_not_ge hAN)
      let g : AdmissibleCycleFamily N L :=
        ⟨[N], by simp, by
          intro t ht
          simp only [List.mem_singleton] at ht
          subst t
          exact hNL⟩
      have hzero : 0 ≤ E := (abs_nonneg _).trans (hestimate g)
      simpa [hB] using hzero

#print axioms cyclePartition_mixed_radius_minimax_value

end URF.EntropyBridge

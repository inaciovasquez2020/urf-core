import Mathlib

open scoped BigOperators

theorem finite_local_nonnegative_component_bound
    {T : ℕ}
    [NeZero T]
    (localCMI : Fin T → ℝ)
    (totalMI C : ℝ)
    (h_nonneg : ∀ t : Fin T, 0 ≤ localCMI t)
    (h_total : totalMI = Finset.univ.sum localCMI)
    (h_bound : totalMI ≤ C)
    (t : Fin T) :
    localCMI t ≤ C := by
  have h_mem : t ∈ (Finset.univ : Finset (Fin T)) := Finset.mem_univ t
  have h_sum_split :
      Finset.univ.sum localCMI =
        localCMI t + ((Finset.univ : Finset (Fin T)).erase t).sum localCMI := by
    simpa using
      (Finset.sum_eq_add_sum_diff_singleton
        (ι := Fin T)
        (M := ℝ)
        (i := t)
        (h := h_mem)
        (s := (Finset.univ : Finset (Fin T)))
        (f := localCMI))
  have h_tail_nonneg :
      0 ≤ ((Finset.univ : Finset (Fin T)).erase t).sum localCMI := by
    exact Finset.sum_nonneg (fun x _ => h_nonneg x)
  have h_le_sum : localCMI t ≤ Finset.univ.sum localCMI := by
    rw [h_sum_split]
    exact le_add_of_nonneg_right h_tail_nonneg
  have h_sum_le_C : Finset.univ.sum localCMI ≤ C := by
    rw [← h_total]
    exact h_bound
  exact le_trans h_le_sum h_sum_le_C

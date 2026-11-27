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
  have h_le_sum : localCMI t ≤ Finset.univ.sum localCMI := by
    exact Finset.single_le_sum (fun x _ => h_nonneg x) h_mem
  have h_sum_le_C : Finset.univ.sum localCMI ≤ C := by
    rw [← h_total]
    exact h_bound
  exact le_trans h_le_sum h_sum_le_C

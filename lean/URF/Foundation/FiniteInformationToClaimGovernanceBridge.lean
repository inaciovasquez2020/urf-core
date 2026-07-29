import Mathlib

open scoped BigOperators

theorem finite_local_nonnegative_component_bound_bridge_source
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
    rw [Finset.sum_eq_add_sum_diff_singleton
      (ι := Fin T)
      (M := ℝ)
      (i := t)
      (h := by
      intro h_not_mem
      exact (h_not_mem h_mem).elim)
      (s := (Finset.univ : Finset (Fin T)))
      (f := localCMI)]
    simp
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

structure FiniteClaimGovernancePackage (T : ℕ) [NeZero T] where
  localStrength : Fin T → ℝ
  totalStrength : ℝ
  capacityBound : ℝ
  local_nonnegative : ∀ t : Fin T, 0 ≤ localStrength t
  total_eq_sum : totalStrength = Finset.univ.sum localStrength
  total_le_capacity : totalStrength ≤ capacityBound

theorem finite_information_to_claim_governance_bridge
    {T : ℕ}
    [NeZero T]
    (P : FiniteClaimGovernancePackage T)
    (t : Fin T) :
    P.localStrength t ≤ P.capacityBound := by
  exact finite_local_nonnegative_component_bound_bridge_source
    P.localStrength
    P.totalStrength
    P.capacityBound
    P.local_nonnegative
    P.total_eq_sum
    P.total_le_capacity
    t

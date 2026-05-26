import Mathlib

/-
URF-core local URF Law 3 complete instance package.

This file combines the three local instance-level components:

  local CMI nonnegativity
  local chain rule
  local capacity

into one local theorem package.

It does not replace the global `cmi_nonneg`, `chain_rule`, or `capacity`
primitives in `urf_law3.lean`.
-/

structure LocalURFLaw3CompleteInstancePackage (T : ℕ) where
  localCMI : ℕ → ℝ
  localMI : ℝ
  localCMI_nonneg : ∀ t, 0 ≤ localCMI t
  local_chain_rule : localMI = Finset.sum (Finset.range T) (fun t => localCMI t)
  local_capacity : localMI ≤ 1

theorem local_urf_law3_complete_instance_package
    {T t : ℕ}
    (K : LocalURFLaw3CompleteInstancePackage T)
    (ht : t < T) :
    K.localCMI t ≤ 1 := by
  have hmem : t ∈ Finset.range T := by
    exact Finset.mem_range.mpr ht
  have hterm_le_sum :
      K.localCMI t ≤ Finset.sum (Finset.range T) (fun u => K.localCMI u) := by
    exact Finset.single_le_sum (fun u _hu => K.localCMI_nonneg u) hmem
  have hsum_le_one :
      Finset.sum (Finset.range T) (fun u => K.localCMI u) ≤ 1 := by
    rw [← K.local_chain_rule]
    exact K.local_capacity
  exact le_trans hterm_le_sum hsum_le_one

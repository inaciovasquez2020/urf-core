import Mathlib

open scoped BigOperators

-- Unified Rigidity Framework — Law 3
-- Entropy Non-Amplification from Capacity

constant State : Type
constant Obs : Type
constant X : State
constant Y : ℕ → Obs

-- Mutual information
constant MI : State → (ℕ → Obs) → ℝ
constant CMI : State → Obs → (ℕ → Obs) → ℝ

-- URF 0.2: Capacity
axiom capacity : ∀ T : ℕ, MI X Y ≤ 1

-- Chain rule for mutual information
axiom chain_rule : ∀ T : ℕ,
  MI X Y = ∑ t in Finset.range T, CMI X (Y t) Y

-- Non-negativity
axiom cmi_nonneg : ∀ t, 0 ≤ CMI X (Y t) Y

-- URF 0.3: Entropy ceiling
theorem urf_law3 : ∀ T t, t < T → CMI X (Y t) Y ≤ 1 := by
  intro T t ht
  have hmem : t ∈ Finset.range T := by
    exact Finset.mem_range.mpr ht
  have hterm_le_sum :
      CMI X (Y t) Y ≤ ∑ u in Finset.range T, CMI X (Y u) Y := by
    exact Finset.single_le_sum (fun u _ => cmi_nonneg u) hmem
  have hsum_le_one :
      (∑ u in Finset.range T, CMI X (Y u) Y) ≤ 1 := by
    rw [← chain_rule T]
    exact capacity T
  exact le_trans hterm_le_sum hsum_le_one

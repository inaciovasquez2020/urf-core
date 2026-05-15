import Mathlib

/- Unified Rigidity Framework — Law 3
   Entropy Non-Amplification from Capacity
-/

noncomputable section

open scoped BigOperators

axiom State : Type
axiom Obs : Type

axiom X : State
axiom Y : ℕ → Obs

/-- Mutual information. -/
axiom MI : State → (ℕ → Obs) → ℝ

/-- Conditional mutual information. -/
axiom CMI : State → Obs → (ℕ → Obs) → ℝ

/-- URF 0.2: Capacity. -/
axiom capacity : ∀ T : ℕ, MI X Y ≤ 1

/-- Chain rule for mutual information. -/
axiom chain_rule :
  ∀ T : ℕ, MI X Y = ∑ t ∈ Finset.range T, CMI X (Y t) Y

/-- Non-negativity. -/
axiom cmi_nonneg : ∀ t : ℕ, 0 ≤ CMI X (Y t) Y

/-- URF 0.3: Entropy ceiling. -/
theorem urf_law3 :
  ∀ T t : ℕ, t < T → CMI X (Y t) Y ≤ 1 := by
  intro T t ht
  have hmem : t ∈ Finset.range T := Finset.mem_range.mpr ht
  have hle_sum :
      CMI X (Y t) Y ≤ ∑ i ∈ Finset.range T, CMI X (Y i) Y := by
    exact Finset.single_le_sum (fun i _ => cmi_nonneg i) hmem
  calc
    CMI X (Y t) Y ≤ ∑ i ∈ Finset.range T, CMI X (Y i) Y := hle_sum
    _ = MI X Y := by simpa using (chain_rule T).symm
    _ ≤ 1 := capacity T

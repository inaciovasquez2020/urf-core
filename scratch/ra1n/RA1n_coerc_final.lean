import Mathlib
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Int.Basic
import Mathlib.Tactic

open scoped BigOperators

noncomputable section

def winIdx (C₀ : ℕ) : Finset ℕ := Finset.range (2 * C₀ + 1)

def shell (k : ℤ) (C₀ i : ℕ) : ℤ := k + (i : ℤ) - (C₀ : ℤ)

variable {C₀ : ℕ} {A β C C' : ℝ} {θ : ℝ}
variable (E : ℤ → ℝ)

def SpectralRigidity (k : ℤ) : Prop :=
  ∀ i : ℕ, i ∈ winIdx C₀ →
    E (shell k C₀ i) ≤ A * (E k) ^ (1 / 2 + θ)

def TrilinearBaseBound (k m n : ℤ) (IntegralVal : ℝ) : Prop :=
  IntegralVal ≤
    C * (2 : ℝ) ^ (β * (k : ℝ)) *
      (E k) ^ (1 / 2) * (E m) ^ (1 / 2) * (E n) ^ (1 / 2)

lemma sqrt_rigidity_of_rigidity
    (k : ℤ)
    (hEk_nonneg : 0 ≤ E k)
    (hA_nonneg : 0 ≤ A)
    (hθ : 0 ≤ θ)
    (h_rig : SpectralRigidity (E := E) (C₀ := C₀) (A := A) (θ := θ) k) :
    ∀ i : ℕ, i ∈ winIdx C₀ →
      (E (shell k C₀ i)) ^ (1 / 2) ≤
        A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2) := by
  intro i hi
  have h := h_rig i hi
  have hEk_nonneg' : 0 ≤ (E k) ^ (1 / 2 + θ) := by positivity
  have hA_nonneg' : 0 ≤ A * (E k) ^ (1 / 2 + θ) := by positivity
  have h_sqrt := Real.sqrt_le_sqrt h
  have : (E (shell k C₀ i)) ^ (1 / 2)
        ≤ (A * (E k) ^ (1 / 2 + θ)) ^ (1 / 2) := by
    simpa [Real.sqrt_eq_rpow] using h_sqrt
  have hsplit :
      (A * (E k) ^ (1 / 2 + θ)) ^ (1 / 2)
      = A ^ (1 / 2) * (E k) ^ ((1 / 2 + θ) / 2) := by
    have hA' : 0 ≤ A := hA_nonneg
    have hE' : 0 ≤ (E k) ^ (1 / 2 + θ) := by positivity
    simpa using Real.mul_rpow hA' hE' (by norm_num : (1 / 2 : ℝ) ≠ 0)
  have hexp :
      (E k) ^ ((1 / 2 + θ) / 2)
      = (E k) ^ (1 / 4 + θ / 2) := by
    congr 1
    ring
  simpa [hsplit, hexp] using this

theorem RA1n_coerc_final
    (k : ℤ)
    (hEk_nonneg : 0 ≤ E k)
    (hA_nonneg : 0 ≤ A)
    (hθ : 0 ≤ θ)
    (h_rig : SpectralRigidity (E := E) (C₀ := C₀) (A := A) (θ := θ) k)
    (Interaction : ℤ → ℤ → ℝ)
    (h_int :
      ∀ i j : ℕ,
        i ∈ winIdx C₀ → j ∈ winIdx C₀ →
        TrilinearBaseBound E β (shell k C₀ i) (shell k C₀ j)
          (Interaction (shell k C₀ i) (shell k C₀ j))) :
    (∑ i in winIdx C₀,
     ∑ j in winIdx C₀,
       Interaction (shell k C₀ i) (shell k C₀ j))
    ≤ C' * (2 : ℝ) ^ (β * (k : ℝ)) * (E k) ^ (1 + θ) := by
  classical
  have h_card :
      (winIdx C₀).card = (2 * C₀ + 1) := by
    simp [winIdx]
  have h_card_sq :
      ((winIdx C₀).card : ℝ)^2 = ((2 * C₀ + 1 : ℝ)^2) := by
    simp [h_card]
  have h_bound :
      ∀ i j, i ∈ winIdx C₀ → j ∈ winIdx C₀ →
        Interaction (shell k C₀ i) (shell k C₀ j)
        ≤ C * (2 : ℝ) ^ (β * (k : ℝ)) *
            (E k) ^ (1 / 2) *
            (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) *
            (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) := by
    intro i j hi hj
    have hbase := h_int i j hi hj
    have hm :=
      sqrt_rigidity_of_rigidity (E := E) (C₀ := C₀) (A := A) (θ := θ)
        k hEk_nonneg hA_nonneg hθ h_rig i hi
    have hn :=
      sqrt_rigidity_of_rigidity (E := E) (C₀ := C₀) (A := A) (θ := θ)
        k hEk_nonneg hA_nonneg hθ h_rig j hj
    have := hbase
    have : Interaction (shell k C₀ i) (shell k C₀ j)
      ≤ C * (2 : ℝ) ^ (β * (k : ℝ)) *
          (E k) ^ (1 / 2) *
          (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) *
          (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) := by
      have := hbase
      have hm' := hm
      have hn' := hn
      have : (E (shell k C₀ i)) ^ (1 / 2)
            ≤ A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2) := hm'
      have : (E (shell k C₀ j)) ^ (1 / 2)
            ≤ A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2) := hn'
      nlinarith
    exact this
  have hsum :
      (∑ i in winIdx C₀,
       ∑ j in winIdx C₀,
         Interaction (shell k C₀ i) (shell k C₀ j))
      ≤
      ((winIdx C₀).card : ℝ)^2 *
      (C * (2 : ℝ) ^ (β * (k : ℝ)) *
        (E k) ^ (1 / 2) *
        (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) *
        (A ^ (1 / 2) * (E k) ^ (1 / 4 + θ / 2)) ) := by
    apply Finset.sum_le_card_nsmul
    intro i hi
    apply Finset.sum_le_card_nsmul
    intro j hj
    exact h_bound i j hi hj
  have hexp :
      (E k) ^ (1 / 2) *
      (E k) ^ (1 / 4 + θ / 2) *
      (E k) ^ (1 / 4 + θ / 2)
      = (E k) ^ (1 + θ) := by
    ring_nf
  have hA :
      A ^ (1 / 2) * A ^ (1 / 2) = A := by
    ring_nf
  have :
      (∑ i in winIdx C₀,
       ∑ j in winIdx C₀,
         Interaction (shell k C₀ i) (shell k C₀ j))
      ≤
      ((2 * C₀ + 1 : ℝ)^2) *
      C * (2 : ℝ) ^ (β * (k : ℝ)) *
      A * (E k) ^ (1 + θ) := by
    simpa [h_card_sq, hexp, hA] using hsum
  have : (∑ i in winIdx C₀,
          ∑ j in winIdx C₀,
            Interaction (shell k C₀ i) (shell k C₀ j))
      ≤ C' * (2 : ℝ) ^ (β * (k : ℝ)) * (E k) ^ (1 + θ) := by
    exact mul_le_mul_of_nonneg_right
      (by exact this)
      (by positivity)
  exact this


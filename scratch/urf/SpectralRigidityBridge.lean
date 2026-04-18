import Mathlib

namespace URF

open scoped BigOperators

structure EnergyProfile where
  E : ℕ → ℝ

def SpectralRigidity
    (u : EnergyProfile) (C0 : ℕ) (A θ : ℝ) : Prop :=
  ∀ j k : ℕ, Nat.dist j k ≤ C0 → 0 ≤ u.E k →
    u.E j ≤ A * (u.E k) ^ ((1 : ℝ) / 2 + θ)

noncomputable def LocalEnvelope
    (u : EnergyProfile) (C0 k : ℕ) : ℝ :=
  sSup {x : ℝ | ∃ j : ℕ, Nat.dist j k ≤ C0 ∧ x = u.E j}

def EnvelopeRigidity
    (u : EnergyProfile) (C0 : ℕ) (A θ : ℝ) : Prop :=
  ∀ k : ℕ, 0 ≤ u.E k →
    LocalEnvelope u C0 k ≤ A * (u.E k) ^ ((1 : ℝ) / 2 + θ)

def NonnegEnergy (u : EnergyProfile) : Prop :=
  ∀ k : ℕ, 0 ≤ u.E k

lemma spectralRigidity_of_envelopeRigidity
    (u : EnergyProfile) (C0 : ℕ) (A θ : ℝ)
    (h_env : EnvelopeRigidity u C0 A θ)
    (h_sup :
      ∀ j k : ℕ, Nat.dist j k ≤ C0 → u.E j ≤ LocalEnvelope u C0 k) :
    SpectralRigidity u C0 A θ := by
  intro j k hjk hk
  have hle : u.E j ≤ LocalEnvelope u C0 k := h_sup j k hjk
  have hmain : LocalEnvelope u C0 k ≤ A * (u.E k) ^ ((1 : ℝ) / 2 + θ) := h_env k hk
  exact le_trans hle hmain

def FlowPreservesEnvelope
    (U : ℝ → EnergyProfile) (C0 : ℕ) (A θ : ℝ) : Prop :=
  ∀ t : ℝ, 0 ≤ t → EnvelopeRigidity (U t) C0 A θ

def FlowPreservesNonneg
    (U : ℝ → EnergyProfile) : Prop :=
  ∀ t : ℝ, 0 ≤ t → NonnegEnergy (U t)

theorem rigidity_persistence_via_envelope
    (U : ℝ → EnergyProfile) (C0 : ℕ) (A θ : ℝ)
    (h_env : FlowPreservesEnvelope U C0 A θ)
    (h_sup :
      ∀ t : ℝ, 0 ≤ t →
        ∀ j k : ℕ, Nat.dist j k ≤ C0 → (U t).E j ≤ LocalEnvelope (U t) C0 k) :
    ∀ t : ℝ, 0 ≤ t → SpectralRigidity (U t) C0 A θ := by
  intro t ht
  apply spectralRigidity_of_envelopeRigidity (u := U t) (C0 := C0) (A := A) (θ := θ)
  · exact h_env t ht
  · exact h_sup t ht

def NoShellSkipping
    (u : EnergyProfile) (C0 : ℕ) : Prop :=
  ∀ j k : ℕ, Nat.dist j k ≤ C0 →
    0 < u.E j → ∃ m : ℕ, Nat.dist m k ≤ C0 ∧ 0 < u.E m

def EnvelopeDifferentialInequality
    (U : ℝ → EnergyProfile) (T A θ : ℝ) (C0 : ℕ) : Prop :=
  ∀ t : ℝ, 0 ≤ t → t ≤ T →
    ∀ k : ℕ, 0 ≤ (U t).E k →
      LocalEnvelope (U t) C0 k ≤ A * ((U t).E k) ^ ((1 : ℝ) / 2 + θ)

theorem spectral_rigidity_closure
    (u : EnergyProfile) (C0 : ℕ) (A θ : ℝ)
    (h_env : EnvelopeRigidity u C0 A θ)
    (h_sup :
      ∀ j k : ℕ, Nat.dist j k ≤ C0 → u.E j ≤ LocalEnvelope u C0 k) :
    SpectralRigidity u C0 A θ := by
  exact spectralRigidity_of_envelopeRigidity u C0 A θ h_env h_sup

end URF

import Mathlib

namespace URF

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

def EnvelopeWitnessInclusion
    (u : EnergyProfile) (C0 : ℕ) : Prop :=
  ∀ j k : ℕ, Nat.dist j k ≤ C0 → u.E j ≤ LocalEnvelope u C0 k

theorem spectralRigidity_of_witness_package
    (u : EnergyProfile) (C0 : ℕ) (A θ : ℝ)
    (h_env : EnvelopeRigidity u C0 A θ)
    (h_witness : EnvelopeWitnessInclusion u C0) :
    SpectralRigidity u C0 A θ := by
  apply spectralRigidity_of_envelopeRigidity (u := u) (C0 := C0) (A := A) (θ := θ)
  · exact h_env
  · exact h_witness

end URF

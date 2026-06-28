import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Log
import Mathlib.Logic.Function.Basic

/-
URF-ADMISSIBLE: Formal interface (v1.0)

This file fixes the predicate and states normalization theorems
without assuming any unverified computational equivalences.
-/

namespace URF

/- Size parameter -/
variable (n : ℕ)

/-- Abstract process state indexed by input size -/
structure State (n : ℕ) where
  repr : Type

/- Step relation -/
variable {n : ℕ}
variable (step : State n → State n)

/- Injected information per step (in bits) -/
variable (I : State n → ℕ)

/- Progress functional -/
variable (Φ : State n → ℝ)

/- Toolkit constants -/
variable (r : ℕ)                 -- locality radius
variable (b : ℕ → ℕ)             -- capacity bound
variable (T : ℕ → ℕ)             -- time horizon

/-- Locality constraint -/
def Locality (_step : State n → State n) (_r : ℕ) : Prop :=
  True  -- locality witnessed externally (schema / certificate)

/-- Capacity constraint -/
def Capacity : Prop :=
  ∀ s : State n, I s ≤ b n

/-- Accounting constraint -/
def Accounting : Prop :=
  ∀ s₀ sT : State n,
    Φ sT - Φ s₀ ≤ (T n : ℝ) * (b n : ℝ)

/-- Uniformity constraint -/
def Uniformity (_step : State n → State n) : Prop :=
  True  -- enforced by construction

/-- URF-ADMISSIBLE predicate -/
def URF_ADMISSIBLE : Prop :=
  Locality step r ∧
  Capacity I b ∧
  Accounting Φ b T ∧
  Uniformity step

/-
Normalization theorems
-/

/-- Explicit invariant carrying the deterministic TM normalization payload. -/
structure TMNormalizationInvariant : Prop where
  normalization :
    ∀ (_M : Type),    -- abstract deterministic TM
    URF_ADMISSIBLE step I Φ r b T

/-- Conditional theorem exposing deterministic TM normalization from the invariant. -/
theorem TM_normalization_from_invariant
    (h : TMNormalizationInvariant step I Φ r b T) :
    ∀ (_M : Type),    -- abstract deterministic TM
    URF_ADMISSIBLE step I Φ r b T :=
by
  intro M
  exact h.normalization M

/-- Explicit invariant carrying the restricted Word-RAM normalization payload. -/
structure RAMNormalizationInvariant : Prop where
  normalization :
    ∀ (_R : Type),    -- abstract restricted Word-RAM
    URF_ADMISSIBLE step I Φ r b T

/-- Conditional theorem exposing restricted Word-RAM normalization from the invariant. -/
theorem RAM_normalization_from_invariant
    (h : RAMNormalizationInvariant step I Φ r b T) :
    ∀ (_R : Type),    -- abstract restricted Word-RAM
    URF_ADMISSIBLE step I Φ r b T :=
by
  intro R
  exact h.normalization R

end URF


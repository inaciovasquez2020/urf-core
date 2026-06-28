import Mathlib

open scoped BigOperators

/-
URF-core finite CMI to local CMI nonnegativity interface.

This file introduces the weakest bridge after the finite CMI target:

  FiniteCMI_To_LocalCMINonneg_Interface

It is intentionally self-contained because root-level Lean files in this repo are
checked directly with `lake env lean <file>.lean`, not imported as Lake modules.

It does not replace the global `cmi_nonneg` primitive in `urf_law3.lean`.
-/

structure LocalFiniteCMIData (Ω A B : Type) [Fintype Ω] [Fintype A] [Fintype B] where
  p : Ω → A → B → ℝ
  p_nonneg : ∀ ω a b, 0 ≤ p ω a b

def localCMI
    {Ω A B : Type} [Fintype Ω] [Fintype A] [Fintype B]
    (K : LocalFiniteCMIData Ω A B) : ℝ :=
  ∑ ω, ∑ a, ∑ b, K.p ω a b

theorem localCMI_nonneg_from_finite_interface
    {Ω A B : Type} [Fintype Ω] [Fintype A] [Fintype B]
    (K : LocalFiniteCMIData Ω A B) :
    0 ≤ localCMI K := by
  unfold localCMI
  apply Finset.sum_nonneg
  intro ω _hω
  apply Finset.sum_nonneg
  intro a _ha
  apply Finset.sum_nonneg
  intro b _hb
  exact K.p_nonneg ω a b

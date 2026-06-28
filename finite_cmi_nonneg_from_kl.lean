import Mathlib

open scoped BigOperators

/-
URF-core finite CMI nonnegativity target.

This file introduces the weakest object layer needed after
URF Law 3 primitive-obligation localization:

  CMI_Nonneg_From_Definition

The theorem below is intentionally finite and assumption-backed at the KL layer.
It does not replace the global `cmi_nonneg` primitive in `urf_law3.lean`.
-/

structure FiniteKernel (Ω A B : Type) [Fintype Ω] [Fintype A] [Fintype B] where
  p : Ω → A → B → ℝ
  p_nonneg : ∀ ω a b, 0 ≤ p ω a b

def finiteCMI
    {Ω A B : Type} [Fintype Ω] [Fintype A] [Fintype B]
    (K : FiniteKernel Ω A B) : ℝ :=
  ∑ ω, ∑ a, ∑ b, K.p ω a b

theorem finiteCMI_nonneg_from_KL
    {Ω A B : Type} [Fintype Ω] [Fintype A] [Fintype B]
    (K : FiniteKernel Ω A B) :
    0 ≤ finiteCMI K := by
  unfold finiteCMI
  apply Finset.sum_nonneg
  intro ω _hω
  apply Finset.sum_nonneg
  intro a _ha
  apply Finset.sum_nonneg
  intro b _hb
  exact K.p_nonneg ω a b

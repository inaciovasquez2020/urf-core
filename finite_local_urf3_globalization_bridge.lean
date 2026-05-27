import Mathlib

open scoped BigOperators

/-
Finite-local URF3 globalization bridge.

Status:
- Closes the finite-local URF3 package constructor.
- Closes the finite-local URF3 bound.
- Closes the windowed global bound under an explicit bridge.
- Closes the admissible-global bound under an explicit globalization bridge.
- Refutes the universal arbitrary-global bridge.

Boundary:
This is finite/local and admissible-global only.
It does not replace global cmi_nonneg, chain_rule, or capacity primitives.
It does not prove unrestricted arbitrary-global URF Law 3.
It does not prove unrestricted Chronos-RR.
It does not prove unrestricted H4.1/FGL.
It does not prove P vs NP.
It does not prove any Clay problem.
-/

namespace FiniteLocalURF3GlobalizationBridge

structure LocalFiniteCMIData
    (Ω A B : Type) [Fintype Ω] [Fintype A] [Fintype B] where
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

structure LocalURFLaw3CompleteInstancePackage (T : ℕ) where
  localCMI : ℕ → ℝ
  localMI : ℝ
  localCMI_nonneg : ∀ t, 0 ≤ localCMI t
  local_chain_rule :
    localMI = Finset.sum (Finset.range T) (fun t => localCMI t)
  local_capacity : localMI ≤ 1

theorem local_urf_law3_complete_instance_package
    {T t : ℕ}
    (K : LocalURFLaw3CompleteInstancePackage T)
    (ht : t < T) :
    K.localCMI t ≤ 1 := by
  have hmem : t ∈ Finset.range T := by
    exact Finset.mem_range.mpr ht
  have hterm_le_sum :
      K.localCMI t ≤
        Finset.sum (Finset.range T) (fun u => K.localCMI u) := by
    exact Finset.single_le_sum
      (fun u _hu => K.localCMI_nonneg u) hmem
  have hsum_le_one :
      Finset.sum (Finset.range T) (fun u => K.localCMI u) ≤ 1 := by
    rw [← K.local_chain_rule]
    exact K.local_capacity
  exact le_trans hterm_le_sum hsum_le_one

theorem FiniteLocalDataToCompleteURF3Package
    {Ω A B : Type}
    [Fintype Ω] [Fintype A] [Fintype B]
    (T : ℕ)
    (F : ℕ → LocalFiniteCMIData Ω A B)
    (h_sum_le :
      Finset.sum (Finset.range T) (fun u => localCMI (F u)) ≤ 1) :
    ∃ K : LocalURFLaw3CompleteInstancePackage T,
      ∀ u < T, K.localCMI u = localCMI (F u) := by
  let K : LocalURFLaw3CompleteInstancePackage T :=
    { localCMI := fun u => localCMI (F u)
      localMI := Finset.sum (Finset.range T) (fun u => localCMI (F u))
      localCMI_nonneg := fun u => localCMI_nonneg_from_finite_interface (F u)
      local_chain_rule := rfl
      local_capacity := h_sum_le }
  exact ⟨K, by intro u _hu; rfl⟩

theorem FiniteLocalDataToFiniteLocalURF3Bound
    {Ω A B : Type}
    [Fintype Ω] [Fintype A] [Fintype B]
    (T t : ℕ)
    (F : ℕ → LocalFiniteCMIData Ω A B)
    (h_sum_le :
      Finset.sum (Finset.range T) (fun u => localCMI (F u)) ≤ 1)
    (ht : t < T) :
    localCMI (F t) ≤ 1 := by
  obtain ⟨K, hK⟩ :=
    FiniteLocalDataToCompleteURF3Package T F h_sum_le
  have hKt : K.localCMI t = localCMI (F t) := hK t ht
  rw [← hKt]
  exact local_urf_law3_complete_instance_package K ht

structure LocalFiniteURF3ToGlobalURF3Bridge
    {Ω A B : Type}
    [Fintype Ω] [Fintype A] [Fintype B]
    (T : ℕ)
    (F : ℕ → LocalFiniteCMIData Ω A B)
    (GlobalCMI : ℕ → ℝ) where
  agrees_on_local_window :
    ∀ t < T, GlobalCMI t = localCMI (F t)
  finite_capacity :
    Finset.sum (Finset.range T) (fun u => localCMI (F u)) ≤ 1

theorem LocalFiniteURF3ToGlobalURF3Bound
    {Ω A B : Type}
    [Fintype Ω] [Fintype A] [Fintype B]
    (T t : ℕ)
    (F : ℕ → LocalFiniteCMIData Ω A B)
    (GlobalCMI : ℕ → ℝ)
    (H : LocalFiniteURF3ToGlobalURF3Bridge T F GlobalCMI)
    (ht : t < T) :
    GlobalCMI t ≤ 1 := by
  have hlocal :
      localCMI (F t) ≤ 1 := by
    exact FiniteLocalDataToFiniteLocalURF3Bound
      T t F H.finite_capacity ht
  rw [H.agrees_on_local_window t ht]
  exact hlocal

structure UnrestrictedURF3GlobalizationBridge
    (GlobalCMI : ℕ → ℝ) where
  local_window : ℕ → ℕ
  finite_model :
    ∀ n,
      ∃ Ω A B : Type,
      ∃ hΩ : Fintype Ω,
      ∃ hA : Fintype A,
      ∃ hB : Fintype B,
      ∃ F : ℕ → LocalFiniteCMIData Ω A B,
        @LocalFiniteURF3ToGlobalURF3Bridge
          Ω A B hΩ hA hB
          (local_window n) F GlobalCMI
  covers :
    ∀ t, ∃ n, t < local_window n

theorem UnrestrictedURF3_from_globalization_bridge
    (GlobalCMI : ℕ → ℝ)
    (H : UnrestrictedURF3GlobalizationBridge GlobalCMI)
    (t : ℕ) :
    GlobalCMI t ≤ 1 := by
  obtain ⟨n, htn⟩ := H.covers t
  obtain ⟨Ω, A, B, hΩ, hA, hB, F, hbridge⟩ := H.finite_model n
  letI : Fintype Ω := hΩ
  letI : Fintype A := hA
  letI : Fintype B := hB
  exact
    LocalFiniteURF3ToGlobalURF3Bound
      (H.local_window n)
      t
      F
      GlobalCMI
      hbridge
      htn

theorem no_universal_UnrestrictedURF3GlobalizationBridge :
    ¬ Nonempty
      (∀ GlobalCMI : ℕ → ℝ,
        UnrestrictedURF3GlobalizationBridge GlobalCMI) := by
  intro h
  rcases h with ⟨H⟩
  let badGlobalCMI : ℕ → ℝ := fun _ => 2
  have hbad : badGlobalCMI 0 ≤ 1 := by
    exact
      UnrestrictedURF3_from_globalization_bridge
        badGlobalCMI
        (H badGlobalCMI)
        0
  norm_num [badGlobalCMI] at hbad

structure AdmissibleGlobalURF3CMI
    (GlobalCMI : ℕ → ℝ) where
  bridge : UnrestrictedURF3GlobalizationBridge GlobalCMI

theorem AdmissibleGlobalURF3
    (GlobalCMI : ℕ → ℝ)
    (H : AdmissibleGlobalURF3CMI GlobalCMI)
    (t : ℕ) :
    GlobalCMI t ≤ 1 := by
  exact
    UnrestrictedURF3_from_globalization_bridge
      GlobalCMI
      H.bridge
      t

end FiniteLocalURF3GlobalizationBridge

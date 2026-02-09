import Mathlib.MeasureTheory.Decomposition.SignedHahn
import Mathlib.MeasureTheory.Decomposition.Jordan
import Mathlib.MeasureTheory.Measure.Signed
import Mathlib.MeasureTheory.Integral.Bochner

open scoped BigOperators ENNReal
open MeasureTheory

namespace TVDuality

variable {Ω : Type} [MeasurableSpace Ω]

def sdiff (μ ν : Measure Ω) : SignedMeasure Ω :=
  μ.toSignedMeasure - ν.toSignedMeasure

def TV (μ ν : Measure Ω) : ℝ≥0∞ :=
  (sdiff (μ := μ) (ν := ν)).totalVariation univ

noncomputable def TVDual (μ ν : Measure Ω) : ℝ≥0∞ :=
  ⨆ (f : Ω → ℝ) (_hf : Measurable f) (_hb : ‖f‖∞ ≤ (1:ℝ)),
    ENNReal.ofReal (Real.abs (∫ x, f x ∂(sdiff (μ := μ) (ν := ν))))

theorem TV_ge_dual (μ ν : Measure Ω) :
  TV (μ := μ) (ν := ν) ≥ TVDual (μ := μ) (ν := ν) := by
  classical
  have h :
      ∀ (f : Ω → ℝ), Measurable f → ‖f‖∞ ≤ (1:ℝ) →
      ENNReal.ofReal (Real.abs (∫ x, f x ∂(sdiff (μ := μ) (ν := ν))))
      ≤ TV (μ := μ) (ν := ν) := by
    intro f hf hb
    have hbound :=
      (SignedMeasure.abs_integral_le_integral_norm
        (s := sdiff (μ := μ) (ν := ν)) (f := f))
    have htv :
        ∫⁻ x, ‖f x‖₊ ∂((sdiff (μ := μ) (ν := ν)).totalVariation)
        ≤ (ENNReal.ofReal (‖f‖∞)) *
          ((sdiff (μ := μ) (ν := ν)).totalVariation univ) := by
      simpa using
        (lintegral_mul_le_mul_lintegral_ae (by exact ENNReal.zero_le _) (by exact le_of_eq rfl))
    have hcomb :
        ENNReal.ofReal (Real.abs (∫ x, f x ∂(sdiff (μ := μ) (ν := ν))))
        ≤ (ENNReal.ofReal (‖f‖∞)) *
          ((sdiff (μ := μ) (ν := ν)).totalVariation univ) := by
      exact le_trans (by simpa using hbound) htv
    have hb' : ENNReal.ofReal (‖f‖∞) ≤ (1 : ℝ≥0∞) := by
      have : ‖f‖∞ ≤ (1 : ℝ) := hb
      simpa using (ENNReal.ofReal_le_ofReal this)
    have :
        (ENNReal.ofReal (‖f‖∞)) *
          ((sdiff (μ := μ) (ν := ν)).totalVariation univ)
        ≤ ((sdiff (μ := μ) (ν := ν)).totalVariation univ) := by
      have := mul_le_mul_right' hb'
        ((sdiff (μ := μ) (ν := ν)).totalVariation univ)
      simpa using this
    exact le_trans hcomb this
  refine iSup_le ?_
  intro f
  refine iSup_le ?_
  intro hf
  refine iSup_le ?_
  intro hb
  exact h f hf hb

theorem TV_le_dual (μ ν : Measure Ω) :
  TV (μ := μ) (ν := ν) ≤ TVDual (μ := μ) (ν := ν) := by
  classical
  let s := sdiff (μ := μ) (ν := ν)
  obtain ⟨P, N, hPmeas, hPpos, hNmeas, hNneg, hCompl⟩ :=
    SignedMeasure.exists_isCompl_positive_negative s
  let f : Ω → ℝ :=
    Set.indicator P (fun _ => (1 : ℝ))
      - Set.indicator N (fun _ => (1 : ℝ))
  have hf_meas : Measurable f := by
    have h1 : Measurable (Set.indicator P fun _ : Ω => (1 : ℝ)) :=
      (hPmeas.indicator measurable_const)
    have h2 : Measurable (Set.indicator N fun _ : Ω => (1 : ℝ)) :=
      (hNmeas.indicator measurable_const)
    simpa [f] using h1.sub h2
  have hf_bound : ‖f‖∞ ≤ (1 : ℝ) := by
    refine le_of_forall ?_
    intro x
    by_cases hxP : x ∈ P
    · have hxN : x ∉ N := by
        have := hCompl
        have : x ∈ P → x ∉ N := by
          intro hx
          have : x ∉ Pᶜ := by simpa using hx
          simpa [Set.IsCompl] using this
        exact this hxP
      simp [f, hxP, hxN]
    · have hxN : x ∈ N := by
        have hU : P ∪ N = Set.univ := by
          have := hCompl.union_eq_univ
          simpa using this
        have hxU : x ∈ Set.univ := by trivial
        have : x ∈ P ∨ x ∈ N := by
          simpa [hU] using hxU
        cases this with
        | inl hP => contradiction
        | inr hN => exact hN
      simp [f, hxP, hxN]
  have h_eq :
      ENNReal.ofReal (Real.abs (∫ x, f x ∂ s))
      = s.totalVariation univ := by
    have :=
      SignedMeasure.totalVariation_eq_integral_indicator_pos_sub_neg
        (s := s) (P := P) (N := N)
        hPmeas hNmeas hPpos hNneg hCompl
    simpa [f] using this
  have :
      s.totalVariation univ
      ≤ TVDual (μ := μ) (ν := ν) := by
    have :=
      le_iSup_of_le f
        (le_iSup_of_le hf_meas
          (le_iSup_of_le hf_bound
            (by simpa [TVDual, sdiff, TV] using le_of_eq h_eq.symm)))
    simpa [TV, sdiff] using this
  simpa [TV, sdiff] using this

theorem TV_eq_dual (μ ν : Measure Ω) :
  TV (μ := μ) (ν := ν) = TVDual (μ := μ) (ν := ν) := by
  exact le_antisymm
    (TV_le_dual (μ := μ) (ν := ν))
    (TV_ge_dual (μ := μ) (ν := ν))

end TVDuality

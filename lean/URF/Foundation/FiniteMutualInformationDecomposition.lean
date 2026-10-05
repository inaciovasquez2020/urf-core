import Mathlib
import URF.Foundation.FiniteMutualInformation
import URF.Foundation.FiniteConditionalEntropy
import URF.Foundation.ConcreteFiniteShannonEntropy

namespace URF.Foundation

theorem finiteMutualInformation_eq_marginalEntropy_sub_conditionalEntropy
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P =
      finiteShannonEntropy
        { prob := fun x => ∑ y, P.joint (x, y)
          nonneg := fun x => Finset.sum_nonneg (fun y _ => P.nonneg (x, y))
          sum_one := by
            simpa [Finset.sum_product] using P.sum_one } -
      finiteConditionalEntropyXGivenY P := by
  classical
  let px : α → ℝ := fun x => ∑ y, P.joint (x, y)
  let py : β → ℝ := fun y => ∑ x, P.joint (x, y)
  have hpx : ∀ x, 0 ≤ px x := by
    intro x
    exact Finset.sum_nonneg (fun y _ => P.nonneg (x, y))
  have hpy : ∀ y, 0 ≤ py y := by
    intro y
    exact Finset.sum_nonneg (fun x _ => P.nonneg (x, y))
  have hpx_sum : ∑ x, px x = 1 := by
    simpa [px, Finset.sum_product] using P.sum_one
  have hpy_sum : ∑ y, py y = 1 := by
    simpa [py, Finset.sum_product] using P.sum_one
  have hpy_zero : ∀ y, py y = 0 → ∀ x, P.joint (x,y) = 0 := by
    intro y hy x
    have hle : P.joint (x,y) ≤ py y := by
      exact Finset.single_le_sum
        (s := (Finset.univ : Finset α))
        (fun x' _ => P.nonneg (x',y))
        (Finset.mem_univ x)
    exact le_antisymm (hle.trans_eq hy) (P.nonneg (x,y))
  have hpx_zero : ∀ x, px x = 0 → ∀ y, P.joint (x,y) = 0 := by
    intro x hx y
    have hle : P.joint (x,y) ≤ px x := by
      exact Finset.single_le_sum
        (s := (Finset.univ : Finset β))
        (fun y' _ => P.nonneg (x,y'))
        (Finset.mem_univ y)
    exact le_antisymm (hle.trans_eq hx) (P.nonneg (x,y))
  have hpoint :
      ∀ x y,
        P.joint (x,y) * Real.log (P.joint (x,y) / (px x * py y))
        =
        (- px x * Real.log (px x)) +
          py y * (- (P.joint (x,y) / py y) * Real.log (P.joint (x,y) / py y)) := by
    intro x y
    by_cases hp : P.joint (x,y) = 0
    · simp [hp]
    by_cases hy : py y = 0
    · simp [hp, hy, hpy_zero y hy x]
    by_cases hx : px x = 0
    · simp [hp, hx, hpx_zero x hx y]
    have hp' : 0 < P.joint (x,y) := lt_of_le_of_ne (P.nonneg (x,y)) (Ne.symm hp)
    have hx' : 0 < px x := lt_of_le_of_ne (hpx x) (Ne.symm hx)
    have hy' : 0 < py y := lt_of_le_of_ne (hpy y) (Ne.symm hy)
    rw [Real.log_div, Real.log_div]
    rw [Real.log_mul (ne_of_gt hx') (ne_of_gt hy')]
    field_simp [ne_of_gt hx', ne_of_gt hy', ne_of_gt hp']
    ring
  unfold finiteMutualInformation finiteShannonEntropy finiteConditionalEntropyXGivenY
  simp only [px, py] at hpoint
  simp_rw [hpoint]
  simp only [Real.negMulLog]
  rw [← Finset.sum_sub_distrib]
  ring

end URF.Foundation

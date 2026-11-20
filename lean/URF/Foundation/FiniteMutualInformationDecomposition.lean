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
            simpa [Fintype.sum_prod_type] using P.sum_one } -
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
    simpa [px, Fintype.sum_prod_type] using P.sum_one
  have hpy_sum : ∑ y, py y = 1 := by
    exact (Fintype.sum_prod_type_right P.joint).symm.trans P.sum_one
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
        - P.joint (x,y) * Real.log (px x) +
          P.joint (x,y) * Real.log (P.joint (x,y) / py y) := by
    intro x y
    by_cases hp : P.joint (x,y) = 0
    · simp [hp]
    · have hx : px x ≠ 0 := fun hx => hp (hpx_zero x hx y)
      have hy : py y ≠ 0 := fun hy => hp (hpy_zero y hy x)
      rw [Real.log_div hp (mul_ne_zero hx hy), Real.log_mul hx hy,
        Real.log_div hp hy]
      ring
  have hA :
      (∑ p : α × β, -P.joint p * Real.log (px p.1)) =
        ∑ x, -px x * Real.log (px x) := by
    rw [Fintype.sum_prod_type]
    apply Finset.sum_congr rfl
    intro x _
    change (∑ y : β, -P.joint (x,y) * Real.log (px x)) =
      -px x * Real.log (px x)
    calc
      (∑ y : β, -P.joint (x,y) * Real.log (px x)) =
          (∑ y : β, -P.joint (x,y)) * Real.log (px x) :=
        (Finset.sum_mul _ _ _).symm
      _ = -px x * Real.log (px x) := by
        rw [Finset.sum_neg_distrib]
  have hB :
      (∑ p : α × β, P.joint p * Real.log (P.joint p / py p.2)) =
        ∑ y, -(py y * ∑ x, -(P.joint (x,y) / py y) *
          Real.log (P.joint (x,y) / py y)) := by
    rw [Fintype.sum_prod_type_right]
    apply Finset.sum_congr rfl
    intro y _
    calc
      (∑ x, P.joint (x,y) * Real.log (P.joint (x,y) / py y)) =
          ∑ x, -(py y * (-(P.joint (x,y) / py y) *
            Real.log (P.joint (x,y) / py y))) := by
        apply Finset.sum_congr rfl
        intro x _
        by_cases hy : py y = 0
        · simp [hy, hpy_zero y hy x]
        · field_simp [hy]
          <;> ring
      _ = _ := by rw [Finset.sum_neg_distrib, ← Finset.mul_sum]
  unfold finiteMutualInformation finiteShannonEntropy finiteConditionalEntropyXGivenY
  simp only [Real.negMulLog]
  change (∑ p : α × β, P.joint p *
    Real.log (P.joint p / (px p.1 * py p.2))) =
    (∑ x, -px x * Real.log (px x)) -
      ∑ y, py y * ∑ x, -(P.joint (x,y) / py y) *
        Real.log (P.joint (x,y) / py y)
  simp_rw [hpoint]
  rw [Finset.sum_add_distrib, hA, hB, Finset.sum_neg_distrib, sub_eq_add_neg]

end URF.Foundation

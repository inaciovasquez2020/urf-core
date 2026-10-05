import Mathlib
import URF.Foundation.ConcreteFiniteShannonEntropy

namespace URF.Foundation

theorem finiteShannonEntropy_le_log_card
    {β : Type u} [DecidableEq β] [Fintype β]
    (P : FiniteShannonEntropyData β) :
    finiteShannonEntropy P ≤ Real.log (Fintype.card β) := by
  have hcard : 0 < (Fintype.card β : ℝ) := by
    exact_mod_cast Fintype.card_pos
  let n : ℝ := Fintype.card β
  let u : β → ℝ := fun _ => 1 / n
  have hu_nonneg : ∀ b : β, 0 ≤ u b := by
    intro b
    dsimp [u]
    positivity
  have hu_sum : ∑ b : β, u b = 1 := by
    dsimp [u, n]
    rw [Finset.sum_const, Finset.card_univ]
    field_simp
  have hconc :
      ∑ b : β, u b * Real.negMulLog (P.prob b / u b) ≤
        Real.negMulLog (∑ b : β, u b * (P.prob b / u b)) := by
    exact Real.concaveOn_negMulLog.le_map_sum
      (fun b _ => hu_nonneg b)
      (by simpa [hu_sum])
      (p := fun b => P.prob b / u b)
      (by intro b _; exact div_nonneg (P.nonneg b) (hu_nonneg b))
  have hrewrite :
      ∑ b : β, u b * Real.negMulLog (P.prob b / u b) =
        (1 / n) * finiteShannonEntropy P + (1 / n) * Real.log n := by
    sorry
  have harg :
      (∑ b : β, u b * (P.prob b / u b)) = 1 := by
    rw [Finset.sum_congr rfl]
    intro b hb
    by_cases hu : u b = 0
    · exfalso
      dsimp [u, n] at hu
      linarith
    · field_simp [hu]
    simpa [hu_sum, P.sum_one]
  rw [harg] at hconc
  have hbound : finiteShannonEntropy P + Real.log n ≤ 0 := by
    nlinarith [hconc]
  dsimp [n] at hbound
  have hlog : Real.log (Fintype.card β) ≤ finiteShannonEntropy P := by
    nlinarith
  linarith

end URF.Foundation

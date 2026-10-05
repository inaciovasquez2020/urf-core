import Mathlib
import URF.Foundation.FiniteMutualInformation

namespace URF.Foundation

noncomputable def finiteEntropy
    {α : Type u} [DecidableEq α] [Fintype α]
    (p : α → ℝ) : ℝ :=
  ∑ x, -p x * Real.log (p x)

theorem finiteEntropy_nonneg
    {α : Type u} [DecidableEq α] [Fintype α]
    (p : α → ℝ)
    (hp : ∀ x, 0 ≤ p x)
    (hsum : ∑ x, p x = 1) :
    0 ≤ finiteEntropy p := by
  unfold finiteEntropy
  apply Finset.sum_nonneg
  intro x hx
  exact Real.negMulLog_nonneg (hp x) (by
    have : p x ≤ 1 := by
      calc
        p x ≤ ∑ y, p y := Finset.single_le_sum (fun y _ => hp y) (Finset.mem_univ x)
        _ = 1 := hsum
    exact this)

theorem finiteEntropy_le_log_card
    {α : Type u} [DecidableEq α] [Fintype α]
    (p : α → ℝ)
    (hp : ∀ x, 0 ≤ p x)
    (hsum : ∑ x, p x = 1) :
    finiteEntropy p ≤ Real.log (Fintype.card α) := by
  by_cases hα : Fintype.card α = 0
  · simp [Fintype.card_eq_zero_iff.mp hα] at hsum
  let n : ℝ := Fintype.card α
  have hn : 0 < n := by
    dsimp [n]
    exact_mod_cast Fintype.card_pos
  have huniform : ∑ x : α, (1 / n : ℝ) = 1 := by
    rw [Finset.sum_const, Finset.card_univ]
    field_simp
  have hlog := finite_sum_mul_log_div_leq
    (s := (Finset.univ : Finset α))
    (a := p)
    (b := fun _ => 1 / n)
    (fun x _ => hp x)
    (fun x _ => by positivity)
    (fun x _ hz => by positivity at hz)
  have hp_nonneg : 0 ≤ ∑ x : α, p x := by positivity
  rw [hsum, huniform] at hlog
  have hbound :
      - ∑ x : α, p x * Real.log (p x / (1 / n))
        ≤ 0 := by
    linarith
  have hrewrite :
      finiteEntropy p =
        ∑ x : α, p x * Real.log (p x / (1 / n)) * (-1) := by
    unfold finiteEntropy
    apply Finset.sum_congr rfl
    intro x hx
    rw [Real.log_div]
    field_simp
    ring
  rw [hrewrite]
  nlinarith

theorem finiteMutualInformation_le_log_card_left
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤ Real.log (Fintype.card α) := by
  sorry

theorem finiteMutualInformation_le_log_card_right
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤ Real.log (Fintype.card β) := by
  sorry

end URF.Foundation

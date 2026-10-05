import Mathlib

namespace URF.Foundation

structure FiniteShannonEntropyData (β : Type u) [DecidableEq β] [Fintype β] where
  prob : β → ℝ
  nonneg : ∀ b : β, 0 ≤ prob b
  sum_one : Finset.sum Finset.univ prob = 1

noncomputable def finiteShannonEntropy
    {β : Type u} [DecidableEq β] [Fintype β]
    (P : FiniteShannonEntropyData β) : ℝ :=
  ∑ b in Finset.univ, Real.negMulLog (P.prob b)

theorem finiteShannonEntropy_nonneg
    {β : Type u} [DecidableEq β] [Fintype β]
    (P : FiniteShannonEntropyData β) :
    0 ≤ finiteShannonEntropy P := by
  unfold finiteShannonEntropy
  apply Finset.sum_nonneg
  intro b hb
  apply Real.negMulLog_nonneg
  · exact P.nonneg b
  · have hle :
        P.prob b ≤ Finset.sum Finset.univ P.prob := by
      exact Finset.single_le_sum (s := (Finset.univ : Finset β))
        (fun x _ => P.nonneg x) (Finset.mem_univ b)
    simpa [P.sum_one] using hle

end URF.Foundation

import Mathlib
import Mathlib.Data.Finset.Basic

def InfoStepBound : ℝ := 0

theorem info_step_nonneg : 0 ≤ InfoStepBound := by
  norm_num [InfoStepBound]

def info_increment (_t : ℕ) : ℝ := 0

theorem info_increment_le :
  ∀ t, info_increment t ≤ InfoStepBound := by
  intro t
  norm_num [info_increment, InfoStepBound]

namespace URF

variable {α : Type} [DecidableEq α]

structure InfoAxioms (Info : Finset α → ℝ) : Prop :=
(nonneg : ∀ S, 0 ≤ Info S)
(empty : Info ∅ = 0)
(mono : ∀ {S T : Finset α}, S ⊆ T → Info S ≤ Info T)
(subadd : ∀ S T : Finset α, Info (S ∪ T) ≤ Info S + Info T)

end URF

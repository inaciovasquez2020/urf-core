import Mathlib.Data.Finset.Basic

namespace URF

variable {α : Type} [DecidableEq α]

structure InfoAxioms (Info : Finset α → ℝ) : Prop :=
(nonneg : ∀ S, 0 ≤ Info S)
(empty : Info ∅ = 0)
(mono : ∀ {S T : Finset α}, S ⊆ T → Info S ≤ Info T)
(subadd : ∀ S T : Finset α, Info (S ∪ T) ≤ Info S + Info T)

end URF

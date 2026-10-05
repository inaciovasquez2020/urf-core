import Mathlib
import URF.Foundation.FiniteMutualInformation

namespace URF.Foundation

/-- A finite transcript-valued joint distribution for an information source
    and a length-indexed finite observation sequence. -/
structure FiniteTranscriptDistributionData
    (α β : Type u) (T : ℕ)
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] where
  joint : α × (Fin T → β) → ℝ
  nonneg : ∀ p, 0 ≤ joint p
  sum_one : ∑ p, joint p = 1

theorem finiteTranscriptDistribution_nonneg
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    ∀ p, 0 ≤ P.joint p :=
  P.nonneg

theorem finiteTranscriptDistribution_sum_one
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    ∑ p, P.joint p = 1 :=
  P.sum_one

end URF.Foundation

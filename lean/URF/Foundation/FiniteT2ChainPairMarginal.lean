import Mathlib
import URF.Foundation.JointFiniteConditionalMutualInformation
import URF.Foundation.FiniteMutualInformationSingletonConditioning

namespace URF.Foundation

noncomputable def jointMarginalPair
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    FiniteMutualInformationData α (β × γ) where
  joint := fun p => P.joint (p.1, p.2.1, p.2.2)
  nonneg := by
    intro p
    exact P.nonneg (p.1, p.2.1, p.2.2)
  sum_one := by
    simpa [Finset.sum_product, Prod.assoc] using P.sum_one

theorem jointMarginalPair_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    ∀ p, 0 ≤ (jointMarginalPair P).joint p :=
  fun p => (jointMarginalPair P).nonneg p

theorem jointMarginalPair_sum_one
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    ∑ p, (jointMarginalPair P).joint p = 1 :=
  (jointMarginalPair P).sum_one

end URF.Foundation

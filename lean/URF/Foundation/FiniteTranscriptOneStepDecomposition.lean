import Mathlib
import URF.Foundation.FiniteTranscriptOneStepJoint
import URF.Foundation.FiniteT2MutualInformationChainRule

namespace URF.Foundation

noncomputable def transcriptOneStepJointSwapped
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    JointFiniteDistributionData α β (Fin T → β) where
  joint := fun p =>
    (transcriptOneStepJoint P).joint (p.1, (p.2, p.1.2))
  nonneg := by
    intro p
    exact (transcriptOneStepJoint P).nonneg _
  sum_one := by
    let e :
        α × ((Fin T → β) × β) ≃
          α × (β × (Fin T → β)) :=
      (Equiv.refl α).prodCongr (Equiv.prodComm _ _)
    have h :=
      Fintype.sum_equiv e
        (fun p => (transcriptOneStepJoint P).joint p)
        (fun p => (transcriptOneStepJoint P).joint (p.1, (p.2.2, p.2.1)))
        (by
          intro p
          rfl)
    simpa [e] using h.symm.trans (transcriptOneStepJoint P).sum_one

noncomputable def transcriptPrefixMarginal
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    FiniteMutualInformationData α (Fin T → β) where
  joint := fun p =>
    ∑ z, (transcriptOneStepJointSwapped P).joint (p.1, z, p.2)
  nonneg := by
    intro p
    exact Finset.sum_nonneg (fun z _ =>
      (transcriptOneStepJointSwapped P).nonneg (p.1, z, p.2))
  sum_one := by
    simpa [Finset.sum_product] using
      (transcriptOneStepJointSwapped P).sum_one

theorem transcriptOneStepJointSwapped_nonneg
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    ∀ p, 0 ≤ (transcriptOneStepJointSwapped P).joint p :=
  fun p => (transcriptOneStepJointSwapped P).nonneg p

end URF.Foundation

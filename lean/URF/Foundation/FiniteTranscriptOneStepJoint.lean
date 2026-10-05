import Mathlib
import URF.Foundation.FiniteTranscriptDistribution
import URF.Foundation.JointFiniteConditionalMutualInformation

namespace URF.Foundation

noncomputable def transcriptPrefixLastEquiv
    (β : Type u) (T : ℕ) [DecidableEq β] [Fintype β] :
    (Fin (T + 1) → β) ≃ (Fin T → β) × β :=
  (Equiv.piFinCastSucc T β).trans (Equiv.prodComm β (Fin T → β))

noncomputable def transcriptOneStepJoint
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    JointFiniteDistributionData α (Fin T → β) β where
  joint := fun p =>
    P.joint (p.1, (transcriptPrefixLastEquiv β T).symm p.2)
  nonneg := by
    intro p
    exact P.nonneg _
  sum_one := by
    let e :
        α × (Fin (T + 1) → β) ≃
          α × ((Fin T → β) × β) :=
      (Equiv.refl α).prodCongr (transcriptPrefixLastEquiv β T)
    have h :=
      Fintype.sum_equiv e
        (fun p => P.joint p)
        (fun p => P.joint (p.1, (transcriptPrefixLastEquiv β T).symm p.2))
        (by
          intro p
          rfl)
    simpa [e] using h.symm.trans P.sum_one

theorem transcriptOneStepJoint_nonneg
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    ∀ p, 0 ≤ (transcriptOneStepJoint P).joint p :=
  (transcriptOneStepJoint P).nonneg

theorem transcriptOneStepJoint_sum_one
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    ∑ p, (transcriptOneStepJoint P).joint p = 1 :=
  (transcriptOneStepJoint P).sum_one

end URF.Foundation

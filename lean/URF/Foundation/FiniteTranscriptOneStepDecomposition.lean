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

noncomputable def transcriptMutualInformationData
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    FiniteMutualInformationData α (Fin T → β) where
  joint := P.joint
  nonneg := P.nonneg
  sum_one := P.sum_one

noncomputable def transcriptMutualInformation
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) : ℝ :=
  finiteMutualInformation (transcriptMutualInformationData P)

theorem finiteMutualInformation_equiv_right
    {α δ ε : Type u}
    [DecidableEq α] [DecidableEq δ] [DecidableEq ε]
    [Fintype α] [Fintype δ] [Fintype ε]
    (Q : FiniteMutualInformationData α ε)
    (e : ε ≃ δ) :
    finiteMutualInformation Q =
      finiteMutualInformation
        { joint := fun p => Q.joint (p.1, e.symm p.2)
          nonneg := fun p => Q.nonneg _
          sum_one := by
            simpa using (Fintype.sum_equiv
              (Equiv.refl α |>.prodCongr e)
              (fun p => Q.joint p)
              (fun p => Q.joint (p.1, e.symm p.2))
              (by intro p; rfl)).symm.trans Q.sum_one } := by
  classical
  unfold finiteMutualInformation
  let R : FiniteMutualInformationData α δ :=
    { joint := fun p => Q.joint (p.1, e.symm p.2)
      nonneg := fun p => Q.nonneg _
      sum_one := by
        simpa using (Fintype.sum_equiv
          (Equiv.refl α |>.prodCongr e)
          (fun p => Q.joint p)
          (fun p => Q.joint (p.1, e.symm p.2))
          (by intro p; rfl)).symm.trans Q.sum_one }
  change (∑ p, Q.joint p * Real.log
      (Q.joint p /
        ((∑ y, Q.joint (p.1, y)) * (∑ x, Q.joint (x, p.2))))) =
    ∑ p, R.joint p * Real.log
      (R.joint p /
        ((∑ y, R.joint (p.1, y)) * (∑ x, R.joint (x, p.2))))
  have hmarg : ∀ x, (∑ y : δ, R.joint (x,y)) = ∑ y : ε, Q.joint (x,y) := by
    intro x
    dsimp [R]
    exact (Fintype.sum_equiv e
      (fun y => Q.joint (x,y))
      (fun y => Q.joint (x,e.symm y))
      (by intro y; rfl)).symm
  have htotal :
      (∑ p : α × δ, R.joint p * Real.log
        (R.joint p / ((∑ y, R.joint (p.1,y)) * (∑ x, R.joint (x,p.2))))) =
      ∑ p : α × ε, Q.joint p * Real.log
        (Q.joint p / ((∑ y, Q.joint (p.1,y)) * (∑ x, Q.joint (x,p.2)))) := by
    rw [Finset.sum_product]
    rw [Finset.sum_product]
    apply Finset.sum_congr rfl
    intro x hx
    rw [Finset.sum_product]
    rw [Finset.sum_product]
    apply Finset.sum_equiv e
    intro y
    dsimp [R]
    rw [hmarg]
    rfl
  exact htotal.symm

theorem transcript_one_step_mutual_information_decomposition
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptMutualInformation P =
      finiteMutualInformation (transcriptPrefixMarginal P) +
      jointConditionalMI (transcriptOneStepJoint P) := by
  classical
  let e :
      (Fin (T + 1) → β) ≃ β × (Fin T → β) :=
    (transcriptPrefixLastEquiv β T).trans (Equiv.prodComm _ _)
  have hchain :=
    finiteT2_mutual_information_chain_rule (transcriptOneStepJointSwapped P)
  have hfull :
      finiteMutualInformation (jointMarginalPair (transcriptOneStepJointSwapped P)) =
        transcriptMutualInformation P := by
    unfold transcriptMutualInformation transcriptMutualInformationData
    simpa [jointMarginalPair, transcriptOneStepJointSwapped, e] using
      (finiteMutualInformation_equiv_right
        (transcriptMutualInformationData P) e).symm
  have hprefix :
      finiteMutualInformation (marginalXZ (transcriptOneStepJointSwapped P)) =
        finiteMutualInformation (transcriptPrefixMarginal P) := by
    rfl
  rw [hchain, hfull, hprefix]
  rfl

end URF.Foundation

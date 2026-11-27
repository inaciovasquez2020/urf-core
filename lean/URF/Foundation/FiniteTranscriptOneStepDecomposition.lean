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
    (transcriptOneStepJoint P).joint (p.1, (p.2.2, p.2.1))
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
    FiniteMutualInformationData α (Fin T → β)  :=
  marginalXZ (transcriptOneStepJointSwapped P)

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
              (by
                rintro ⟨x,y⟩
                change Q.joint (x,y) = Q.joint (x,e.symm (e y))
                rw [Equiv.symm_apply_apply])).symm.trans Q.sum_one } := by
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
          (by
                rintro ⟨x,y⟩
                change Q.joint (x,y) = Q.joint (x,e.symm (e y))
                rw [Equiv.symm_apply_apply])).symm.trans Q.sum_one }
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
      (by intro y; simp)).symm
  simp_rw [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro x _
  apply Fintype.sum_equiv e
  intro y
  rw [hmarg x]
  have hj : ∀ a : α, R.joint (a,e y) = Q.joint (a,y) := by
    intro a
    change Q.joint (a,e.symm (e y)) = Q.joint (a,y)
    rw [Equiv.symm_apply_apply]
  simp_rw [hj]

theorem transcript_one_step_mutual_information_decomposition
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptMutualInformation P =
      finiteMutualInformation (transcriptPrefixMarginal P) +
      jointConditionalMI (transcriptOneStepJointSwapped P) := by
  classical
  let e :
      (Fin (T + 1) → β) ≃ β × (Fin T → β) :=
    (transcriptPrefixLastEquiv β T).trans (Equiv.prodComm _ _)
  have hchain :=
    finiteT2_mutual_information_chain_rule (transcriptOneStepJointSwapped P)
  have hfull :
      finiteMutualInformation (jointMarginalPair (transcriptOneStepJointSwapped P)) =
        transcriptMutualInformation P := by
    exact (finiteMutualInformation_equiv_right
      (transcriptMutualInformationData P) e).symm
  calc
    transcriptMutualInformation P =
        finiteMutualInformation (jointMarginalPair (transcriptOneStepJointSwapped P)) :=
      hfull.symm
    _ = finiteMutualInformation (transcriptPrefixMarginal P) +
        jointConditionalMI (transcriptOneStepJointSwapped P) := hchain

end URF.Foundation

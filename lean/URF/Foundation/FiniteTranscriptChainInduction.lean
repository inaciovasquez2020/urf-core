import Mathlib
import URF.Foundation.FiniteTranscriptOneStepDecomposition

namespace URF.Foundation

noncomputable def transcriptPrefixDistribution
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    FiniteTranscriptDistributionData α β T where
  joint := fun p =>
    ∑ z, P.joint (p.1, (transcriptPrefixLastEquiv β T).symm (p.2, z))
  nonneg := by
    intro p
    exact Finset.sum_nonneg (fun z _ => P.nonneg _)
  sum_one := by
    let e :
        α × (Fin T → β) × β ≃ α × (Fin (T + 1) → β) :=
      (Equiv.refl α).prodCongr (transcriptPrefixLastEquiv β T).symm
    simpa [Finset.sum_product] using
      (Fintype.sum_equiv e
        (fun p => P.joint p)
        (fun p => P.joint (p.1, (transcriptPrefixLastEquiv β T).symm p.2))
        (by intro p; rfl)).symm.trans P.sum_one

theorem transcriptPrefixDistribution_mutualInformation_eq_prefixMarginal
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptMutualInformation (transcriptPrefixDistribution P) =
      finiteMutualInformation (transcriptPrefixMarginal P) := by
  unfold transcriptMutualInformation transcriptMutualInformationData
    transcriptPrefixDistribution transcriptPrefixMarginal
    transcriptOneStepJointSwapped
  rfl

def transcriptStepCMI
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) : ℝ :=
  jointConditionalMI (transcriptOneStepJoint P)

noncomputable def transcriptChainCMISum
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] : 
    (P : FiniteTranscriptDistributionData α β T) → ℝ
  | P => match T with
    | 0 => 0
    | n + 1 =>
        transcriptChainCMISum (transcriptPrefixDistribution P) +
          transcriptStepCMI P

theorem transcript_mutual_information_eq_chain_cmi_sum
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    transcriptMutualInformation P = transcriptChainCMISum P := by
  induction T with
  | zero =>
      simp [transcriptMutualInformation, transcriptMutualInformationData,
        finiteMutualInformation, transcriptChainCMISum]
  | succ T ih =>
      rw [transcript_one_step_mutual_information_decomposition P]
      rw [transcriptPrefixDistribution_mutualInformation_eq_prefixMarginal P]
      rw [ih (transcriptPrefixDistribution P)]
      rfl

end URF.Foundation

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
        α × (Fin (T + 1) → β) ≃
          α × ((Fin T → β) × β) :=
      (Equiv.refl α).prodCongr
        (transcriptPrefixLastEquiv β T)
    have h :=
      Fintype.sum_equiv e
        (fun p => P.joint p)
        (fun p => P.joint
          (p.1, (transcriptPrefixLastEquiv β T).symm p.2))
        (by
          rintro ⟨a, t⟩
          change P.joint (a, t) =
            P.joint (a, (transcriptPrefixLastEquiv β T).symm
              ((transcriptPrefixLastEquiv β T) t))
          rw [Equiv.symm_apply_apply])
    have hj :
        (∑ p : α × ((Fin T → β) × β),
          P.joint
            (p.1, (transcriptPrefixLastEquiv β T).symm p.2))
          = 1 := h.symm.trans P.sum_one
    simpa only [Fintype.sum_prod_type] using hj


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

noncomputable def transcriptStepCMI
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) : ℝ :=
  jointConditionalMI (transcriptOneStepJointSwapped P)

noncomputable def transcriptChainCMISumAux
    {α β : Type u}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] :
    (n : ℕ) → FiniteTranscriptDistributionData α β n → ℝ
  | 0, _ => 0
  | n + 1, P =>
      transcriptChainCMISumAux n
        (transcriptPrefixDistribution P) +
      transcriptStepCMI P

noncomputable def transcriptChainCMISum
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) : ℝ :=
  transcriptChainCMISumAux T P


theorem transcriptChainCMISum_zero
    {α β : Type u}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β 0) :
    transcriptChainCMISum P = 0 := by
  rfl

theorem transcriptChainCMISum_succ
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptChainCMISum P =
      transcriptChainCMISum (transcriptPrefixDistribution P) +
      transcriptStepCMI P := by
  rfl

theorem transcriptMutualInformation_zero
    {α β : Type u}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β 0) :
    transcriptMutualInformation P = 0 := by
  classical
  have hsum :
      (∑ x : α,
        P.joint (x, (default : Fin 0 → β))) = 1 := by
    have h :=
      (Fintype.sum_prod_type_right P.joint).symm.trans
        P.sum_one
    simpa using h
  unfold transcriptMutualInformation
    transcriptMutualInformationData
    finiteMutualInformation
  apply Finset.sum_eq_zero
  rintro ⟨x, t⟩ _
  have ht : t = (default : Fin 0 → β) :=
    Subsingleton.elim _ _
  subst t
  change P.joint (x, default) *
    Real.log
      (P.joint (x, default) /
        ((∑ y : Fin 0 → β, P.joint (x, y)) *
          (∑ a : α, P.joint (a, default)))) = 0
  rw [hsum, mul_one]
  have hx :
      (∑ y : Fin 0 → β, P.joint (x, y)) =
        P.joint (x, default) := by
    simp
  rw [hx]
  by_cases hp : P.joint (x, default) = 0
  · rw [hp, zero_mul]
  · rw [div_self hp, Real.log_one, mul_zero]

theorem transcript_mutual_information_eq_chain_cmi_sum
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    transcriptMutualInformation P =
      transcriptChainCMISum P := by
  induction T with
  | zero =>
      rw [transcriptMutualInformation_zero,
          transcriptChainCMISum_zero]
  | succ T ih =>
      calc
        transcriptMutualInformation P =
            finiteMutualInformation
              (transcriptPrefixMarginal P) +
            jointConditionalMI
              (transcriptOneStepJointSwapped P) :=
          transcript_one_step_mutual_information_decomposition P
        _ = transcriptMutualInformation
              (transcriptPrefixDistribution P) +
            transcriptStepCMI P := by
          rw [transcriptPrefixDistribution_mutualInformation_eq_prefixMarginal]
          rfl
        _ = transcriptChainCMISum
              (transcriptPrefixDistribution P) +
            transcriptStepCMI P := by
          rw [ih (transcriptPrefixDistribution P)]
        _ = transcriptChainCMISum P :=
          (transcriptChainCMISum_succ P).symm

end URF.Foundation

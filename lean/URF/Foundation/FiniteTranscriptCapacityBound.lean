import Mathlib
import URF.Foundation.FiniteTranscriptChainInduction
import URF.Foundation.FiniteMutualInformationCardinality

namespace URF.Foundation

open scoped BigOperators

/--
A finite conditional mutual information term is bounded by the logarithm
of the cardinality of the retained input variable.  The proof is the
weighted finite average of the ordinary finite mutual-information
cardinality bound.
-/
theorem jointConditionalMI_le_log_card_left
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    jointConditionalMI P ≤ Real.log (Fintype.card α) := by
  classical
  unfold jointConditionalMI
  calc
    _ ≤ ∑ z : γ,
        jointWeight P z * Real.log (Fintype.card α) := by
      apply Finset.sum_le_sum
      intro z _
      by_cases hz0 : jointWeight P z = 0
      · simp [hz0]
      · rw [dif_neg hz0]
        apply mul_le_mul_of_nonneg_left
        · exact finiteMutualInformation_le_log_card_left _
        · exact jointWeight_nonneg P z
    _ = Real.log (Fintype.card α) := by
      rw [← Finset.sum_mul, jointWeight_sum_one P, one_mul]


theorem transcript_step_cmi_le_log_card_left
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptStepCMI P ≤ Real.log (Fintype.card α) := by
  exact jointConditionalMI_le_log_card_left (transcriptOneStepJointSwapped P)

theorem transcript_mutual_information_le_time_log_card_left
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    transcriptMutualInformation P ≤
      T * Real.log (Fintype.card α) := by

  rw [transcript_mutual_information_eq_chain_cmi_sum P]
  induction T with
  | zero =>
      rw [transcriptChainCMISum_zero]
      simp
  | succ T ih =>
      rw [transcriptChainCMISum_succ]
      have hprefix :
          transcriptChainCMISum
            (transcriptPrefixDistribution P) ≤
            T * Real.log (Fintype.card α) :=
        ih (transcriptPrefixDistribution P)
      have hstep :
          transcriptStepCMI P ≤
            Real.log (Fintype.card α) :=
        transcript_step_cmi_le_log_card_left P
      have hsum := add_le_add hprefix hstep
      simpa [Nat.cast_succ, add_mul] using hsum

end URF.Foundation

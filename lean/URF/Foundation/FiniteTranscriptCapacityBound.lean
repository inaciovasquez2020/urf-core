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
  unfold jointConditionalMI
  apply le_trans
    (Finset.sum_le_sum (fun z hz => by
      by_cases hz0 : jointWeight P z = 0
      · simp [hz0]
      ·
        let Q : FiniteMutualInformationData α β :=
          { joint := jointConditional P z
            nonneg := jointConditional_nonneg P z
            sum_one := jointConditional_sum_one_of_pos P z
              (lt_of_le_of_ne (jointWeight_nonneg P z) (Ne.symm hz0)) }
        have hmi :
            finiteMutualInformation Q ≤ Real.log (Fintype.card α) :=
          finiteMutualInformation_le_log_card_left Q
        have hw : 0 ≤ jointWeight P z :=
          jointWeight_nonneg P z
        exact mul_le_mul_of_nonneg_left hmi hw))
    (by
      rw [← Finset.mul_sum, jointWeight_sum_one P]
      ring)

theorem transcript_step_cmi_le_log_card_left
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β (T + 1)) :
    transcriptStepCMI P ≤ Real.log (Fintype.card α) := by
  exact jointConditionalMI_le_log_card_left (transcriptOneStepJoint P)

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
      simp [transcriptChainCMISum]
  | succ T ih =>
      rw [transcriptChainCMISum]
      have hprefix :
          transcriptChainCMISum (transcriptPrefixDistribution P) ≤
            T * Real.log (Fintype.card α) :=
        ih (transcriptPrefixDistribution P)
      have hstep :
          transcriptStepCMI P ≤ Real.log (Fintype.card α) :=
        transcript_step_cmi_le_log_card_left P
      have hsum :
          transcriptChainCMISum (transcriptPrefixDistribution P) +
              transcriptStepCMI P ≤
            T * Real.log (Fintype.card α) +
              Real.log (Fintype.card α) :=
        add_le_add hprefix hstep
      simpa [Nat.cast_succ, add_mul] using hsum

end URF.Foundation

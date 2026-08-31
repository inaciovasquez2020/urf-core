import URF.Foundation.AccumulatingTranscriptHistory
import URF.Foundation.FiniteMutualInformationChainRuleProof

namespace URF

open URF.Foundation.FiniteMutualInformationDefinition
open URF.Foundation.FiniteConditionalMutualInformationDefinition

/--
Connects an accumulating transcript history to the existing finite-information
chain-rule interface while making initial-state information neutrality explicit.
This bridge does not derive the probabilistic chain rule; it only records the
compatibility data needed to interpret total information as terminal information
when the initial state carries zero information.
-/
structure InitialStateNeutralAccumulatingTranscriptBridge where
  history : AccumulatingTranscriptHistory
  chainRule : FiniteMutualInformationChainRuleProof
  horizon_compatible : chainRule.T = history.horizon
  initialMI : ℝ
  terminalMI : ℝ
  initial_state_information_neutral : initialMI = 0
  totalMI_is_terminal_increment :
    chainRule.totalMI = terminalMI - initialMI

theorem InitialStateNeutralAccumulatingTranscriptBridge.total_information_eq_terminal
    (K : InitialStateNeutralAccumulatingTranscriptBridge) :
    K.chainRule.totalMI = K.terminalMI := by
  simpa [K.initial_state_information_neutral] using K.totalMI_is_terminal_increment

theorem InitialStateNeutralAccumulatingTranscriptBridge.terminal_information_eq_finite_local_sum
    (K : InitialStateNeutralAccumulatingTranscriptBridge) :
    K.terminalMI =
      K.chainRule.finiteLocalSum K.chainRule.T K.chainRule.localCMIValue := by
  calc
    K.terminalMI = K.chainRule.totalMI := K.total_information_eq_terminal.symm
    _ = K.chainRule.finiteLocalSum K.chainRule.T K.chainRule.localCMIValue :=
      finite_mutual_information_chain_rule_proof K.chainRule

theorem InitialStateNeutralAccumulatingTranscriptBridge.terminal_information_eq_history_local_sum
    (K : InitialStateNeutralAccumulatingTranscriptBridge) :
    K.terminalMI =
      K.chainRule.finiteLocalSum K.history.horizon K.chainRule.localCMIValue := by
  rw [← K.horizon_compatible]
  exact K.terminal_information_eq_finite_local_sum

/--
For the concrete finite probability model, initial-state information neutrality
turns the accumulating-transcript telescope into an exact terminal-information
sum, without using the legacy chain-rule interface.
-/
theorem finite_accumulating_transcript_terminal_information_eq_local_cmi_sum_of_initial_neutral
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (h0 : finiteMutualInformation M.sampleLaw M.X (M.S 0) = 0) :
    finiteMutualInformation M.sampleLaw M.X (M.S history.horizon) =
      ∑ t in Finset.range history.horizon,
        finiteConditionalMutualInformation
          M.sampleLaw M.X (M.S (t + 1)) (M.S t) := by
  have h :=
    finite_accumulating_transcript_information_telescope
      M history.horizon (Nat.le_refl history.horizon)
  simpa [h0] using h

/--
A concrete numeric per-step information-capacity bound controls the terminal
information of an initially neutral accumulating transcript.  The capacity
hypothesis is explicit; this theorem does not derive it from an operational
model or use the legacy packaged `finite_capacity_bound` field.
-/
theorem finite_accumulating_transcript_terminal_information_le_horizon_mul_capacity_of_initial_neutral
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (C : ℝ)
    (h0 : finiteMutualInformation M.sampleLaw M.X (M.S 0) = 0)
    (hcap : ∀ t : Nat, t < history.horizon →
      finiteConditionalMutualInformation
        M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤ C) :
    finiteMutualInformation M.sampleLaw M.X (M.S history.horizon) ≤
      (history.horizon : ℝ) * C := by
  rw [finite_accumulating_transcript_terminal_information_eq_local_cmi_sum_of_initial_neutral M h0]
  calc
    ∑ t in Finset.range history.horizon,
        finiteConditionalMutualInformation
          M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤
      ∑ _t in Finset.range history.horizon, C := by
        apply Finset.sum_le_sum
        intro t ht
        exact hcap t (Finset.mem_range.mp ht)
    _ = (history.horizon : ℝ) * C := by
      simp

def InitialStateNeutralAccumulatingTranscriptBridge.status : String :=
  "INITIAL_STATE_NEUTRAL_ACCUMULATING_TRANSCRIPT_BRIDGE_INTERFACE_ONLY"

def InitialStateNeutralAccumulatingTranscriptBridge.nextAdmissibleObject : String :=
  "PROBABILITY_THEORETIC_FINITE_ACCUMULATING_TRANSCRIPT_CHAIN_RULE_DERIVATION"

end URF

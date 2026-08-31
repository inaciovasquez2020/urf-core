import URF.Foundation.AccumulatingTranscriptHistory
import URF.Foundation.FiniteMutualInformationChainRuleProof

namespace URF

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

def InitialStateNeutralAccumulatingTranscriptBridge.status : String :=
  "INITIAL_STATE_NEUTRAL_ACCUMULATING_TRANSCRIPT_BRIDGE_INTERFACE_ONLY"

def InitialStateNeutralAccumulatingTranscriptBridge.nextAdmissibleObject : String :=
  "PROBABILITY_THEORETIC_FINITE_ACCUMULATING_TRANSCRIPT_CHAIN_RULE_DERIVATION"

end URF

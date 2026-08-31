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

/--
The finite residual-uncertainty depth of an accumulating transcript is bounded
by horizon times a uniform local information capacity.  Here the depth summand
is the exact conditional-entropy drop about the fixed target `X`; by the
probability-derived one-step identity, each such drop equals the local CMI.
This is the formal finite replacement for the simulation inequality on this
residual-uncertainty surface, not a theorem about an arbitrary evolving
configuration entropy.
-/
theorem finite_accumulating_transcript_residual_uncertainty_depth_le_horizon_mul_capacity
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (C : ℝ)
    (hcap : ∀ t : Nat, t < history.horizon →
      finiteConditionalMutualInformation
        M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤ C) :
    ∑ t in Finset.range history.horizon,
        (URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S t) -
          URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S (t + 1))) ≤
      (history.horizon : ℝ) * C := by
  calc
    ∑ t in Finset.range history.horizon,
        (URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S t) -
          URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S (t + 1))) =
      ∑ t in Finset.range history.horizon,
        finiteConditionalMutualInformation
          M.sampleLaw M.X (M.S (t + 1)) (M.S t) := by
        apply Finset.sum_congr rfl
        intro t ht
        exact finite_accumulating_transcript_conditional_entropy_drop_eq_local_cmi
          M t (Finset.mem_range.mp ht)
    _ ≤ ∑ _t in Finset.range history.horizon, C := by
      apply Finset.sum_le_sum
      intro t ht
      exact hcap t (Finset.mem_range.mp ht)
    _ = (history.horizon : ℝ) * C := by
      simp

/--
When the uniform local information capacity is strictly positive, the finite
residual-uncertainty depth yields a lower bound on the transcript horizon.
This is the direct quotient form of the preceding capacity bound and remains
restricted to conditional-entropy loss about the fixed target `X`.
-/
theorem finite_accumulating_transcript_residual_uncertainty_depth_div_capacity_le_horizon
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (C : ℝ) (hC : 0 < C)
    (hcap : ∀ t : Nat, t < history.horizon →
      finiteConditionalMutualInformation
        M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤ C) :
    (∑ t in Finset.range history.horizon,
        (URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S t) -
          URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
            M.sampleLaw M.X (M.S (t + 1)))) / C ≤
      (history.horizon : ℝ) := by
  apply (div_le_iff₀ hC).2
  exact finite_accumulating_transcript_residual_uncertainty_depth_le_horizon_mul_capacity
    M C hcap

/--
If an initially neutral accumulating transcript leaves zero residual uncertainty
about the target at the terminal snapshot, then a positive uniform local
information capacity forces the transcript horizon to be at least target
entropy divided by that capacity.  Terminal zero conditional entropy is kept as
an explicit hypothesis; no operational correctness theorem is assumed here.
-/
theorem finite_accumulating_transcript_target_entropy_div_capacity_le_horizon_of_initial_neutral_terminal_zero
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (C : ℝ) (hC : 0 < C)
    (h0 : finiteMutualInformation M.sampleLaw M.X (M.S 0) = 0)
    (hterminal :
      URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy
        M.sampleLaw M.X (M.S history.horizon) = 0)
    (hcap : ∀ t : Nat, t < history.horizon →
      finiteConditionalMutualInformation
        M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤ C) :
    URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
        M.sampleLaw M.X / C ≤
      (history.horizon : ℝ) := by
  have hterminalInformation :
      finiteMutualInformation M.sampleLaw M.X (M.S history.horizon) =
        URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
          M.sampleLaw M.X := by
    simp only [
      finiteMutualInformation_eq_entropies,
      URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy_eq_entropies]
      at hterminal ⊢
    linarith
  have hle :=
    finite_accumulating_transcript_terminal_information_le_horizon_mul_capacity_of_initial_neutral
      M C h0 hcap
  rw [hterminalInformation] at hle
  exact (div_le_iff₀ hC).2 hle

/--
If the target is explicitly recoverable from the terminal snapshot, then the
terminal conditional entropy vanishes by the general recoverability lemma.
Consequently an initially neutral accumulating transcript with positive uniform
local information capacity has horizon at least target entropy divided by that
capacity.  The decoder equation is the only terminal-correctness hypothesis.
-/
theorem finite_accumulating_transcript_target_entropy_div_capacity_le_horizon_of_terminal_decoder
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (C : ℝ) (hC : 0 < C)
    (h0 : finiteMutualInformation M.sampleLaw M.X (M.S 0) = 0)
    (decode : history.Snapshot → XValue)
    (hdecode : ∀ ω : history.Sample, decode (M.S history.horizon ω) = M.X ω)
    (hcap : ∀ t : Nat, t < history.horizon →
      finiteConditionalMutualInformation
        M.sampleLaw M.X (M.S (t + 1)) (M.S t) ≤ C) :
    URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
        M.sampleLaw M.X / C ≤
      (history.horizon : ℝ) := by
  have hterminal :=
    URF.Foundation.FiniteConditionalEntropyDefinition.finiteConditionalEntropy_eq_zero_of_recoverable
      M.sampleLaw M.X (M.S history.horizon) decode hdecode
  exact
    finite_accumulating_transcript_target_entropy_div_capacity_le_horizon_of_initial_neutral_terminal_zero
      M C hC h0 hterminal hcap

def InitialStateNeutralAccumulatingTranscriptBridge.status : String :=
  "INITIAL_STATE_NEUTRAL_ACCUMULATING_TRANSCRIPT_BRIDGE_INTERFACE_ONLY"

def InitialStateNeutralAccumulatingTranscriptBridge.nextAdmissibleObject : String :=
  "PROBABILITY_THEORETIC_FINITE_ACCUMULATING_TRANSCRIPT_CHAIN_RULE_DERIVATION"

end URF
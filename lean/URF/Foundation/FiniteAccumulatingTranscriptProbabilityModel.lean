import URF.Foundation.AccumulatingTranscriptHistory
import URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

namespace URF

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem

universe u

/--
A finite probability/random-variable carrier for an accumulating transcript
history. The sample law reuses the repository-native `FinDistribution`; `X` is
a finite-valued random variable on that sample space, and `S t` is exactly the
existing accumulating transcript state at time `t`.

This object does not define entropy, mutual information, conditional mutual
information, or prove any information-theoretic chain rule.
-/
structure FiniteAccumulatingTranscriptProbabilityModel
    (history : AccumulatingTranscriptHistory)
    (XValue : Type u)
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot] where
  sampleLaw : FinDistribution history.Sample
  X : history.Sample → XValue

/-- The transcript-state random variable at time `t`. -/
def FiniteAccumulatingTranscriptProbabilityModel.S
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (_M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) : history.Sample → history.Snapshot :=
  history.state t

theorem FiniteAccumulatingTranscriptProbabilityModel.S_eq_history_state
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) :
    M.S t = history.state t := by
  rfl

theorem FiniteAccumulatingTranscriptProbabilityModel.S_recovers_previous
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) (ht : t < history.horizon) (ω : history.Sample) :
    history.recoverPrevious t (M.S (t + 1) ω) = M.S t ω := by
  simpa [FiniteAccumulatingTranscriptProbabilityModel.S] using
    history.recover_previous t ht ω

theorem FiniteAccumulatingTranscriptProbabilityModel.sample_law_nonnegative
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue) :
    ∀ ω : history.Sample, 0 ≤ M.sampleLaw.prob ω := by
  exact M.sampleLaw.nonnegative

theorem FiniteAccumulatingTranscriptProbabilityModel.sample_law_total_mass
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue) :
    Finset.univ.sum M.sampleLaw.prob = 1 := by
  exact M.sampleLaw.total_mass

def FiniteAccumulatingTranscriptProbabilityModel.status : String :=
  "FINITE_ACCUMULATING_TRANSCRIPT_PROBABILITY_RANDOM_VARIABLE_CARRIER_ONLY"

def FiniteAccumulatingTranscriptProbabilityModel.nextAdmissibleObject : String :=
  "FINITE_DISCRETE_ENTROPY_MUTUAL_INFORMATION_DEFINITIONS"

end URF

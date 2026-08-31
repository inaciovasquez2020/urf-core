import Mathlib.Data.Real.Basic
import URF.Foundation.FiniteMutualInformationDefinition
import URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction
import URF.Foundation.FiniteAccumulatingTranscriptProbabilityModel

namespace URF

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteMutualInformationDefinition
open URF.Foundation.FiniteConditionalEntropyDefinition
open URF.Foundation.FiniteConditionalMutualInformationDefinition
open URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction

universe u

structure FiniteMutualInformationChainRuleProof where
  T : Nat
  RandomVariable : Type
  X : Nat → RandomVariable
  Y : Nat → RandomVariable
  Z : Nat → RandomVariable
  finiteLocalSum : Nat → (Nat → ℝ) → ℝ
  totalMI : ℝ
  localCMIValue : Nat → ℝ
  cmi_nonneg : ∀ t : Nat, 0 ≤ localCMIValue t
  finite_chain_rule :
    totalMI = finiteLocalSum T localCMIValue
  capacity_bound_required : Prop
  global_kernel_required : Prop

theorem finite_mutual_information_chain_rule_proof
    (K : FiniteMutualInformationChainRuleProof) :
    K.totalMI = K.finiteLocalSum K.T K.localCMIValue :=
  K.finite_chain_rule

theorem finite_mutual_information_chain_rule_local_nonneg
    (K : FiniteMutualInformationChainRuleProof)
    (t : Nat) :
    0 ≤ K.localCMIValue t :=
  K.cmi_nonneg t

/--
Concrete one-step finite information chain rule derived directly from the
repository's probability-derived entropy definitions.  The pair-valued random
variable is `(Y,Z)`, matching the conditioning-pair convention used by
`finiteConditionalMutualInformation`.
-/
theorem finite_probability_derived_information_chain_rule
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteMutualInformation μ X (fun a => (Y a, Z a)) =
      finiteMutualInformation μ X Z +
        finiteConditionalMutualInformation μ X Y Z := by
  simp only [
    finiteMutualInformation_eq_entropies,
    finiteConditionalMutualInformation_eq_conditional_entropies,
    finiteConditionalEntropy_eq_entropies,
    pair_entropy_eq_joint_entropy]
  linarith

/--
The concrete one-step chain rule specialized to successive snapshots of the
repository-native finite accumulating transcript probability model.
-/
theorem finite_accumulating_transcript_paired_step_chain_rule
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) :
    finiteMutualInformation M.sampleLaw M.X
        (fun ω => (M.S (t + 1) ω, M.S t ω)) =
      finiteMutualInformation M.sampleLaw M.X (M.S t) +
        finiteConditionalMutualInformation M.sampleLaw M.X (M.S (t + 1)) (M.S t) := by
  exact finite_probability_derived_information_chain_rule
    M.sampleLaw M.X (M.S (t + 1)) (M.S t)

/--
Because an accumulating snapshot deterministically recovers its predecessor,
adding the previous snapshot to the next snapshot does not change its mutual
information with `X`.
-/
theorem finite_accumulating_transcript_paired_step_mutual_information_eq_next
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) (ht : t < history.horizon) :
    finiteMutualInformation M.sampleLaw M.X
        (fun ω => (M.S (t + 1) ω, M.S t ω)) =
      finiteMutualInformation M.sampleLaw M.X (M.S (t + 1)) := by
  have hSnapshot :
      URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
          M.sampleLaw (fun ω => (M.S (t + 1) ω, M.S t ω)) =
        URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
          M.sampleLaw (M.S (t + 1)) := by
    let f : history.Snapshot → history.Snapshot × history.Snapshot :=
      fun s => (s, history.recoverPrevious t s)
    have hf : Function.Injective f := by
      intro a b hab
      exact congrArg (fun z => z.1) hab
    have h :=
      URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy_comp_injective
        M.sampleLaw (M.S (t + 1)) f hf
    simpa [f, FiniteAccumulatingTranscriptProbabilityModel.S_recovers_previous M t ht] using h
  have hJoint :
      URF.Foundation.FiniteJointDistributionEntropy.finiteJointEntropy
          M.sampleLaw M.X (fun ω => (M.S (t + 1) ω, M.S t ω)) =
        URF.Foundation.FiniteJointDistributionEntropy.finiteJointEntropy
          M.sampleLaw M.X (M.S (t + 1)) := by
    let g : XValue × history.Snapshot →
        XValue × (history.Snapshot × history.Snapshot) :=
      fun z => (z.1, (z.2, history.recoverPrevious t z.2))
    have hg : Function.Injective g := by
      intro a b hab
      apply Prod.ext
      · exact congrArg (fun z => z.1) hab
      · exact congrArg (fun z => z.2.1) hab
    change
      URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
          M.sampleLaw (fun ω => (M.X ω, (M.S (t + 1) ω, M.S t ω))) =
        URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy
          M.sampleLaw (fun ω => (M.X ω, M.S (t + 1) ω))
    have h :=
      URF.Foundation.FiniteDiscreteShannonEntropy.finiteRandomVariableEntropy_comp_injective
        M.sampleLaw (fun ω => (M.X ω, M.S (t + 1) ω)) g hg
    simpa [g, FiniteAccumulatingTranscriptProbabilityModel.S_recovers_previous M t ht] using h
  simp only [finiteMutualInformation_eq_entropies, hSnapshot, hJoint]

/--
For an accumulating transcript, each one-step mutual-information increment is
exactly the conditional mutual information revealed by the next snapshot.
-/
theorem finite_accumulating_transcript_step_chain_rule
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (t : Nat) (ht : t < history.horizon) :
    finiteMutualInformation M.sampleLaw M.X (M.S (t + 1)) =
      finiteMutualInformation M.sampleLaw M.X (M.S t) +
        finiteConditionalMutualInformation M.sampleLaw M.X (M.S (t + 1)) (M.S t) := by
  calc
    finiteMutualInformation M.sampleLaw M.X (M.S (t + 1)) =
        finiteMutualInformation M.sampleLaw M.X
          (fun ω => (M.S (t + 1) ω, M.S t ω)) :=
      (finite_accumulating_transcript_paired_step_mutual_information_eq_next M t ht).symm
    _ = finiteMutualInformation M.sampleLaw M.X (M.S t) +
        finiteConditionalMutualInformation M.sampleLaw M.X (M.S (t + 1)) (M.S t) :=
      finite_accumulating_transcript_paired_step_chain_rule M t

/--
Finite telescoping of the accumulating-transcript information increments.
At every time `n` within the history horizon, the information in the current
snapshot is the initial information plus the sum of the local conditional
mutual-information increments revealed at steps `0, ..., n-1`.
-/
theorem finite_accumulating_transcript_information_telescope
    {history : AccumulatingTranscriptHistory}
    {XValue : Type u}
    [DecidableEq history.Sample] [Fintype history.Sample]
    [DecidableEq XValue] [Fintype XValue]
    [DecidableEq history.Snapshot] [Fintype history.Snapshot]
    (M : FiniteAccumulatingTranscriptProbabilityModel history XValue)
    (n : Nat) (hn : n ≤ history.horizon) :
    finiteMutualInformation M.sampleLaw M.X (M.S n) =
      finiteMutualInformation M.sampleLaw M.X (M.S 0) +
        ∑ t in Finset.range n,
          finiteConditionalMutualInformation
            M.sampleLaw M.X (M.S (t + 1)) (M.S t) := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      have hnlt : n < history.horizon := Nat.lt_of_succ_le hn
      have hnle : n ≤ history.horizon := Nat.le_trans (Nat.le_succ n) hn
      rw [finite_accumulating_transcript_step_chain_rule M n hnlt]
      rw [ih hnle]
      rw [Finset.sum_range_succ]
      ring

def FiniteMutualInformationChainRuleProof.status : String :=
  "FINITE_PROBABILITY_DERIVED_INFORMATION_CHAIN_RULE_PROVED_ALONGSIDE_LEGACY_INTERFACE"

def FiniteMutualInformationChainRuleProof.nextAdmissibleObject : String :=
  "FINITE_ACCUMULATING_TRANSCRIPT_TELESCOPING_THEOREM"

end URF

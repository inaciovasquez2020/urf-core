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

def FiniteMutualInformationChainRuleProof.status : String :=
  "FINITE_PROBABILITY_DERIVED_INFORMATION_CHAIN_RULE_PROVED_ALONGSIDE_LEGACY_INTERFACE"

def FiniteMutualInformationChainRuleProof.nextAdmissibleObject : String :=
  "FINITE_ACCUMULATING_TRANSCRIPT_TELESCOPING_THEOREM"

end URF

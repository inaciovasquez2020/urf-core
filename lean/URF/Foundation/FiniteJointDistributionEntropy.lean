import URF.Foundation.FiniteDiscreteShannonEntropy

namespace URF.Foundation.FiniteJointDistributionEntropy

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteRandomVariablePushforward
open URF.Foundation.FiniteDiscreteShannonEntropy

universe u

/-- Pair-valued random variable associated to two finite random variables. -/
def jointRandomVariable
    {α β γ : Type u}
    (X : α → β) (Y : α → γ) : α → β × γ :=
  fun a => (X a, Y a)

/-- Joint probability mass function of two finite random variables. -/
def finiteJointProb
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) : β × γ → ℝ :=
  finiteRandomVariablePushProb μ (jointRandomVariable X Y)

/-- The joint mass at `(b,c)` is the mass of the common preimage. -/
theorem finiteJointProb_eq_preimage_sum
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ)
    (b : β) (c : γ) :
    finiteJointProb μ X Y (b, c) =
      Finset.univ.sum (fun a => if X a = b ∧ Y a = c then μ.prob a else 0) := by
  simpa [finiteJointProb, jointRandomVariable] using
    (finiteRandomVariablePushProb_eq_preimage_sum
      μ (jointRandomVariable X Y) (b, c))

/-- Joint masses are nonnegative. -/
theorem finiteJointProb_nonnegative
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    ∀ z : β × γ, 0 ≤ finiteJointProb μ X Y z := by
  exact finiteRandomVariablePushProb_nonnegative μ (jointRandomVariable X Y)

/-- The total joint mass is one. -/
theorem finiteJointProb_total_mass
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    Finset.univ.sum (finiteJointProb μ X Y) = 1 := by
  exact finiteRandomVariablePushProb_total_mass μ (jointRandomVariable X Y)

/-- Bundled joint distribution of two finite random variables. -/
def finiteJointDistribution
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) : FinDistribution (β × γ) :=
  finiteRandomVariablePushDistribution μ (jointRandomVariable X Y)

theorem finiteJointDistribution_prob
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ)
    (z : β × γ) :
    (finiteJointDistribution μ X Y).prob z = finiteJointProb μ X Y z := by
  rfl

/-- Joint Shannon entropy `H(X,Y)` in nats. -/
def finiteJointEntropy
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) : ℝ :=
  finiteShannonEntropy (finiteJointDistribution μ X Y)

/-- A zero-probability joint atom contributes exactly zero to joint entropy. -/
theorem zero_joint_probability_atom_contributes_zero
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ)
    (z : β × γ) (hz : finiteJointProb μ X Y z = 0) :
    shannonTerm ((finiteJointDistribution μ X Y).prob z) = 0 := by
  rw [finiteJointDistribution_prob]
  exact shannonTerm_of_eq_zero (finiteJointProb μ X Y z) hz

def status : String :=
  "FINITE_JOINT_DISTRIBUTION_AND_JOINT_ENTROPY_DERIVED"

def nextAdmissibleObject : String :=
  "FINITE_MUTUAL_INFORMATION_DEFINITION_FROM_ENTROPIES"

end URF.Foundation.FiniteJointDistributionEntropy

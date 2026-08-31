import Mathlib.Analysis.SpecialFunctions.Log.Basic
import URF.Foundation.FiniteRandomVariablePushforward

namespace URF.Foundation.FiniteDiscreteShannonEntropy

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteRandomVariablePushforward

universe u

/--
The zero-safe Shannon summand `-p log p`, using natural logarithms.
The `p = 0` branch is defined to be zero explicitly.
-/
def shannonTerm (p : ℝ) : ℝ :=
  if p = 0 then 0 else -(p * Real.log p)

theorem shannonTerm_zero : shannonTerm 0 = 0 := by
  simp [shannonTerm]

theorem shannonTerm_of_eq_zero (p : ℝ) (hp : p = 0) :
    shannonTerm p = 0 := by
  simp [shannonTerm, hp]

/-- Finite Shannon entropy of a repository-native finite distribution. -/
def finiteShannonEntropy
    {α : Type u}
    [DecidableEq α] [Fintype α]
    (μ : FinDistribution α) : ℝ :=
  Finset.univ.sum (fun a => shannonTerm (μ.prob a))

/-- A zero-probability atom contributes exactly zero to finite Shannon entropy. -/
theorem zero_probability_atom_contributes_zero
    {α : Type u}
    [DecidableEq α] [Fintype α]
    (μ : FinDistribution α) (a : α)
    (ha : μ.prob a = 0) :
    shannonTerm (μ.prob a) = 0 := by
  exact shannonTerm_of_eq_zero (μ.prob a) ha

/-- Shannon entropy of a finite random variable via its verified pushforward law. -/
def finiteRandomVariableEntropy
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) : ℝ :=
  finiteShannonEntropy (finiteRandomVariablePushDistribution μ X)

def status : String :=
  "FINITE_DISCRETE_SHANNON_ENTROPY_DEFINITION_ZERO_SAFE"

def nextAdmissibleObject : String :=
  "FINITE_JOINT_DISTRIBUTION_AND_JOINT_ENTROPY"

end URF.Foundation.FiniteDiscreteShannonEntropy

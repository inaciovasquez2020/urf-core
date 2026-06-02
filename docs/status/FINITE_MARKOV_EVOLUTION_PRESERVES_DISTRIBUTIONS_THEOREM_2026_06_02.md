# Finite Markov Evolution Preserves Distributions Theorem — 2026-06-02

## Field

Finite stochastic systems / finite Markov processes.

## Closed object

`FiniteMarkovEvolutionPreservesDistributionsTheorem`

## Unconditional theorem surface

A finite probability distribution evolved through a finite stochastic kernel remains a finite probability distribution.

The evolved probabilities are nonnegative, and the evolved total mass is equal to `1`.

## Lean definitions

- `FinDistribution`
- `pushProb`
- `pushDistribution`

## Lean theorems

- `finite_markov_evolution_nonnegative`
- `finite_markov_evolution_total_mass`
- `finite_markov_evolution_preserves_probability_distribution`

## Boundary

This closes only a bounded finite-state Markov-evolution theorem.

It does not close:

- unrestricted URF law closure
- empirical gravity validation
- plasma physics
- Hodge theory
- P vs NP
- any Clay problem

## Next admissible object

`MergeFiniteMarkovEvolutionPreservesDistributionsTheoremOrStop`

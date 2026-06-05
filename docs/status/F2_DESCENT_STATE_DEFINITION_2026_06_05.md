# F₂ Descent State Definition — 2026-06-05

## Status

`F2DescentState` is now registered as the concrete F₂ matrix-state carrier needed before defining the bridge map from abstract configurations.

## Closed object

`F2DescentStateDefinition`

## Definition role

The structure stores:

- an F₂ matrix
- a rank field

This supplies the missing codomain for the target map:

```lean
Configuration α → F2DescentState n m
Boundary
This does not close:
ConcretePhiDefinitionUsingExtractRMatrix
ConcreteRankAgreement
AbstractStepRealizesCanonicalF2Pivot
DescentSystem.step_rank_drop
DescentSystem.zero_rank_reached_within_rank
F2DescentTerminatesFullIteration
Chronos-RR
H4.1/FGL
P vs NP
any Clay problem
Next admissible object
ConcretePhiDefinitionUsingExtractRMatrix

# Concrete Phi Using extractRMatrix Target — 2026-06-05

Status: TARGET_REGISTERED_NOT_PROVED

Closed object:

- `ConcretePhiTargetRegistrationOnly`

This records the next admissible bridge object after PR #375.

## Target

Define a concrete representation map

\[
\phi : Configuration\ \alpha \to F2DescentState\ n\ m
\]

using the existing `SupportEncoding` / `extractRMatrix` layer.

## Current repository state

`DescentSystem.lean` is not definitionally matrix-shaped.

The abstract layer contains:

- `Configuration α`
- `DescentSystem α`
- `step`
- `nstep`
- `terminal`
- `rank`

The matrix bridge layer contains:

- `SupportEncoding`
- `extractRMatrix`
- `ClosedKernelData`
- `ExtractRData`
- `pivot_family`
- `canonical_edge_separation`
- `greedy_pivot_separation`
- `identity_submatrix_construction`
- `full_rank_from_identity`

## Required obligations

### O1. ConcretePhiDefinition

Define `φ` explicitly.

### O2. ConcreteRankAgreement

\[
\forall C,\quad C.rank = descentRank(\phi C).
\]

### O3. AbstractStepRealizesCanonicalF2Pivot

\[
\forall C,\ \neg terminal(C) \to
\exists j\ p\ hj\ hp,\
\phi(D.step\ C)=applyPivot(\phi C)\ j\ p\ hj\ hp.
\]

## Consequence if closed

If O1--O3 are closed, then the bridge can transfer the F2 strict pivot-drop theorem back to the abstract `DescentSystem` layer.

Conditional consequences:

- `step_rank_drop_from_bridge`
- `zero_rank_reached_within_rank_from_bridge`

## Boundary

This target registration does not close:

- `F2DescentTerminatesFullIteration`
- `DescentSystem.step_rank_drop`
- `DescentSystem.zero_rank_reached_within_rank`
- Chronos-RR
- H4.1/FGL
- P vs NP
- any Clay problem

## Minimal missing object

`ConcretePhiDefinitionUsingExtractRMatrix`

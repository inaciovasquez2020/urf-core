# URF Prefab System

Prefab modules for the Universal Rigidity Framework (URF).

The prefab system provides reusable structural components that can be composed
into URF admissibility and normalization pipelines.

A prefab represents a canonical construction with:

- defined inputs
- admissibility constraints
- normalization invariants
- verification procedure

The goal is to standardize common URF constructions so they can be reused
across multiple URF modules and proofs.

## Prefab Definition

A prefab P is defined by

P = (I, C, N, V)

I  input schema  
C  admissibility constraints  
N  normalization map  
V  verification procedure

## Repository Structure

src/prefab/
implementation of prefab objects

docs/
formal specification of prefab structures

tests/
validation of prefab normalization and admissibility

examples/
example prefab constructions

## Example Prefab

Normalization prefab

Input:
  object X

Normalization:
  N(X) → canonical representative

Constraint:
  X ~ Y  ⇒  N(X) = N(Y)

Verification:
  check admissibility and canonical form

## Relation to URF Core

Prefab modules are used by

- urf-core
- urf-verifier
- urf-spine

to provide reusable building blocks for URF constructions.

## License

MIT

# Prefab Specification

A prefab is a reusable URF construction defined by

P = (I, C, N, V)

I : input schema
C : admissibility constraints
N : normalization map
V : verification predicate

Correctness condition

V(X) = True ⇒ N(X) is canonical.

Composition rule

P₂ ∘ P₁ is admissible if

N₂(N₁(X)) is well-defined.

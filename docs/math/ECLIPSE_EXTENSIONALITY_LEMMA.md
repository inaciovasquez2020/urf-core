# Eclipse Extensionality Lemma

## Status
Conditional.

## Target
\[
\forall \mathcal P,\forall \mathcal Q,\quad
\Big(
\operatorname{CoreClaims}(\mathcal P)=\operatorname{CoreClaims}(\mathcal Q)
\wedge
\operatorname{StatusMap}(\mathcal P)=\operatorname{StatusMap}(\mathcal Q)
\wedge
\operatorname{DependencyGraph}(\mathcal P)\cong \operatorname{DependencyGraph}(\mathcal Q)
\Big)
\Rightarrow
\Big(
\operatorname{Eclipse}(\mathcal P)\iff \operatorname{Eclipse}(\mathcal Q)
\Big).
\]

## Role
This is the certified bridge reducing global Eclipse to extensional invariants.

## Terminal missing object
A proof that Eclipse depends only on core claims, status map, and dependency graph up to isomorphism.

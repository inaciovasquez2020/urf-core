# Eclipse Extensionality Certified

## Status

Conditional.

## Target

\[
\forall \mathcal P,\forall \mathcal Q,\quad
\Big(
\operatorname{CoreClaims}(\mathcal P)=\operatorname{CoreClaims}(\mathcal Q)\wedge
\operatorname{StatusMap}(\mathcal P)=\operatorname{StatusMap}(\mathcal Q)\wedge
\operatorname{DependencyGraph}(\mathcal P)\cong \operatorname{DependencyGraph}(\mathcal Q)
\Big)
\Rightarrow
\bigl(
\operatorname{Eclipse}(\mathcal P)\iff \operatorname{Eclipse}(\mathcal Q)
\bigr).
\]

## Inputs

\[
\operatorname{Eclipse}(\mathcal P)
\text{ depends only on }
\bigl(
\operatorname{CoreClaims}(\mathcal P),
\operatorname{StatusMap}(\mathcal P),
\operatorname{DependencyGraph}(\mathcal P)
\bigr).
\]

\[
\operatorname{Eclipse}(\mathcal Q)
\text{ depends only on }
\bigl(
\operatorname{CoreClaims}(\mathcal Q),
\operatorname{StatusMap}(\mathcal Q),
\operatorname{DependencyGraph}(\mathcal Q)
\bigr).
\]

## Reduction

\[
\operatorname{CoreClaims}(\mathcal P)=\operatorname{CoreClaims}(\mathcal Q).
\]

\[
\operatorname{StatusMap}(\mathcal P)=\operatorname{StatusMap}(\mathcal Q).
\]

\[
\operatorname{DependencyGraph}(\mathcal P)\cong \operatorname{DependencyGraph}(\mathcal Q).
\]

\[
\bigl(
\operatorname{CoreClaims}(\mathcal P),
\operatorname{StatusMap}(\mathcal P),
\operatorname{DependencyGraph}(\mathcal P)
\bigr)
=
\bigl(
\operatorname{CoreClaims}(\mathcal Q),
\operatorname{StatusMap}(\mathcal Q),
\operatorname{DependencyGraph}(\mathcal Q)
\bigr)
\text{ up to dependency-graph isomorphism.}
\]

\[
\operatorname{Eclipse}(\mathcal P)\iff \operatorname{Eclipse}(\mathcal Q).
\]

## Role

This is Part \(12\) in the Eclipse assembly chain.

## Terminal missing object

A certified proof that Eclipse is presentation-invariant and depends only on core claims, status map, and dependency graph up to isomorphism.

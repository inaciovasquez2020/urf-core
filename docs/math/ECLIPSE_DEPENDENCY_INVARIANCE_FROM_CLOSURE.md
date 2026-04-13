# Eclipse Dependency Invariance from Closure

## Status

Conditional.

## Target

\[
\operatorname{DependencyClosed}(\mathcal P_0)
\Rightarrow
\operatorname{DependencyInvariant}_A(\mathcal P_0).
\]

## Input

\[
\operatorname{DependencyClosed}(\mathcal P_0)
\iff
\forall k\in K_0,\quad
\operatorname{Pred}_{D_0}(k)\subseteq K_0.
\]

\[
\operatorname{DependencyClosed}(\mathcal P_0)
\Rightarrow
\text{every dependency edge of }D_0\text{ has both endpoints in }K_0.
\]

## Reduction

\[
\forall a\in A,\quad
\operatorname{CoreClaims}(a(\mathcal P_0))=K_0
\Rightarrow
\operatorname{Pred}_{D_{a(\mathcal P_0)}}(k)\subseteq K_0
\text{ for all }k\in K_0.
\]

\[
\forall a\in A,\quad
\operatorname{Pred}_{D_{a(\mathcal P_0)}}(k)\subseteq K_0
\text{ for all }k\in K_0
\Rightarrow
\operatorname{DependencyGraph}(a(\mathcal P_0))\cong D_0.
\]

\[
\forall a\in A,\quad
\operatorname{DependencyGraph}(a(\mathcal P_0))\cong D_0
\Rightarrow
\operatorname{DependencyInvariant}_A(\mathcal P_0).
\]

## Role

This is Part \(9\) in the Eclipse assembly chain.

## Terminal missing object

A certified proof that dependency closure blocks hidden-predecessor drift under admissible adversaries and forces preservation of the dependency graph up to isomorphism.

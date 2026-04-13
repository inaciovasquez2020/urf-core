# Eclipse Dependency Closure Instance

## Status
Conditional.

## Instance
Let \(\mathcal P_0=(K_0,S_0,D_0,W_0)\) be the witness instance from `docs/math/ECLIPSE_WITNESS_INSTANCE.md`.

## Target
\[
\operatorname{DependencyClosed}(\mathcal P_0).
\]

## Certification form
For every claim \(k\in K_0\),
\[
\operatorname{Pred}_{D_0}(k)\subseteq K_0.
\]

Equivalently, every dependency edge of \(D_0\) has both source and target in \(K_0\), and every status assignment in \(S_0\) is defined on all dependency predecessors required by \(D_0\).

## Terminal missing object
A certified proof that \(D_0\) is internally closed on \(K_0\) and fully covered by \(S_0\).

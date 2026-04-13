# Eclipse External Reproducibility Instance

## Status
Conditional.

## Instance
Let \(\mathcal P_0=(K_0,S_0,D_0,W_0)\) be the witness instance from `docs/math/ECLIPSE_WITNESS_INSTANCE.md`.

## Target
\[
\operatorname{ExternalReproducible}(\mathcal P_0).
\]

## Certification form
For every external reconstruction procedure \(R\) admissible under the canonical adversary class,
\[
R(W_0)=(K_0,S_0,D_0).
\]

Equivalently,
\[
\operatorname{CoreClaims}(R(W_0))=K_0,
\]
\[
\operatorname{StatusMap}(R(W_0))=S_0,
\]
\[
\operatorname{DependencyGraph}(R(W_0))=D_0.
\]

## Terminal missing object
A certified reconstruction map on \(W_0\) recovering \((K_0,S_0,D_0)\).

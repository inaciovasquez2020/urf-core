# Eclipse Reconstruction Stability from External Reproducibility

## Status

Conditional.

## Target

\[
\operatorname{ExternalReproducible}(\mathcal P_0)
\Rightarrow
\operatorname{ReconstructionStable}_A(\mathcal P_0).
\]

## Input

\[
\operatorname{ExternalReproducible}(\mathcal P_0)
\iff
\forall R\in\mathcal R_A,\quad
R(W_0)=(K_0,S_0,D_0).
\]

## Reduction

\[
\forall a\in A,\quad
a(\mathcal P_0)
\text{ factors through an admissible reconstruction }R_a\in\mathcal R_A.
\]

\[
R_a(W_0)=(K_0,S_0,D_0)
\Rightarrow
\operatorname{CoreClaims}(a(\mathcal P_0))=K_0.
\]

\[
R_a(W_0)=(K_0,S_0,D_0)
\Rightarrow
\operatorname{StatusMap}(a(\mathcal P_0))=S_0.
\]

\[
R_a(W_0)=(K_0,S_0,D_0)
\Rightarrow
\operatorname{DependencyGraph}(a(\mathcal P_0))\cong D_0.
\]

\[
\forall a\in A,\quad
a(\mathcal P_0)\cong \mathcal P_0
\Rightarrow
\operatorname{ReconstructionStable}_A(\mathcal P_0).
\]

## Role

This is Part \(8\) in the Eclipse assembly chain.

## Terminal missing object

A certified factorization of every admissible adversary through an admissible reconstruction, followed by extensional identification with \(\mathcal P_0\).

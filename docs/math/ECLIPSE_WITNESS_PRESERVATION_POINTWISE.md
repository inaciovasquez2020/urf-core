# Eclipse Witness Preservation Pointwise

## Status

Conditional.

## Target

\[
\forall a\in A,\forall k\in K_0,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k).
\]

## Role

This is Part \(2a\) in the Eclipse status-invariance bottleneck.

## Consequence

\[
\forall a\in A,\forall k\in K_0,\forall S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\operatorname{CertifiesStatus}(\operatorname{WitnessSet}(a(\mathcal P_0))(k),S,k)
\iff
\operatorname{CertifiesStatus}(W_0(k),S,k).
\]

## Terminal missing object

A certified claim-by-claim witness identity proof under admissible adversaries.

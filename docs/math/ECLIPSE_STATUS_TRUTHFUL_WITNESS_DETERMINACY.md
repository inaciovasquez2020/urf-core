# Eclipse Status Truthful Witness Determinacy

## Status

Conditional.

## Target

\[
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\forall k\in K_0,\quad
W_0(k)\text{ determines }S_0(k).
\]

## Definition

\[
\operatorname{StatusTruthful}(\mathcal P_0)
\iff
\forall k\in K_0,\quad
\operatorname{CertifiesStatus}(W_0(k),S_0(k),k).
\]

## Reduction

\[
\forall k\in K_0,\quad
\operatorname{CertifiesStatus}(W_0(k),S_0(k),k).
\]

\[
\forall k\in K_0,\forall S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\operatorname{CertifiesStatus}(W_0(k),S,k)
\Rightarrow
S=S_0(k).
\]

## Consequence

\[
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\forall k\in K_0,\forall S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\operatorname{CertifiesStatus}(W_0(k),S,k)
\iff
S=S_0(k).
\]

## Role

This is Part \(3b\) in the Eclipse status-invariance bridge.

## Terminal missing object

A certified derivation from truthful status assignment plus witness-status uniqueness to exact witness-determined status for each claim.

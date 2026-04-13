# Eclipse Status Invariance Bridge Composition

## Status

Conditional.

## Target

\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{StatusMap}(a(\mathcal P_0))=\operatorname{StatusMap}(\mathcal P_0)
\quad
\forall a\in A.
\]

## Inputs

\[
\operatorname{AuditStable}(\mathcal P_0)
\Rightarrow
\forall a\in A,\forall k\in K_0,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k).
\]

\[
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\forall k\in K_0,\forall S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\operatorname{CertifiesStatus}(W_0(k),S,k)\iff S=S_0(k).
\]

\[
\forall a\in A,\forall k\in K_0,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

## Reduction

\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\forall a\in A,\forall k\in K_0,\quad
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

\[
\forall a\in A,\forall k\in K_0,\quad
S_{a(\mathcal P_0)}(k)=S_0(k)
\Rightarrow
\operatorname{StatusMap}(a(\mathcal P_0))=\operatorname{StatusMap}(\mathcal P_0).
\]

## Role

This is Part \(3c\) in the Eclipse status-invariance bridge.

## Terminal missing object

A certified composition from audit-stable witness preservation and truthful witness determinacy to full status-map equality under admissible adversaries.

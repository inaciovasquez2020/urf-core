# Eclipse Status Invariance Bridge Certified

## Status

Conditional.

## Target

\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
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

## Reduction

\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\forall a\in A,\quad
\operatorname{StatusMap}(a(\mathcal P_0))=\operatorname{StatusMap}(\mathcal P_0).
\]

\[
\forall a\in A,\quad
\operatorname{StatusMap}(a(\mathcal P_0))=\operatorname{StatusMap}(\mathcal P_0)
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
\]

## Role

This is the assembled certified bridge from Parts \(3a\), \(3b\), and \(3c\).

## Terminal missing object

A certified proof replacing the conditional bridge assembly by a theorem-level derivation from audit-stable witness extraction and truthful witness determinacy.

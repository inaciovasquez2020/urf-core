# Eclipse Audit Witness Extraction

## Status

Conditional.

## Target

\[
\operatorname{AuditStable}(\mathcal P_0)
\Rightarrow
\forall a\in A,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))=W_0.
\]

## Definition

\[
\operatorname{AuditExtract}(a,\mathcal P_0)=(K_a,S_a,D_a,W_a).
\]

\[
\operatorname{AuditStable}(\mathcal P_0)
\iff
\forall a\in A,\quad
\operatorname{AuditExtract}(a,\mathcal P_0)=(K_0,S_0,D_0,W_0).
\]

## Reduction

\[
\operatorname{AuditExtract}(a,\mathcal P_0)=(K_0,S_0,D_0,W_0)
\Rightarrow
W_a=W_0.
\]

\[
W_a=\operatorname{WitnessSet}(a(\mathcal P_0)).
\]

\[
\forall a\in A,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))=W_0.
\]

## Claim-level form

\[
\operatorname{AuditStable}(\mathcal P_0)
\Rightarrow
\forall a\in A,\forall k\in K_0,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k).
\]

## Role

This is Part \(3a\) in the Eclipse status-invariance bridge.

## Terminal missing object

A certified projection argument from audit extraction equality to witness-set equality, globally and claim-by-claim.

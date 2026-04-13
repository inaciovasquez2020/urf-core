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

\[
\operatorname{StatusMap}(a(\mathcal P_0))=\operatorname{StatusMap}(\mathcal P_0)
\ \forall a\in A
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
\]

## Role

This is Part \(3\) in the Eclipse status-invariance bottleneck.

## Terminal missing object

A certified assembly from audit-stable witness preservation and truthful witness-determined status to full adversarial status invariance.

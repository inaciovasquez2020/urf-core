# Eclipse Audit Stability Instance

## Status
Conditional.

## Instance
Let \(\mathcal P_0=(K_0,S_0,D_0,W_0)\) be the witness instance from `docs/math/ECLIPSE_WITNESS_INSTANCE.md`.

## Target
\[
\operatorname{AuditStable}(\mathcal P_0).
\]

## Certification form
For every hostile audit procedure \(H\) admissible under the canonical adversary class,
\[
H(\mathcal P_0)\vdash (K_0,S_0,D_0,W_0).
\]

Equivalently,
\[
\operatorname{CoreClaims}(H(\mathcal P_0))=K_0,
\]
\[
\operatorname{StatusMap}(H(\mathcal P_0))=S_0,
\]
\[
\operatorname{DependencyGraph}(H(\mathcal P_0))=D_0,
\]
\[
\operatorname{WitnessSet}(H(\mathcal P_0))=W_0.
\]

## Terminal missing object
A certified hostile-audit procedure preserving \((K_0,S_0,D_0,W_0)\).

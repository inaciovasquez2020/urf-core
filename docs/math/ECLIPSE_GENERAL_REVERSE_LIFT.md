# Eclipse General Reverse Lift

## Status

Conditional.

## Target

\[
\forall \mathcal P,\quad
\Big(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Inputs

\[
\forall \mathcal P,\quad
\Big(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\Big)
\Rightarrow
\exists \mathcal Q,\quad
\operatorname{CanonicalWitnessInstance}(\mathcal Q)\wedge
\mathcal Q\sim_{\mathrm{ext}}\mathcal P.
\]

\[
\forall \mathcal Q,\quad
\operatorname{CanonicalWitnessInstance}(\mathcal Q)
\Rightarrow
\operatorname{Eclipse}(\mathcal Q).
\]

\[
\forall \mathcal P,\forall \mathcal Q,\quad
\mathcal Q\sim_{\mathrm{ext}}\mathcal P
\Rightarrow
\bigl(
\operatorname{Eclipse}(\mathcal Q)\iff \operatorname{Eclipse}(\mathcal P)
\bigr).
\]

## Reduction

\[
\mathcal Q\sim_{\mathrm{ext}}\mathcal P
\iff
\Big(
\operatorname{CoreClaims}(\mathcal Q)=\operatorname{CoreClaims}(\mathcal P)\wedge
\operatorname{StatusMap}(\mathcal Q)=\operatorname{StatusMap}(\mathcal P)\wedge
\operatorname{DependencyGraph}(\mathcal Q)\cong \operatorname{DependencyGraph}(\mathcal P)
\Big).
\]

\[
\operatorname{CanonicalWitnessInstance}(\mathcal Q)\wedge
\mathcal Q\sim_{\mathrm{ext}}\mathcal P\wedge
\operatorname{Eclipse}(\mathcal Q)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Role

This is Part \(13\) in the Eclipse equivalence chain.

## Terminal missing object

A certified reduction from arbitrary admissible \(\mathcal P\) to a canonical witness instance, followed by transfer of Eclipse through extensionality.

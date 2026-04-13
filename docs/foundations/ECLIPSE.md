# Eclipse

## Status
Conditional.

## Canonical placement
`urf-core/docs/foundations/ECLIPSE.md`

## Role
Cross-program meta-framework layer.

## Definition
**Eclipse** is the destruction-closure layer of the program.

A program \(\mathcal P\) satisfies **Eclipse** if its core status assignments remain invariant under hostile audit, deletion, reordering, and external reconstruction.

## Core objects
- \(A\): canonical adversary class
- \(\Pi\): preservation invariant under \(A\)
- \(W\): independent witness set external to self-asserted status
- \(R\): reconstruction map from frozen artifacts to each core claim
- \(C\): cross-repo consistency theorem

## Criterion
\[
\forall a\in A,\quad a(\mathcal P)\not\models \neg \Pi(\mathcal P)
\]
and
\[
\forall \text{ core claim }K,\quad W\vdash K \ \text{or}\ W\vdash \operatorname{Open}(K)
\]
and
\[
R(\text{artifacts})=\text{same frontier/state assignment}
\]
and
\[
C:\ \bigwedge_i \Pi_i \Rightarrow \Pi_{\mathrm{global}}.
\]

## Canonical theorem schema
\[
\operatorname{Eclipse}(\mathcal P)\Rightarrow
\bigl(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\bigr).
\]

## Placement rule
Mirror only in `urf-textbook` for exposition.

Do not place canonically in:
- `chronos-urf-rr`
- `clay-problem-lab`
- `ym-os-quantization`
- `pachner-invariant`

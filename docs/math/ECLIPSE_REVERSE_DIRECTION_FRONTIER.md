# Eclipse Reverse Direction Frontier

## Status
Conditional.

## Target
\[
\Big(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Canonical adversary class
Let \(A\) contain the following operations on the artifact system \(\mathcal P\):
- deletion of non-core artifacts,
- reordering of artifacts,
- hostile audit of status claims,
- external reconstruction from frozen artifacts.

## Minimal split
### Lemma 1
\[
\operatorname{ExternalReproducible}(\mathcal P)\Rightarrow \operatorname{ReconstructionStable}_A(\mathcal P).
\]

### Lemma 2
\[
\operatorname{AuditStable}(\mathcal P)\wedge \operatorname{StatusTruthful}(\mathcal P)\Rightarrow \operatorname{StatusInvariant}_A(\mathcal P).
\]

### Lemma 3
\[
\operatorname{DependencyClosed}(\mathcal P)\Rightarrow \operatorname{DependencyInvariant}_A(\mathcal P).
\]

### Assembly
\[
\operatorname{ReconstructionStable}_A(\mathcal P)\wedge
\operatorname{StatusInvariant}_A(\mathcal P)\wedge
\operatorname{DependencyInvariant}_A(\mathcal P)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Terminal missing object
Assembly under the canonical adversary class \(A\).

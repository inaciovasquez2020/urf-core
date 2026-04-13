# Eclipse Preservation Theorem

## Status
Conditional.

## Statement
Let \(\mathcal P\) be a program-level artifact system.

Define:
- \(\operatorname{ExternalReproducible}(\mathcal P)\)
- \(\operatorname{AuditStable}(\mathcal P)\)
- \(\operatorname{DependencyClosed}(\mathcal P)\)
- \(\operatorname{StatusTruthful}(\mathcal P)\)

Then the target theorem is
\[
\operatorname{Eclipse}(\mathcal P)
\iff
\Big(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\Big).
\]

## Frontier split
### Forward direction
\[
\operatorname{Eclipse}(\mathcal P)\Rightarrow
\Big(
\operatorname{ExternalReproducible}(\mathcal P)\wedge
\operatorname{AuditStable}(\mathcal P)\wedge
\operatorname{DependencyClosed}(\mathcal P)\wedge
\operatorname{StatusTruthful}(\mathcal P)
\Big).
\]

### Reverse direction
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

## Terminal missing object
The reverse direction under the canonical adversary class.

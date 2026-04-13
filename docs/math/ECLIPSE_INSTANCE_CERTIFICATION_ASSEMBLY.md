# Eclipse Instance Certification Assembly

## Status
Conditional.

## Target
\[
\operatorname{ExternalReproducible}(\mathcal P_0)\wedge
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{DependencyClosed}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{Eclipse}(\mathcal P_0).
\]

## Input obligations
- `docs/math/ECLIPSE_EXTERNAL_REPRODUCIBILITY_INSTANCE.md`
- `docs/math/ECLIPSE_AUDIT_STABILITY_INSTANCE.md`
- `docs/math/ECLIPSE_DEPENDENCY_CLOSURE_INSTANCE.md`
- `docs/math/ECLIPSE_STATUS_TRUTHFULNESS_INSTANCE.md`

## Assembly schema
\[
\Big(
\operatorname{ExternalReproducible}(\mathcal P_0)\wedge
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{DependencyClosed}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P_0).
\]

## Terminal missing object
A certified derivation of the assembly implication for the concrete witness system \(\mathcal P_0\).

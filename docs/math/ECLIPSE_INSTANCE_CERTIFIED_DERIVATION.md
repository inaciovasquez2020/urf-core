# Eclipse Instance Certified Derivation

## Status
Conditional.

## Target
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

## Imported inputs
- `docs/math/ECLIPSE_EXTERNAL_REPRODUCIBILITY_INSTANCE.md`
- `docs/math/ECLIPSE_AUDIT_STABILITY_INSTANCE.md`
- `docs/math/ECLIPSE_DEPENDENCY_CLOSURE_INSTANCE.md`
- `docs/math/ECLIPSE_STATUS_TRUTHFULNESS_INSTANCE.md`
- `docs/math/ECLIPSE_INSTANCE_CERTIFICATION_ASSEMBLY.md`

## Certified derivation schema
### Step 1
\[
\operatorname{ExternalReproducible}(\mathcal P_0)
\Rightarrow
\operatorname{ReconstructionStable}_A(\mathcal P_0).
\]

### Step 2
\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
\]

### Step 3
\[
\operatorname{DependencyClosed}(\mathcal P_0)
\Rightarrow
\operatorname{DependencyInvariant}_A(\mathcal P_0).
\]

### Step 4
\[
\operatorname{ReconstructionStable}_A(\mathcal P_0)\wedge
\operatorname{StatusInvariant}_A(\mathcal P_0)\wedge
\operatorname{DependencyInvariant}_A(\mathcal P_0)
\Rightarrow
\operatorname{Eclipse}(\mathcal P_0).
\]

## Terminal missing lemma
\[
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
\]

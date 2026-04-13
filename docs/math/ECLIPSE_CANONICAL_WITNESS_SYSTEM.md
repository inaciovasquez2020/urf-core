# Eclipse Canonical Witness System

## Status
Conditional.

## Target
Construct a canonical witness system \(\mathcal P_0\) such that
\[
\operatorname{Eclipse}(\mathcal P_0).
\]

## Witness specification
Let
\[
\mathcal P_0:=(K_0,S_0,D_0,W_0),
\]
where:
- \(K_0\) is the finite set of core claims,
- \(S_0:K_0\to\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\}\) is the status map,
- \(D_0\) is the dependency graph on \(K_0\),
- \(W_0\) is the frozen witness set.

## Canonical conditions
\[
\operatorname{CoreClaims}(\mathcal P_0)=K_0,
\]
\[
\operatorname{StatusMap}(\mathcal P_0)=S_0,
\]
\[
\operatorname{DependencyGraph}(\mathcal P_0)=D_0,
\]
\[
\operatorname{WitnessSet}(\mathcal P_0)=W_0.
\]

## Certification obligations
### Obligation 1
\[
\operatorname{ExternalReproducible}(\mathcal P_0).
\]

### Obligation 2
\[
\operatorname{AuditStable}(\mathcal P_0).
\]

### Obligation 3
\[
\operatorname{DependencyClosed}(\mathcal P_0).
\]

### Obligation 4
\[
\operatorname{StatusTruthful}(\mathcal P_0).
\]

## Assembly target
\[
\operatorname{ExternalReproducible}(\mathcal P_0)\wedge
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{DependencyClosed}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{Eclipse}(\mathcal P_0).
\]

## Terminal missing object
A concrete finite witness system \((K_0,S_0,D_0,W_0)\) satisfying the four certification obligations.

# Eclipse Witness Instance

## Status
Conditional.

## Instance
Let
\[
K_0=\{k_1,k_2,k_3,k_4\}.
\]

Let
\[
S_0(k_1)=\mathrm{PROVED},\quad
S_0(k_2)=\mathrm{PROVED},\quad
S_0(k_3)=\mathrm{CONDITIONAL},\quad
S_0(k_4)=\mathrm{OPEN}.
\]

Let the dependency graph \(D_0\) be given by
\[
k_1\to k_3,\quad
k_2\to k_3,\quad
k_3\to k_4.
\]

Let
\[
W_0=\{w_1,w_2,w_3,w_4\},
\]
where each \(w_i\) is a frozen witness for \(k_i\).

Define
\[
\mathcal P_0:=(K_0,S_0,D_0,W_0).
\]

## Obligations
### External reproducibility
\[
\operatorname{ExternalReproducible}(\mathcal P_0).
\]

### Audit stability
\[
\operatorname{AuditStable}(\mathcal P_0).
\]

### Dependency closure
\[
\operatorname{DependencyClosed}(\mathcal P_0).
\]

### Status truthfulness
\[
\operatorname{StatusTruthful}(\mathcal P_0).
\]

## Target
\[
\operatorname{ExternalReproducible}(\mathcal P_0)\wedge
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{DependencyClosed}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{Eclipse}(\mathcal P_0).
\]

## Terminal missing object
A certified realization of the four obligations for this concrete instance.

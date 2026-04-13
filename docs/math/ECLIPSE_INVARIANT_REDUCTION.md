# Eclipse Invariant Reduction

## Status
Conditional.

## Target
\[
\forall \mathcal P,\quad
\Big(
\operatorname{ReconstructionStable}_A(\mathcal P)\wedge
\operatorname{StatusInvariant}_A(\mathcal P)\wedge
\operatorname{DependencyInvariant}_A(\mathcal P)\wedge
\operatorname{Eclipse}(\mathcal P_0)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Reference witness
Fix a canonical witness system \(\mathcal P_0\) with
\[
\operatorname{Eclipse}(\mathcal P_0).
\]

## Reduction step
For each \(a\in A\), define \(\mathcal Q=a(\mathcal P)\). If
\[
\operatorname{CoreClaims}(\mathcal Q)=\operatorname{CoreClaims}(\mathcal P_0),
\]
\[
\operatorname{StatusMap}(\mathcal Q)=\operatorname{StatusMap}(\mathcal P_0),
\]
and
\[
\operatorname{DependencyGraph}(\mathcal Q)\cong \operatorname{DependencyGraph}(\mathcal P_0),
\]
then by extensionality,
\[
\operatorname{Eclipse}(\mathcal Q)\iff \operatorname{Eclipse}(\mathcal P_0).
\]

## Terminal missing object
A canonical witness system \(\mathcal P_0\) satisfying \(\operatorname{Eclipse}(\mathcal P_0)\).

# Eclipse Invariant-to-Eclipse Implication

## Status
Conditional.

## Target
\[
\forall \mathcal P,\quad
\Big(
\operatorname{ReconstructionStable}_A(\mathcal P)\wedge
\operatorname{StatusInvariant}_A(\mathcal P)\wedge
\operatorname{DependencyInvariant}_A(\mathcal P)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Certification form
\[
\forall \mathcal P,\quad
\forall a\in A,\quad
\Big(
\operatorname{CoreClaims}(a(\mathcal P))=\operatorname{CoreClaims}(\mathcal P)
\wedge
\operatorname{StatusMap}(a(\mathcal P))=\operatorname{StatusMap}(\mathcal P)
\wedge
\operatorname{DependencyGraph}(a(\mathcal P))\cong \operatorname{DependencyGraph}(\mathcal P)
\Big)
\Rightarrow
\operatorname{Eclipse}(\mathcal P).
\]

## Terminal missing object
A certified bridge from pointwise adversary invariance to global Eclipse.

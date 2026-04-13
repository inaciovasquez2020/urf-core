# Eclipse Status-Invariance Bridge

## Status

Conditional.

## Target

\[
\boxed{
\operatorname{AuditStable}(\mathcal P_0)\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
\Rightarrow
\operatorname{StatusInvariant}_A(\mathcal P_0).
}
\]

## Assembly form

\[
\forall a\in A,\forall k\in K_0,\
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

\[
\forall k\in K_0,\ \forall S,S'\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},\
\Big(
W_0(k)\text{ certifies }S\text{ for }k
\wedge
W_0(k)\text{ certifies }S'\text{ for }k
\Big)
\Rightarrow
S=S'.
\]

## Terminal missing object

The combination of witness preservation under audit with witness-extensional uniqueness of status.

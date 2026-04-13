# Eclipse Witness-Preserved Status Invariance

## Status

Conditional.

## Target

\[
\boxed{
\forall a\in A,\forall k\in K_0,\
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
}
\]

## Role

This is the immediate weakest sufficient frontier for the status-invariance bridge.

## Reduction step

\[
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\wedge
W_0(k)\text{ certifies }S_{a(\mathcal P_0)}(k)\text{ for }k
\wedge
W_0(k)\text{ certifies }S_0(k)\text{ for }k
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

## Terminal missing object

The witness-preservation implication above for all admissible adversaries \(a\in A\).

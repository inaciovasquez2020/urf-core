# Eclipse Status Invariance from Witness Preservation

## Status

Conditional.

## Target

\[
\forall a\in A,\forall k\in K_0,\quad
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

## Inputs

\[
\forall k\in K_0,\forall S,S'\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\Big(
\operatorname{CertifiesStatus}(W_0(k),S,k)\wedge
\operatorname{CertifiesStatus}(W_0(k),S',k)
\Big)\Rightarrow S=S'.
\]

\[
\forall a\in A,\forall k\in K_0,\forall S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\operatorname{CertifiesStatus}(\operatorname{WitnessSet}(a(\mathcal P_0))(k),S,k)
\iff
\operatorname{CertifiesStatus}(W_0(k),S,k).
\]

## Reduction

\[
S_0(k)
\text{ is the unique status certified by }W_0(k),
\quad
S_{a(\mathcal P_0)}(k)
\text{ is the unique status certified by }\operatorname{WitnessSet}(a(\mathcal P_0))(k).
\]

\[
\operatorname{WitnessSet}(a(\mathcal P_0))(k)=W_0(k)
\Rightarrow
S_{a(\mathcal P_0)}(k)=S_0(k).
\]

## Role

This is Part \(2b\) and Part \(2c\) in the Eclipse status-invariance bottleneck.

## Terminal missing object

A certified transport-of-uniqueness argument from preserved witness identity to pointwise status equality.

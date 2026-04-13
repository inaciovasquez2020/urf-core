# Eclipse Witness Status Certification

## Status

Conditional.

## Target

For each claim \(k \in K_0\), the witness \(W_0(k)\) determines a unique status in
\(\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\}\).

\[
\forall k\in K_0,\ \exists!\,S\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\}
\text{ such that }
\operatorname{CertifiesStatus}(W_0(k),S,k).
\]

## Definition

\[
\operatorname{CertifiesStatus}(W_0(k),\mathrm{PROVED},k)
\iff
W_0(k)\text{ certifies }k.
\]

\[
\operatorname{CertifiesStatus}(W_0(k),\mathrm{CONDITIONAL},k)
\iff
W_0(k)\text{ certifies the exact missing lemma/hypothesis for }k.
\]

\[
\operatorname{CertifiesStatus}(W_0(k),\mathrm{OPEN},k)
\iff
W_0(k)\text{ certifies absence of a proof of }k.
\]

## Pairwise exclusivity

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{PROVED},k)
\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{CONDITIONAL},k)
\Big).
\]

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{PROVED},k)
\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{OPEN},k)
\Big).
\]

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{CONDITIONAL},k)
\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{OPEN},k)
\Big).
\]

## Uniqueness consequence

\[
\forall k\in K_0,\forall S,S'\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\Big(
\operatorname{CertifiesStatus}(W_0(k),S,k)\wedge
\operatorname{CertifiesStatus}(W_0(k),S',k)
\Big)\Rightarrow S=S'.
\]

## Role

This is the exact certification object needed for the witness-status uniqueness bottleneck.

## Terminal missing object

A certified proof that the three certification clauses are exhaustive and pairwise exclusive for each \(k\in K_0\).

# Eclipse Witness Status Exclusivity

## Status

Conditional.

## Target

\[
\forall k\in K_0,\forall S,S'\in\{\mathrm{OPEN},\mathrm{CONDITIONAL},\mathrm{PROVED}\},
\quad
\Big(
\operatorname{CertifiesStatus}(W_0(k),S,k)\wedge
\operatorname{CertifiesStatus}(W_0(k),S',k)
\Big)\Rightarrow S=S'.
\]

## Cases

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{PROVED},k)\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{CONDITIONAL},k)
\Big).
\]

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{PROVED},k)\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{OPEN},k)
\Big).
\]

\[
\forall k\in K_0,\quad
\neg\Big(
\operatorname{CertifiesStatus}(W_0(k),\mathrm{CONDITIONAL},k)\wedge
\operatorname{CertifiesStatus}(W_0(k),\mathrm{OPEN},k)
\Big).
\]

## Reduction

\[
\text{It suffices to prove the three pairwise exclusions above.}
\]

## Role

This is Part \(1b\) in the Eclipse status-invariance bottleneck.

## Terminal missing object

A certified contradiction argument for each of the three mixed-status cases.

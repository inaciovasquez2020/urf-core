# Eclipse Witness Status Uniqueness Certified

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

## Inputs

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
S\neq S'
\Rightarrow
(S,S')
\text{ is one of }
(\mathrm{PROVED},\mathrm{CONDITIONAL}),
(\mathrm{PROVED},\mathrm{OPEN}),
(\mathrm{CONDITIONAL},\mathrm{OPEN})
\text{ up to order.}
\]

## Conclusion

\[
\text{The three pairwise exclusions imply uniqueness of certified status for each }k\in K_0.
\]

## Role

This is Part \(1c\) in the Eclipse status-invariance bottleneck.

## Terminal missing object

A certified finite case split from pairwise exclusivity to full uniqueness.

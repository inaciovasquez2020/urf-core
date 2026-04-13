# Eclipse Status Truthfulness Instance

## Status
Conditional.

## Instance
Let \(\mathcal P_0=(K_0,S_0,D_0,W_0)\) be the witness instance from `docs/math/ECLIPSE_WITNESS_INSTANCE.md`.

## Target
\[
\operatorname{StatusTruthful}(\mathcal P_0).
\]

## Certification form
For every claim \(k\in K_0\),
\[
S_0(k)=\mathrm{PROVED}\Rightarrow W_0(k)\text{ certifies }k,
\]
\[
S_0(k)=\mathrm{CONDITIONAL}\Rightarrow W_0(k)\text{ certifies the exact missing hypothesis or lemma for }k,
\]
\[
S_0(k)=\mathrm{OPEN}\Rightarrow W_0(k)\text{ certifies absence of a proof of }k.
\]

## Terminal missing object
A certified witness-to-status correspondence for every \(k\in K_0\).

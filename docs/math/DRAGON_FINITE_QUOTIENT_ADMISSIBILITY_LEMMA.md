# DraG0n Finite Quotient Admissibility Lemma

## Status

CONDITIONAL

## Statement

For every diagnostic object `D` and every augmentation budget `k`, let `\mathcal M_{\mathrm{aug}}^{(k)}(D)` be the admissible augmentation class.

Define augmentation equivalence by
\[
(Z,\pi)\equiv(Z',\pi')
\iff
\widehat{\mathcal C}(D\mid Z,\pi)=\widehat{\mathcal C}(D\mid Z',\pi')
\quad\text{and}\quad
\Pi_D(Z,\pi)=\Pi_D(Z',\pi'),
\]
where `\Pi_D` denotes the induced frontier partition data.

Then:

1. `\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}` is finite.
2. `\preceq` descends to a well-defined preorder on `\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}`.
3. `\widehat{\mathcal C}(D\mid Z,\pi)` is constant on `\equiv`-classes.
4. If `D \sim D'`, then by `docs/math/DRAGON_TRANSPORT_UNDER_DIAGNOSTIC_EQUIVALENCE_LEMMA.md`,
   \[
   \mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}\cong
   \mathcal M_{\mathrm{aug}}^{(k)}(D')/{\equiv}.
   \]
5. Every nonempty subset of admissible `\tau`-achievers in the quotient has a `\preceq`-minimal element.

## Consequence

The Representation-Invariant Minimal Augmentation Theorem is unconditional once this lemma is proved.

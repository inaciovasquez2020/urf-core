# DraG0n

## Status

CANONICAL

## Role

Cross-program meta-framework rather than problem-specific frontier math.

## Canonical placement

The canonical home of DraG0n is `urf-core/docs/foundations/DRAG0N.md`.

Mirror only in `urf-textbook` for exposition.

Do not place canonically in:
- `chronos-urf-rr`
- `clay-problem-lab`
- `ym-os-quantization`
- `pachner-invariant`

## DraG0n* weakest sufficient missing theorem

### Representation-Invariant Minimal Augmentation Theorem

Assume:

1. `~` is a congruence for admissibility and score data.
2. `\widehat{\mathcal C}` is constant on diagnostic equivalence classes.
3. `\mathcal M_{\mathrm{aug}}^{(k)}(D) / \equiv` is nonempty and well-founded under `\preceq`.
4. `\widehat{\mathcal C}(D \mid Z,\pi)` is order-lower-semicontinuous on `\preceq`-chains.
5. admissibility is preserved under passage to `\preceq`-smaller augmentations.

Then for every diagnostic object `D`,
\[
\widehat{\mathrm{DraG0n}}^{(k)}(D)=1
\Longrightarrow
\exists\ (Z,\pi)\in\mathcal M_{\mathrm{aug}}^{(k)}(D)
\]
such that
\[
\widehat{\mathcal C}(D)-\widehat{\mathcal C}(D\mid Z,\pi)\ge\tau,
\]
and `(Z,\pi)` is `\preceq`-minimal among admissible `\tau`-achieving augmentations.

Moreover,
\[
D \sim D' \implies \widehat{\mathcal C}(D)=\widehat{\mathcal C}(D').
\]

Hence the induced minimal augmentation class is well-defined on equivalence classes.

## Augmentation equivalence

Define augmentation equivalence by
\[
(Z,\pi)\equiv(Z',\pi')
\iff
\widehat{\mathcal C}(D\mid Z,\pi)=\widehat{\mathcal C}(D\mid Z',\pi')
\quad\text{and}\quad
\Pi_D(Z,\pi)=\Pi_D(Z',\pi'),
\]
where `\Pi_D` denotes the induced frontier partition data.

## Current unconditional frontier

The weakest remaining theorem object is `docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md`.

## Next theorem objects

1. Prove finiteness of `\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}`.
2. Prove quotient descent of `\preceq`.
3. Prove quotient descent of `\widehat{\mathcal C}`.
4. Prove transport of quotient data across `D \sim D'`.

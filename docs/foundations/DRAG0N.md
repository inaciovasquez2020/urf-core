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

## Next theorem objects

1. Define augmentation equivalence `\equiv`.
2. Prove downward closure of admissible `\tau`-achievers.
3. Prove existence of `\preceq`-minimal elements in the quotient.
4. Prove transport of minimal classes across `D \sim D'`.

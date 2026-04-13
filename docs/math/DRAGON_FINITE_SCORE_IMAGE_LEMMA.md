# DraG0n Finite Score Image Lemma

## Status

CONDITIONAL

## Statement

Fix a diagnostic object `D` and augmentation budget `k`.

Assume the score components
\[
\operatorname{Clust},\operatorname{Stab},\operatorname{Mask},\operatorname{Block}
\]
are each normalized and take values in finite sets on admissible augmentations in
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D).
\]

Then the induced score image
\[
\mathfrak C_D^{(k)}
:=
\left\{
\widehat{\mathcal C}(D\mid Z,\pi)
:
(Z,\pi)\in\mathcal M_{\mathrm{aug}}^{(k)}(D)
\right\}
\]
is finite.

## Proof skeleton

1. Each score component has finite image on admissible augmentations.
2. The tuple of component values therefore has finite image.
3. `\widehat{\mathcal C}` is a fixed aggregate of those component values.
4. Hence `\mathfrak C_D^{(k)}` is finite.

## Consequence

This isolates A4 of `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md` as a standalone theorem object.

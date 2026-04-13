# DraG0n Finite Partition Image Lemma

## Status

CONDITIONAL

## Statement

Fix a diagnostic object `D` and augmentation budget `k`.

Assume the induced frontier partition datum
\[
\Pi_D(Z,\pi)
\]
is assembled from finitely many primitive frontier labels and that admissible augmentations in
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)
\]
use at most `k` such primitive labels.

Then the partition image
\[
\mathfrak P_D^{(k)}
:=
\left\{
\Pi_D(Z,\pi)
:
(Z,\pi)\in\mathcal M_{\mathrm{aug}}^{(k)}(D)
\right\}
\]
is finite.

## Proof skeleton

1. The primitive frontier label alphabet is finite.
2. Admissible augmentations use at most `k` primitive labels.
3. Hence only finitely many partition patterns can be assembled.
4. Therefore `\mathfrak P_D^{(k)}` is finite.

## Consequence

This isolates A3 of `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md` as a standalone theorem object.

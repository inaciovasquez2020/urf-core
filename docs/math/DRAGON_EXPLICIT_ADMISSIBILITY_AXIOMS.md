# DraG0n Explicit Admissibility Axioms

## Status

CONDITIONAL

## Purpose

This file isolates the exact axioms sufficient to derive finiteness of
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}.
\]

## Axioms

### Axiom A1: Finite wall alphabet

For each diagnostic object `D`, there exists a finite set `\Omega_D` of primitive admissible wall-types.

Every admissible augmentation `(Z,\pi)\in\mathcal M_{\mathrm{aug}}^{(k)}(D)` is assembled from elements of `\Omega_D`.

### Axiom A2: Budget bound

For fixed `k`, every admissible augmentation uses at most `k` primitive wall-types.

### Axiom A3: Finite partition data

The induced frontier partition datum `\Pi_D(Z,\pi)` takes values in a finite set `\mathfrak P_D^{(k)}`.

Current standalone route: `docs/math/DRAGON_FINITE_PARTITION_IMAGE_LEMMA.md`.

### Axiom A4: Quantized score image

For fixed `D` and `k`, the values of
\[
\widehat{\mathcal C}(D\mid Z,\pi)
\]
on admissible augmentations belong to a finite set `\mathfrak C_D^{(k)}`.

Current standalone route: `docs/math/DRAGON_FINITE_SCORE_IMAGE_LEMMA.md`.

### Axiom A5: Quotient compatibility

If
\[
(Z,\pi)\equiv(Z',\pi'),
\]
then both pairs have identical score value and identical induced partition datum.

## Derived target

Under A1--A5,
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}
\]
is finite.

## Frontier status

The remaining task is to prove the finiteness target from A1--A5 inside the DraG0n framework.

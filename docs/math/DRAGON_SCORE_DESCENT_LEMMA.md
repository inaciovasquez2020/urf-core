# DraG0n Score Descent Lemma

## Status

CONDITIONAL

## Statement

Fix a diagnostic object `D` and augmentation budget `k`.

Assume score evaluation is representation-invariant in the following sense:

if
\[
(Z,\pi)\equiv(\widetilde Z,\widetilde\pi),
\]
then
\[
\widehat{\mathcal C}(D\mid Z,\pi)
=
\widehat{\mathcal C}(D\mid \widetilde Z,\widetilde\pi).
\]

Then `\widehat{\mathcal C}` descends to a well-defined function on
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}.
\]

## Quotient form

Define
\[
\widehat{\mathcal C}_{\equiv}\bigl([(Z,\pi)]\bigr)
:=
\widehat{\mathcal C}(D\mid Z,\pi).
\]

Under the invariance hypothesis, `\widehat{\mathcal C}_{\equiv}` is well-defined.

## Consequence

This isolates the score-descent obstruction in the finite-quotient admissibility route.

# DraG0n Preorder Descent Lemma

## Status

CONDITIONAL

## Statement

Fix a diagnostic object `D` and augmentation budget `k`.

Assume the augmentation preorder `\preceq` is representation-invariant in the following sense:

if
\[
(Z,\pi)\equiv(\widetilde Z,\widetilde\pi)
\quad\text{and}\quad
(Z',\pi')\equiv(\widetilde Z',\widetilde\pi'),
\]
then
\[
(Z,\pi)\preceq(Z',\pi')
\Longleftrightarrow
(\widetilde Z,\widetilde\pi)\preceq(\widetilde Z',\widetilde\pi').
\]

Then `\preceq` descends to a well-defined preorder on
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}.
\]

## Quotient form

Define
\[
[(Z,\pi)]\preceq_{\equiv}[(Z',\pi')]
\iff
(Z,\pi)\preceq(Z',\pi').
\]

Under the invariance hypothesis, `\preceq_{\equiv}` is well-defined.

## Consequence

This isolates the preorder-descent obstruction in the finite-quotient admissibility route.

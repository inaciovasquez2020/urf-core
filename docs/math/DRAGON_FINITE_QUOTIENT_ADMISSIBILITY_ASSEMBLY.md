# DraG0n Finite Quotient Admissibility Assembly

## Status

CONDITIONAL

## Inputs

- `docs/math/DRAGON_FINITE_WALL_ALPHABET_LEMMA.md`
- `docs/math/DRAGON_FINITE_PARTITION_IMAGE_LEMMA.md`
- `docs/math/DRAGON_FINITE_SCORE_IMAGE_LEMMA.md`
- `docs/math/DRAGON_QUOTIENT_DETERMINACY_LEMMA.md`
- `docs/math/DRAGON_TRANSPORT_UNDER_DIAGNOSTIC_EQUIVALENCE_LEMMA.md`
- `docs/math/DRAGON_PREORDER_DESCENT_LEMMA.md`
- `docs/math/DRAGON_SCORE_DESCENT_LEMMA.md`

## Assembly theorem

Assume the hypotheses of the input lemmas.

Then for every diagnostic object `D` and augmentation budget `k`:

1. the quotient
   \[
   \mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}
   \]
   is finite;
2. the preorder `\preceq` descends to a well-defined preorder on the quotient;
3. the score `\widehat{\mathcal C}` descends to a well-defined quotient function;
4. if `D\sim D'`, then
   \[
   \mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}
   \cong
   \mathcal M_{\mathrm{aug}}^{(k)}(D')/{\equiv}.
   \]

## Consequence

This assembles the full content of `docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md`.

# DraG0n Finite Quotient from Explicit Admissibility Axioms

## Status

CONDITIONAL ON `DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS`

## Theorem

Assume A1--A5 from `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md`.

Then for every diagnostic object `D` and every augmentation budget `k`,
\[
\mathcal M_{\mathrm{aug}}^{(k)}(D)/{\equiv}
\]
is finite.

## Proof skeleton

1. By A1 and A2, only finitely many primitive wall selections may occur.
2. By A3, only finitely many partition data may occur.
3. By A4, only finitely many score values may occur.
4. By A5, an `\equiv`-class is determined by score value together with partition datum.
   Current refinement: `docs/math/DRAGON_QUOTIENT_DETERMINACY_LEMMA.md`.
5. Hence only finitely many `\equiv`-classes exist.

## Consequence

This theorem discharges the current weakest finiteness frontier once A1--A5 are accepted or proved.

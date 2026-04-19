# Envelope Witness Inclusion Reduction

Status: OPEN.

## Reduction

Define a witness map
\[
\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}.
\]

The weakest sufficient next step is to prove that \(\iota\) is well-defined and injective.

## Consequence

If \(\iota\) is well-defined and injective, then every admissible envelope witness is representable in the repository-native witness class.

Equivalently, the abstract envelope obstruction becomes repository-native.

## Remaining obligation

It remains to prove
\[
\ker(\iota)=\{0\}.
\]

## Kernel obligation

- `docs/math/ENVELOPE_WITNESS_INCLUSION_KERNEL_OBLIGATION.md`

## Non-claim

This note does not claim that the theorem above has been proved.
It records the witness-inclusion reduction as the next isolated open ingredient.

# Envelope Propagation Reduction

Status: OPEN.

## Reduction

Assume the witness-inclusion map
\[
\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}
\]
is well-defined and injective.

The weakest sufficient next step is to prove that repository-native admissibility propagates along the envelope bridge.

## Propagation target

For every admissible envelope witness \(w\in W_{\mathrm{env}}\),
\[
\mathcal P(\iota(w))
\]
holds in the repository-native bridge layer.

## Consequence

If repository-native admissibility propagates along the envelope bridge, then the envelope propagation frontier is discharged.

## Remaining obligation

It remains to prove that the bridge predicate \(\mathcal P\) is preserved under the envelope-to-repository transfer.

## Non-claim

This note does not claim that the theorem above has been proved.
It records the propagation reduction as the next isolated open ingredient.

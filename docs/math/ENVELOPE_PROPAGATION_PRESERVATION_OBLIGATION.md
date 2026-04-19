# Envelope Propagation Preservation Obligation

Status: OPEN.

## Target

Let
\[
\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}.
\]

The next isolated proof obligation is to prove preservation of the bridge predicate:
\[
\forall w\in W_{\mathrm{env}},\qquad \mathcal P(w)\Longrightarrow \mathcal P(\iota(w)).
\]

## Weakest sufficient consequence

If
\[
\forall w\in W_{\mathrm{env}},\qquad \mathcal P(w)\Longrightarrow \mathcal P(\iota(w)),
\]
then repository-native admissibility propagates along the envelope bridge.

## Non-claim

This note does not claim that the theorem above has been proved.
It records the propagation-preservation obligation as the next isolated open ingredient.

# URF Global Completion Lower Bound (v1)

## Status
PROVED

## Statement
Let
\[
P_{\mathrm{URF}}:=100\sum_{M\in\mathcal{M}_{\mathrm{URF}}} w(M)c(M)
\]
be the canonical global completion percentage from
`docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`.

Then the current repository state certifies the lower bound
\[
P_{\mathrm{URF}} \ge 30.
\]

## Witness
The canonical model assigns weight
\[
w(\texttt{community\_and\_bridge\_surfaces})=0.15
\]
and
\[
w(\texttt{global\_completion\_policy})=0.15.
\]

The current repository state certifies
\[
c(\texttt{community\_and\_bridge\_surfaces})=1
\]
through the current-instance URF-11 closure files:
- `docs/community/urf11/CURRENT_INSTANCE_REGISTRY_CLOSURE_CERTIFICATE.md`
- `docs/community/urf11/CURRENT_INSTANCE_WEAK_INTERACTION_CERTIFICATE.md`
- `docs/community/urf11/CURRENT_INSTANCE_PROMOTION_STABILITY_CERTIFICATE.md`

The current repository state certifies
\[
c(\texttt{global\_completion\_policy})=1
\]
through the policy layer:
- `docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`
- `docs/status/URF_GLOBAL_COMPLETION_SCORING_RULES_2026_04.md`
- `docs/status/URF_GLOBAL_COMPLETION_WEIGHT_MODEL_ASSUMPTION_2026_04.md`
- `tests/test_urf_global_completion_policy_literal.py`

Therefore
\[
P_{\mathrm{URF}}
\ge
100\bigl(0.15\cdot 1 + 0.15\cdot 1\bigr)
=
30.
\]

## Scope
This is a certified lower bound only.
No exact value is claimed here for the remaining module scores.

## Finish condition
Replace this lower-bound certificate by an exact-value certificate only after every remaining module score is designated and computed repository-natively.

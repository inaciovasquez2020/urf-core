# URF-11 Current-Instance Promotion Stability Certificate

## Status
OPEN

## Certified current-instance statement
For the current registries on this repository state,
\[
\Delta_{\mathrm{promote}} \subseteq \texttt{docs/community/urf11},
\]
the mutable promotion-managed path set is disjoint from theorem and policy locks, and
\[
\forall \Pi_{i\to j},\qquad \operatorname{Promote}(\Pi_{i\to j})=1
\Longrightarrow
\texttt{benchmark\_status}=\texttt{PASS}.
\]

Plain form:
Promotion is currently confined to docs/community/urf11, does not touch theorem or policy lock files, and every promoted bridge packet has a PASS benchmark result.

## Computed witness source
- `docs/community/urf11/PROMOTION_PATH_REGISTRY.yaml`
- `docs/community/urf11/PROMOTION_WITNESS_REGISTRY.yaml`
- `docs/community/urf11/BENCHMARK_RESULT_REGISTRY.yaml`
- `tests/test_urf11_promotion_stability_computed.py`
- `tests/test_urf11_promotion_semantics.py`
- `tests/test_urf11_instance_certificates.py`

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify nonescape, lock disjointness, and PASS-linked promotion semantics on the current registries.

# URF-11 Promotion Scope Policy

## Status
OPEN

## Allowed write-scope
\[
\Delta_{\mathrm{promote}} \subseteq \texttt{docs/community/urf11}.
\]

Plain form: Delta_promote subseteq docs/community/urf11.

## Promotion-managed canonical files
- docs/community/urf11/BRIDGE_REGISTRY.yaml
- docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml
- docs/community/urf11/BENCHMARK_REGISTRY.yaml
- docs/community/urf11/ACCEPTANCE_REGISTRY.yaml
- docs/community/urf11/EXPORTED_OBJECT_REGISTRY.yaml
- docs/community/urf11/TRANSLATION_RULE_REGISTRY.yaml
- docs/community/urf11/PROMOTION_WITNESS_REGISTRY.yaml

## Forbidden effect
No promotion may rewrite canonical theorem, dependency, or closure claims outside docs/community/urf11.

## Allowed effect
Promotion may add only bridge metadata, benchmark evidence, acceptance witnesses, or routing references inside docs/community/urf11.

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify that every promotion-managed path lies inside docs/community/urf11 and every witness record resolves to a declared bridge packet.

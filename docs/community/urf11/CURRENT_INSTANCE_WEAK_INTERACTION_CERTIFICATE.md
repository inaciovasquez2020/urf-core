# URF-11 Current-Instance Weak Interaction Certificate

## Status
PROVED

## Certified current-instance statement
For the current registries on this repository state,
\[
\forall i\in\{1,\dots,11\},\qquad \deg^{+}(F_i)\ge 1.
\]

Plain form:
Every field currently has at least one outgoing bridge packet.

## Computed witness source
- `docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml`
- `tests/test_urf11_weak_interaction_computed.py`
- `tests/test_urf11_instance_certificates.py`

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify the displayed outdegree lower bound from the current bridge packet registry.

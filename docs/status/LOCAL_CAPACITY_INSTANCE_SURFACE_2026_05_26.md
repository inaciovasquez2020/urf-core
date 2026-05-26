# Local Capacity Instance Surface — 2026-05-26

Status: INSTANCE_LEVEL_CAPACITY_SURFACE_ONLY

Closed predecessor:
- `local_chain_rule_instance_surface`

New object:
- `LocalCapacityInstanceData`
- `local_capacity_instance_surface`

Role:
- Provides a local finite capacity-bound instance surface.
- This is the weakest instance-level bridge for the localized `capacity` obligation.

Boundary:
- This does not replace the global `capacity` axiom in `urf_law3.lean`.
- This does not replace the global `chain_rule` axiom in `urf_law3.lean`.
- This does not replace the global `cmi_nonneg` axiom in `urf_law3.lean`.
- This does not prove full URF-core load-bearing theorem closure.
- This does not prove unrestricted Chronos-RR.
- This does not prove unrestricted H4.1/FGL.
- This does not prove P vs NP.
- This does not prove any Clay problem.

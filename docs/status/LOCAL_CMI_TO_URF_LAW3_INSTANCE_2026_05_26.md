# Local CMI to URF Law 3 Instance — 2026-05-26

Status: INSTANCE_LEVEL_THEOREM_ONLY

Closed predecessor:
- `finiteCMI_nonneg_from_KL`
- `localCMI_nonneg_from_finite_interface`

New object:
- `LocalURFLaw3InstanceData`
- `localCMI_to_urf_law3_instance`

Role:
- Provides an instance-level URF Law 3 non-amplification theorem using local CMI nonnegativity, a local chain rule, and a local capacity bound.
- This is the weakest instance-level bridge after the finite/local CMI object layer.

Boundary:
- This does not replace the global `cmi_nonneg` axiom in `urf_law3.lean`.
- This does not replace the global `chain_rule` axiom in `urf_law3.lean`.
- This does not replace the global `capacity` axiom in `urf_law3.lean`.
- This does not prove full URF-core load-bearing theorem closure.
- This does not prove unrestricted Chronos-RR.
- This does not prove unrestricted H4.1/FGL.
- This does not prove P vs NP.
- This does not prove any Clay problem.

# Finite CMI to Local CMI Nonnegativity Interface — 2026-05-26

Status: LOCAL_INTERFACE_BRIDGE_ONLY

Closed predecessor:
- `finiteCMI_nonneg_from_KL`

New bridge object:
- `localCMI`
- `localCMI_nonneg_from_finite_interface`

Role:
- Introduces a named local CMI nonnegativity bridge from the finite object layer.
- This is the weakest local replacement target after `CMI_Nonneg_From_Definition`.

Boundary:
- This does not replace the global `cmi_nonneg` axiom in `urf_law3.lean`.
- This does not prove the global `chain_rule`.
- This does not prove the global `capacity` bound.
- This does not prove full URF-core load-bearing theorem closure.
- This does not prove unrestricted Chronos-RR.
- This does not prove unrestricted H4.1/FGL.
- This does not prove P vs NP.
- This does not prove any Clay problem.

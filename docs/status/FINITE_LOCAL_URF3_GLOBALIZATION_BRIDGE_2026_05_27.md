# Finite-Local URF3 Globalization Bridge — 2026-05-27

Status: `FINITE_LOCAL_AND_ADMISSIBLE_GLOBAL_CLOSED_UNIVERSAL_REFUTED`.

This record adds a finite/local URF3 proof chain and an admissible-global bridge surface.

Closed Lean items:

- `FiniteLocalDataToCompleteURF3Package`
- `FiniteLocalDataToFiniteLocalURF3Bound`
- `LocalFiniteURF3ToGlobalURF3Bound`
- `UnrestrictedURF3_from_globalization_bridge`
- `AdmissibleGlobalURF3`
- `no_universal_UnrestrictedURF3GlobalizationBridge`

Interpretation:

- Finite local data with nonnegative local mass and total capacity at most `1` gives the pointwise bound.
- A windowed global sequence inherits the same bound when it agrees with finite local data on the window.
- An admissible global sequence inherits the bound when it carries a covering globalization bridge.
- A universal bridge for arbitrary global sequences is refuted by the constant sequence `fun _ => 2`.

Boundary:

This is finite/local and admissible-global only.

Does not prove:

- unrestricted arbitrary-global URF Law 3
- replacement of global `cmi_nonneg`
- replacement of global `chain_rule`
- replacement of global `capacity`
- unrestricted Chronos-RR
- unrestricted H4.1/FGL
- P vs NP
- any Clay problem

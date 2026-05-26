# URF Law 3 Primitive Obligation Localization — 2026-05-26

Status: LOAD_BEARING_OBLIGATION_LOCALIZED

Closed predecessor:
- `urf_law3` is now theorem-proved from existing primitives.

Remaining primitive obligations:
- `capacity`
- `chain_rule`
- `cmi_nonneg`

Minimal next missing lemma:
- `CMI_Nonneg_From_Definition`

Reason:
- In `urf_law3.lean`, `CMI` is an uninterpreted constant.
- Therefore nonnegativity of `CMI X (Y t) Y` is not derivable from the current object language.
- Proving `cmi_nonneg` requires a concrete definition of conditional mutual information or an imported entropy/KL-divergence nonnegativity theorem.

Next admissible theorem target:
- Define a concrete finite probability model.
- Define entropy / conditional entropy / conditional mutual information.
- Prove nonnegativity for that concrete CMI.
- Replace or refine `cmi_nonneg` only after the concrete definition exists.

Does not prove:
- `capacity`
- `chain_rule`
- `cmi_nonneg`
- full URF-core load-bearing theorem closure
- unrestricted Chronos-RR
- unrestricted H4.1/FGL
- P vs NP
- any Clay problem

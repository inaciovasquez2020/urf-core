# URF Global Completion Exact Value (v1)

## Status
PROVED

## Statement
Under
`docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`
and
`docs/status/URF_GLOBAL_COMPLETION_DESIGNATIONS_V1_2026_04.md`,
the current repository state yields

\[
c(\texttt{axioms_and_laws}) = \frac{1}{4} = 0.25.
\]

\[
c(\texttt{certificates_and_verifiers}) = \frac{5}{5} = 1.
\]

\[
c(\texttt{namespace_and_ci_integrity}) = \frac{6}{6} = 1.
\]

\[
c(\texttt{community_and_bridge_surfaces}) = \frac{3}{3} = 1.
\]

\[
c(\texttt{status_governance_and_audit}) = \frac{8}{8} = 1.
\]

\[
c(\texttt{global_completion_policy}) = 1.
\]

Therefore

\[
P_{\mathrm{URF}}
=
100\Bigl(
0.20\cdot 0.25
+
0.20\cdot 1
+
0.15\cdot 1
+
0.15\cdot 1
+
0.15\cdot 1
+
0.15\cdot 1
\Bigr)
=
85.
\]

## Witness decomposition
### axioms_and_laws
- `docs/community/urf11/WEAK_INTERACTION_THEOREM.md` has status `OPEN`
- `docs/community/urf11/PROMOTION_STABILITY_LAW.md` has status `OPEN`
- `docs/community/urf11/PROMOTION_SCOPE_POLICY.md` has status `OPEN`
- `docs/community/urf11/PROMOTION_SEMANTICS.md` has status `PROVED`

### certificates_and_verifiers
The designated executable witness set is:
- `tests/test_urf11_registry_closure_certificate.py`
- `tests/test_urf11_weak_interaction_computed.py`
- `tests/test_urf11_promotion_stability_computed.py`
- `tests/test_urf11_instance_certificates.py`
- `tests/test_urf_global_completion_lower_bound_literal.py`

### namespace_and_ci_integrity
The designated integrity witness set is:
- `build/build`
- `Lean Action CI/build`
- `No Duplicate Namespace Check/check`
- `verify/check`
- `verify-surface/check`
- `CI/test`

### community_and_bridge_surfaces
- `docs/community/urf11/CURRENT_INSTANCE_REGISTRY_CLOSURE_CERTIFICATE.md` has status `PROVED`
- `docs/community/urf11/CURRENT_INSTANCE_WEAK_INTERACTION_CERTIFICATE.md` has status `PROVED`
- `docs/community/urf11/CURRENT_INSTANCE_PROMOTION_STABILITY_CERTIFICATE.md` has status `PROVED`

### status_governance_and_audit
The designated status/audit surface is closed and supported by:
- `docs/status/URF_GLOBAL_COMPLETION_WEIGHT_MODEL_ASSUMPTION_2026_04.md`
- `docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`
- `docs/status/URF_GLOBAL_COMPLETION_SCORING_RULES_2026_04.md`
- `docs/status/URF_GLOBAL_COMPLETION_LOWER_BOUND_V1_2026_04.md`
- `docs/status/URF_GLOBAL_COMPLETION_DESIGNATIONS_V1_2026_04.md`
- `tests/test_urf_global_completion_policy_literal.py`
- `tests/test_urf_global_completion_lower_bound_literal.py`
- `tests/test_urf_global_completion_designations_literal.py`

### global_completion_policy
The policy layer is certified by:
- `docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`
- `docs/status/URF_GLOBAL_COMPLETION_SCORING_RULES_2026_04.md`
- `docs/status/URF_GLOBAL_COMPLETION_WEIGHT_MODEL_ASSUMPTION_2026_04.md`
- `tests/test_urf_global_completion_policy_literal.py`

## Consequence
The lower-bound-only reporting surface is now superseded for exact reporting by this exact-value certificate.

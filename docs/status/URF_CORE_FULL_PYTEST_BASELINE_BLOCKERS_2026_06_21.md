# URF-core full pytest baseline blockers — 2026-06-21

Status: `URF_CORE_FULL_PYTEST_BASELINE_BLOCKERS_2026_06_21`

Context: while recording the CSLIB-FMT full formula-radius external status signal, the signal verifier and targeted signal test passed. Full pytest on the fast-forwarded `urf-core` main was blocked by unrelated baseline failures.

Signal status: `CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL_OK`

Observed full-pytest baseline summary: `7 failed, 415 passed, 11 subtests passed`

## Expected baseline failures

- `tests/test_channel_capacity_bound_derivation.py::test_channel_capacity_verifier`
- `tests/test_core_obligation_status.py::test_core_obligation_status_guard_passes`
- `tests/test_lean_checked_restricted_valid_kernel_law3_instance.py::test_verifier_passes`
- `tests/test_stable_trace_certificate_equivalence.py::test_stable_trace_certificate_equivalence_lean_surface`
- `tests/test_urf_internal_completion_repository_staging_packet.py::test_verifier_passes`
- `tests/test_urf_law3_nonamplification_theorem_closure.py::test_urf_law3_has_no_local_admit_or_sorry`
- `tests/test_urf_law3_primitive_obligation_localization.py::test_urf_law3_primitive_obligation_localization_verifier`

Boundary: baseline-blocker inventory only; no repair to URF Law 3, channel-capacity, core-obligation, stable-trace, or staging-packet failures; no cross-repo proof import.

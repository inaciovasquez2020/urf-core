# URF exact reconstruction research — 2026-11-23

**Status:** independent, scoped mathematical research; finite computations reproduced in the assistant's isolated Linux environment. Lean candidates **NOT_RUN**. No unconditional global-URF, Poincaré, P-vs-NP, or physical 5D claim.

## Artifacts

- `URF_FULL_RESEARCH_STRENGTHENING_2026-11-23.md`: four-target audit, finite-fiber theorem, PR #597 review, physics and FO^k specification boundaries.
- `URF_SHARP_ADAPTIVE_RECONSTRUCTION_2026-11-23.md`: sharp graph reconstruction theorem and proof.
- `URFAdaptiveCountingCandidate.lean`: counting bound, **uncompiled source candidate**.
- `URFH1VacuityAuditCandidate.lean`: explicit `Unit`/`True` H1 interface counter-witness, **uncompiled source candidate**.
- `verify_multiscale_adaptive.py`, `verify_urf_probe_completion.py`, `verify_fiber_spectrum.py`, `verify_pr597_setcover_independent.py`: standard-library exact finite verifiers.
- `FULL_AUDIT_EXECUTION_RECEIPT.txt`: original bounded execution evidence (Linux Python 3.13.5; not a Mac or Lean receipt).

## Reproduce without downloads or repository modifications

From this directory, with Python 3 and ordinary assertions enabled:

```bash
PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 python3 -B verify_multiscale_adaptive.py
PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 python3 -B verify_urf_probe_completion.py
PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 python3 -B verify_fiber_spectrum.py
PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 python3 -B verify_pr597_setcover_independent.py
```

Resource guard exhaustion yields **INCOMPLETE**, never PASS. Full Lean build and theorem `#print axioms` audit remain OPEN.

## Integration boundary

This checkpoint adds only files under `research/strengthening_20261123/`. It does not alter `lean/URF.lean`, established declarations, existing PR #597, or main. Candidate Lean files remain outside the imported proof tree pending exact-toolchain compilation and allowed-axiom audits.

Provenance: independent review of public URF Core source including main `5deab2c9a4f57734e50d0e15e8effc9103128c3a` and PR #597 head `8e3857350353e43f3e1f93122e5269148c9f1d05`. Current target branch is a research-only snapshot and not a claim of independent scholarly novelty.

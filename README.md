# URF Prefab System

Canonical prefab layer for the Unified Rigidity Framework (URF).

This repository provides:
- Frozen axiom prefab (URF Core Axioms 0.0–0.4)
- Executable JSON schemas
- Deterministic verifier
- Reproducible CI-ready structure

Status:
- Canonical
- Frozen v1.0.0
- Dependency-locked to URF Core

Scope:
- Structural admissibility
- Capacity–locality certification
- No experimental or draft material

References:
- URF Core: https://github.com/inaciovasquez2020/urf-core
- Scientific Infrastructure: https://github.com/inaciovasquez2020/scientific-infrastructure
- Website: https://www.vasquezresearch.com
---

## Technical Notes
* **Integration:** This library is designed to be imported by other repositories within the inaciovasquez2020 organization.
* **Reproducibility:** For stable research results, ensure you are utilizing the specific version referenced in the Vasquez Index dashboard.
* **Dependencies:** Refer to `scientific-infrastructure` for the standard execution environment.

Scientific Infrastructure (Environment & Reproducibility)
https://inaciovasquez2020.github.io/scientific-infrastructure/

## Citation
If you utilize this core logic in your research, please cite it using the following entry:

```bibtex
@manual{Vasquez_URF_Core_2026,
  author = {Vasquez, Inacio F.},
  title  = {urf-core: Foundational Logic for the Unified Rigidity Framework},
  year   = {2026},
  url    = {[https://github.com/inaciovasquez2020/urf-core](https://github.com/inaciovasquez2020/urf-core)}
}
 (Cross-link scientific-infrastructure as canonical environment layer)

## Repository role

This repository is the canonical upstream for URF definitions, theorem statements, dependency ledgers, and closure claims.

Community-additive examples, tests, implementations, and non-canonical extensions belong in `urf-core-community`.

Exposition and release-facing documentation belong in `urf-textbook`.

Canonical whole-URF residual frontier: docs/status/URF_REMAINING_FRONTIER_CANONICAL.md

## Consolidated modules

- `legacy/urf-roadmap`
- `legacy/urf-portfolio`
- `legacy/urf-prefab-system`

## Formal Status

Status: Axiomatic Core / Trusted-Base Prototype

Build status:
- A successful build means the checked root target compiles.
- It does not imply that axiom-dependent or admit-dependent results prove their headline targets.

Theorem status:
- This repository currently contains project-defined `axiom` declarations and `admit` proof holes.
- `axiom` is a trusted assumption, not a proof.
- `admit` is a proof hole.
- Any result depending on project axioms or admitted obligations is Conditional.

Current status:
- Strongest verified theorem: none asserted at repository level
- Weakest missing theorem: replace each load-bearing axiom/admit with a proof or quarantine it as an explicit assumption
- Obligation inventory: `docs/status/OPEN_OBLIGATION_INVENTORY_2026_04_27.md`

## External status

This repository is governed by [`docs/status/EXTERNAL_STATUS_LOCK.md`](docs/status/EXTERNAL_STATUS_LOCK.md). Build success, CI success, dashboards, ledgers, axioms, admits, `sorry`, or placeholder witnesses do not constitute theorem-level closure.

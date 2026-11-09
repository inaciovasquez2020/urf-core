# URF Core — Formal Verification Infrastructure

## What is the Unified Rigidity Framework (URF)?

The **Unified Rigidity Framework (URF)** is a verification-oriented mathematical
research program studying when local observations, finite information capacity,
and admissible transformations constrain global structure or prevent its exact
reconstruction. Its applications are investigated in discrete mathematics,
formal logic, computation, topology, and mathematical physics. Connections
between these subjects are research targets, not assumed equivalences.

### Reconstruction model (a specification schema, not a universal theorem)

A particular reconstruction problem specifies:

- `X`: a class of admissible configurations;
- `O : X → Y`: all information accessible to the stated observer or process;
- `I : X → Z`: the global invariant or property being reconstructed;
- `B`: locality, depth, time, communication, or other resource bounds that
  determine the actual observation map `O`;
- `C`: proofs, counterexamples, or reproducible verification certificates.

The basic **indistinguishability obstruction** is the elementary implication

```text
O(x) = O(y) and I(x) != I(y)
    => no exact decoder D : Y -> Z satisfies I = D o O on all of X.
```

For finite images, `|I(X)| > |O(X)|` is another sufficient condition: a
single observation value must then represent configurations with different
invariant values. A bound on information *per step* does not, by itself,
bound total accessible information over arbitrarily many steps. The
indistinguishability obstruction above needs no finite-capacity premise:
for example, `O(n, b) = n` and `I(n, b) = b` cannot be exactly decoded
from `O`. Capacity assumptions are required only for arguments using
capacity bounds. Every rigidity or impossibility claim still requires
a specified observation model and a proved obstruction; locality alone
is insufficient.

### Research domains and proof boundaries

- **Finite structures and logic:** bounded-radius neighborhoods, logical
  types, cycle-overlap invariants, and distinguishability limits.
- **Topology:** local combinatorial moves and their possible global
  consequences; the independent Poincaré derivation remains open.
- **Transport and holonomy:** finite gauge examples of locally restricted
  observations with globally distinguishable invariants; draft computations
  are not Lean theorems or evidence of a necessary extra physical dimension.
- **Computation and verification:** explicit witnesses, deterministic tests,
  Lean theorem statements, and audited dependencies.
- **Physics:** candidate applications of geometric and information
  constraints; no unified physical theory or fifth-dimensional necessity
  is established.

An **unconditional URF theorem** must specify its domain and assumptions,
prove its conclusion without unresolved project axioms or proof holes, and
pass the relevant dependency/axiom audit. Finite experiments are evidence
only for their tested domain. Consult the status sections below before
citing any claimed closure.

## Scope and Status

URF Core is a Lean formalization and certificate-boundary repository.

The repository currently contains verified bounded witnesses, reusable certificate layers, theorem surfaces, and explicit frontier records. Many underlying mathematical components are elementary or previously known; the repository contribution is the formalization architecture, reproducible verification trail, and boundary discipline.

Current boundary:

- No unrestricted graph-class theorem is claimed.
- No unrestricted intended-configuration theorem is claimed.
- No P vs NP, Clay-problem, or major open-problem closure is claimed.
- Repository-native Path5 R1/R2/R3 closure is a finite non-toy witness only.

Recent closed bounded objects:

- `URF.R1R2R3Path5.rich_closed_nonToy_exists`
- `URF.R1R2R3Path5.path5_rich_R1_R2_R3_certificate`
- `URF.R1R2R3RepositoryNative.path5_repositoryNativeIntendedConfigurationInstance`
- `URF.R1R2R3RepositoryNative.path5_repositoryNativeIntendedConfiguration_certificate`
- `URF.R1R2R3RepositoryNative.repositoryNativeIntendedConfiguration_path5_closed`

## Verified Frontier Tracking Definitions Layer

This repository is the definitions layer for **Verified Frontier Tracking**.

It holds the stable objects that other public layers refer to:

| Object type | Role |
| --- | --- |
| Definitions | Names the structural objects used across URF artifacts |
| Schemas | Fixes the shape of status, certificate, and verification data |
| Verification artifacts | Supports reproducible checks of declared surfaces |
| Claim boundaries | Prevents interfaces, conditions, and open frontiers from being promoted into solved theorems |

Boundary: this repository provides trusted definitions and verification infrastructure. It does not claim theorem-level closure unless a theorem is explicitly formalized and its assumptions are discharged.

## Current Reference Layer

This repository provides:

- Current reference prefab layer for the Unified Rigidity Framework (URF)
- Frozen axiom prefab (URF Core Axioms 0.0–0.4)
- Executable JSON schemas
- Deterministic verifier
- Reproducible CI-ready structure

Status:

- Current reference
- Frozen v1.0.0
- Dependency-locked to URF Core

Scope:

- Structural admissibility
- Capacity-locality certification
- No experimental or draft material

References:

- URF Core: https://github.com/inaciovasquez2020/urf-core
- Scientific Infrastructure: https://github.com/inaciovasquez2020/scientific-infrastructure
- Website: https://www.vasquezresearch.com
- Scientific Infrastructure Environment: https://inaciovasquez2020.github.io/scientific-infrastructure/

## Technical Notes

- Integration: this library is designed to be imported by other repositories within the `inaciovasquez2020` organization.
- Reproducibility: for stable research results, use the specific version referenced in the Vasquez Index dashboard.
- Dependencies: refer to `scientific-infrastructure` for the standard execution environment.

## Citation

If you utilize this core logic in your research, please cite it using the following entry:

```bibtex
@manual{Vasquez_URF_Core_2026,
  author = {Vasquez, Inacio F.},
  title  = {urf-core: Foundational Logic for the Unified Rigidity Framework},
  year   = {2026},
  url    = {https://github.com/inaciovasquez2020/urf-core}
}
```

Cross-link `scientific-infrastructure` as the current reference environment layer.

## Repository Role

This repository is the current reference upstream for URF definitions, theorem statements, dependency ledgers, and closure claims.

Community-additive examples, tests, implementations, and non-current reference extensions belong in `urf-core-community`.

Exposition and release-facing documentation belong in `urf-textbook`.

Current reference whole-URF residual frontier: `docs/status/URF_REMAINING_FRONTIER_CANONICAL.md`

Current theorem-level closed surface: `docs/status/URF_CORE_NO_STATUS_PROMOTION_THEOREM_CLOSURE_2026_05_15.md`

## Consolidated Modules

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

- Strongest verified theorem: `URF.no_status_promotion_closed` in `URF/TheoremClosure/NoStatusPromotion.lean`
- Weakest missing theorem: replace each load-bearing axiom/admit with a proof or quarantine it as an explicit assumption
- Obligation inventory: `docs/status/OPEN_OBLIGATION_INVENTORY_2026_04_27.md`

## External Status

This repository is governed by [`docs/status/EXTERNAL_STATUS_LOCK.md`](docs/status/EXTERNAL_STATUS_LOCK.md). Build success, CI success, dashboards, ledgers, axioms, admits, `sorry`, or placeholder witnesses do not constitute theorem-level closure.

## Lean Proof Portfolio Classification

This repository is governed by [`docs/status/LEAN_PROOF_PORTFOLIO_CLASSIFICATION.md`](docs/status/LEAN_PROOF_PORTFOLIO_CLASSIFICATION.md). Its role in the portfolio is explicitly classified as proof-facing, conditional frontier, infrastructure/documentation, or legacy/scaffold.

## Public Frontier Status

- [URF Core Public Frontier Status — 2026-05-10](docs/status/URF_CORE_PUBLIC_FRONTIER_STATUS_2026_05_10.md)

Boundary: selected-domain Chronos/H4.1-FGL status only; no unrestricted H4.1/FGL closure; no UniversalFiberEntropyGap, Chronos-RR, P vs NP, or Clay-problem closure.

## Container: `urf-sg-verifier`

The `urf-sg-verifier` container provides a reproducible command-line wrapper around `verification/verify.py`.

```bash
docker pull ghcr.io/inaciovasquez2020/urf-sg-verifier:latest
docker run --rm -v "$PWD:/work" ghcr.io/inaciovasquez2020/urf-sg-verifier:latest /work/path/to/certificate.json
```

Immutable pulls should use a `sha-*` tag or digest instead of `latest`.

Boundary: this container verifies URF spectral-gap certificate artifacts accepted by the verifier. It does not assert theorem-level closure unless the referenced theorem is formalized and all assumptions are discharged.

<!-- URF_ACTIVE_OBLIGATION_STATUS_START -->
## Active obligation status

As of PR #494 / commit `e6f3c96`, the active-obligation ledger has reached the zero-obligation terminal state:

```text
ACTIVE_OBLIGATION_GROUPS_OK
{
  "groups": {},
  "total_active_obligations": 0
}
```

This is a repository-hygiene and verifier-status milestone. It means the tracked active obligation marker ledger is empty, the verifier accepts that terminal state, the active-obligation tests pass, and the Lean build succeeds.

Boundary: this status does not claim theorem closure, solve an external mathematical problem, or assert completion of any future research target. It records only the current verified state of the active-obligation ledger.
<!-- URF_ACTIVE_OBLIGATION_STATUS_END -->

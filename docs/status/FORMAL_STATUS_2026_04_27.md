# Formal Status — 2026-04-27

Status: Axiomatic Core / Trusted-Base Prototype

## Build status

The repository builds, but build success is not theorem verification.

## Theorem status

This repository currently contains project-defined axioms and admitted obligations.

- `axiom` is a trusted assumption, not a proof.
- `admit` is a proof hole.
- Any result depending on project axioms or admitted obligations is Conditional.
- No axiom-dependent or admit-dependent result should be described as proved, closed, final, terminal, unconditional, or machine-verified.

## Current status

- Current classification: Axiomatic Core / Trusted-Base Prototype
- Strongest verified theorem: none asserted at repository level
- Weakest missing theorem: replace each load-bearing axiom/admit with a proof or quarantine it as an explicit assumption
- Obligation inventory: `docs/status/OPEN_OBLIGATION_INVENTORY_2026_04_27.md`

## Boundary rule

If `axiom + admit + sorry > 0`, no theorem-closure claim is allowed.

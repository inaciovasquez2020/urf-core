# Open Obligation Inventory — 2026-04-27

Status: Axiomatic Core / Trusted-Base Prototype

This repository is a prototype trusted base for URF-style definitions and reductions.
It currently contains axioms, admits, or sorries and therefore should not be presented as a verified theorem repository.
The correct claim is that it organizes the formal dependency graph and identifies missing proof obligations.

Axiom count: 5
Admit count: 0
Sorry count: 0

## Axiom locations
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:12` — `axiom H_nonneg  (X : Var) : 0 ≤ H X`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:13` — `axiom I_nonneg  (X Y : Var) : 0 ≤ I X Y`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:14` — `axiom I_c_nonneg (X Y Z : Var) : 0 ≤ I_c X Y Z`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:16` — `axiom urf_cmi_subadditivity (A B C : Var) :`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:29` — `axiom PCA (S : List Prefab) :`

## Admit locations
- None

## Sorry locations
- None

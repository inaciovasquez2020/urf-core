# Open Obligation Inventory — 2026-04-27

Status: Axiomatic Core / Trusted-Base Prototype

This repository is a prototype trusted base for URF-style definitions and reductions.
It currently contains axioms, admits, or sorries and therefore should not be presented as a verified theorem repository.
The correct claim is that it organizes the formal dependency graph and identifies missing proof obligations.

Axiom count: 52
Admit count: 9
Sorry count: 0

## Axiom locations

- `urf_law3.lean:15` — `axiom capacity :`
- `urf_law3.lean:19` — `axiom chain_rule :`
- `urf_law3.lean:25` — `axiom cmi_nonneg :`
- `chronos/Transport/VertexBoundaryTransport.lean:6` — `axiom entropy_of_set : ℕ → ℝ`
- `lean/chronos_cert/ChronosCert.lean:12` — `axiom mi_le_entropy_answer :`
- `lean/chronos_cert/ChronosCert.lean:15` — `axiom determinism_identity :`
- `lean/chronos_cert/ChronosCert.lean:19` — `axiom entropy_drop_ceiling :`
- `lean/URF/DescentSystem.lean:55` — `axiom step_rank_drop :`
- `lean/URF/DescentSystem.lean:79` — `axiom zero_rank_reached_within_rank`
- `lean/URF/DescentSystem.lean:94` — `axiom dependencyRich_nonempty_extractR :`
- `lean/URF/DescentSystem.lean:98` — `axiom cycle_basis_F2 :`
- `lean/URF/DescentSystem.lean:104` — `axiom extractR_matrix_full_rank :`
- `lean/URF/DescentSystem.lean:125` — `axiom poincare_end_to_end_descent :`
- `lean/URF/DescentSystem.lean:130` — `axiom explicit_F2_realization_and_step_compatibility :`
- `lean/URF/DescentSystem.lean:162` — `axiom pivot_family`
- `lean/URF/DescentSystem.lean:182` — `axiom cycle_basis_constructive`
- `lean/URF/DescentSystem.lean:199` — `axiom poincare_inline_descent :`
- `lean/URF/DescentSystem.lean:223` — `axiom canonical_edge_separation :`
- `lean/URF/DescentSystem.lean:290` — `axiom greedy_pivot_separation :`
- `URFCore/Reproducibility.lean:6` — `axiom DoubleBuildImpliesReproducible : True`
- `URFCore/Provenance.lean:29` — `axiom encodeProvenanceProj : ProvenanceProj → String`
- `URFCore/Provenance.lean:30` — `axiom decodeProvenanceProj : String → Option ProvenanceProj`
- `URFCore/Provenance.lean:31` — `axiom encodeSLSADigest : SLSADigest → String`
- `URFCore/Provenance.lean:32` — `axiom decodeSLSADigest : String → Option SLSADigest`
- `URFCore/Provenance.lean:34` — `axiom decode_encode_prov : ∀ p, decodeProvenanceProj (encodeProvenanceProj p) = some p`
- `URFCore/Provenance.lean:35` — `axiom decode_encode_slsa : ∀ d, decodeSLSADigest (encodeSLSADigest d) = some d`
- `URFCore/BuildInvariant.lean:7` — `axiom BuildMerkleDeterministic : True`
- `URFCore/CIIdempotence.lean:13` — `axiom Φ_idempotent : ∀ s, Φ (Φ s) = Φ s`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:12` — `axiom H_nonneg  (X : Var) : 0 ≤ H X`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:13` — `axiom I_nonneg  (X Y : Var) : 0 ≤ I X Y`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:14` — `axiom I_c_nonneg (X Y Z : Var) : 0 ≤ I_c X Y Z`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:16` — `axiom urf_cmi_subadditivity (A B C : Var) :`
- `legacy/urf-prefab-system/lean/URF_Prefab.lean:29` — `axiom PCA (S : List Prefab) :`
- `URF/Boundary/TreeToy.lean:7` — `axiom isTree : True`
- `URF/Boundary/TreeToy.lean:8` — `axiom maxDegree : ℕ`
- `URF/Boundary/TreeToy.lean:10` — `axiom degree_bound :`
- `URF/Info/InfoAxioms.lean:4` — `axiom InfoStepBound : ℝ`
- `URF/Info/InfoAxioms.lean:5` — `axiom info_step_nonneg : 0 ≤ InfoStepBound`
- `URF/Info/InfoAxioms.lean:7` — `axiom info_increment (t : ℕ) : ℝ`
- `URF/Info/InfoAxioms.lean:8` — `axiom info_increment_le :`
- `URF/PSH/BoundedOverlap.lean:7` — `axiom PSH_bounded_overlap`
- `URF/PSH/BoundedOverlap.lean:25` — `axiom PSH_finite_keys :`
- `src/UrfCore/AKR.lean:9` — `axiom archimedeanBound : ℕ`

## Admit locations

- `urf_law3.lean:37` — `admit`
- `chronos/Transport/VertexBoundaryTransport.lean:26` — `admit`
- `lean/URF/DescentSystem.lean:180` — `admit`
- `lean/URF/DescentSystem.lean:197` — `admit`
- `lean/URF/DescentSystem.lean:249` — `admit`
- `lean/URF/DescentSystem.lean:286` — `admit`
- `lean/URF/DescentSystem.lean:311` — `admit`
- `lean/URF/DescentSystem.lean:332` — `admit`
- `lean/URF/DescentSystem.lean:353` — `admit`
- `lean/URF/DescentSystem.lean:365` — `admit`
- `admissible/lean/URFAdmissible.lean:71` — `admit`
- `admissible/lean/URFAdmissible.lean:80` — `admit`
- `URF/PSH/BoundedOverlap.lean:23` — `local observations admit a finite key space.`

## Sorry locations

- None

# URF Transfer 001 — Constructive hidden-holonomy witness lemma

Date: 2026-11-09. Target: finite graph transport → locality/information obstruction.

## Status and scope

- **PROVED (mathematical argument, independent review pending):** the constructive linear-algebra witness lemma below.
- **COMPUTATION_PASS:** bounded finite witness construction, direct local-potential checks, independent global obstruction and mutation negative controls. Source and receipt included.
- **LEAN_VERIFIED (Mac-reported):** four *abstract* factorization/collision theorems in the accompanying `URF_ObservationFactorization_Candidate.lean`. Original acceptance output: compilation PASS, axiom audit PASS, theorem count 4; no additional axioms or `sorryAx`.
- **OPEN:** Lean proof of the actual graph quotient/cycle pairing, induced restriction compatibility, kernel dimension, and entropy formula.
- **NOT_RUN:** actual experimental URF-AI toolkit integration (PR #1338 source pin absent from six checked Mac repositories).
- **NOVELTY:** not established. The finite graph/cohomology ingredients are classical.

## Exact objects

Let `G=(V,E)` be any finite loopless undirected graph with fixed edge orientation, `p` prime, `F=F_p`, and `Z=ker ∂ ⊆ F^E` its cycle space. For a specified family of subgraphs `H_i`, include local cycle spaces into global edge coordinates, and let `W` be their linear span in `Z`. Global gauge classes are `Q(G)=F^E / im ∂ᵀ`. The observer obtains independently gauge-quotiented restrictions `L:Q(G)→∏_i Q(H_i)`. This **does not include common global gauge choices or transition functions between observation balls**.

## Constructive hidden-holonomy witness lemma

If `k = dim Z - dim W > 0`, there exist `k` edge cochains `a_1,...,a_k ∈ F^E` such that:

1. For every `i` and every observed subgraph `H_j`, there is a vertex potential `g_{i,j}` on `H_j` with `a_i(u,v)+g_{i,j}(v)-g_{i,j}(u)=0` for each oriented edge `(u,v)` in `H_j`. Hence each `[a_i]` is locally indistinguishable from the zero connection.
2. The global gauge classes `[a_i] ∈ Q(G)` are linearly independent and in particular nonzero. Thus there is **no global potential** removing any nonzero linear combination of the classes.
3. All `p^k` linear combinations are distinct global classes with the same tuple of local gauge observations. Under a uniform global prior the optimal decoder success for each such observation fiber is `p^{-k}`.

### Proof, constructive

Choose a basis `w_1,...,w_s` of `W` and extend it to a basis `w_1,...,w_s,z_1,...,z_k` of `Z`. Because the canonical dot product on `F^E` induces a perfect pairing between `F^E/im ∂ᵀ` and `Z`, extend each dual functional `ϕ_i` with `ϕ_i(w_j)=0`, `ϕ_i(z_l)=δ_{il}` to a functional on `F^E`. Represent it by an edge cochain `a_i` under the coordinate dot product. The `ϕ_i` are independent; therefore so are `[a_i]`. Their evaluations vanish on every local cycle. For any subgraph `H_j`, choose a spanning forest and define a vertex potential by integrating `-a_i` along forest paths. Every forest edge then gauges to zero; any nonforest edge closes a fundamental cycle, whose total `a_i`-evaluation is zero. Therefore the gauge-transformed cochain vanishes on every edge of `H_j`. This proves all three claims (the entropy statement follows from uniform cosets of the kernel). QED.

This establishes a **finite, constructive algorithm** (basis extension + finite-field elimination + spanning forests). It does **not** establish an unrestricted complexity lower bound, physical fifth dimension, Poincaré descent, or theorem novelty.

## Exact reproducible finite evidence

`urf_hidden_holonomy_witness_20261109.py` uses a modular full-row-rank solver to construct hidden edge cochains, independently checks local gauge functions directly on every observed edge, rejects global-gauge triviality, and checks independence by pairing with global fundamental cycles. Its tests include cycles, exhaustive small simple graphs, selected multicycle graphs and tampered gauge/edge controls.

The output receipt is `urf_hidden_holonomy_witness_receipt_20261109.json`; SHA256 is recorded in `manifest.json` in the accompanying archive. Finite tests cannot replace the uncompiled mathematical-to-Lean interface.

## Remaining formal proof interface

Lean target (precise, not yet implemented): define actual edge cochains `F^E`, vertex potentials `F^V`, boundary `∂`, cycle space `Z`, gauge quotient `Q`, and local restriction `L`. Prove

`ker L = { [a] ∈ Q(G) | ∀ z ∈ W, dot(a,z)=0 }`,

with `dot` well-defined on gauge classes, and derive `finrank (ker L) = finrank Z - finrank W`. Avoid direct use of the Poincaré theorem, any project axiom/admit/sorry/opaque/native_decide, and any classification of CI PASS as proof. The full entropy theorem is a later separately verified layer.

Source of the abstract Lean candidate: `URF_ObservationFactorization_Candidate.lean`, SHA256 `9108a0ed85bb72a2a74c8f10386dcade637c7822b22eff73cdd2f40862d99742`. The user's Mac reported Lean 4.29.0 success and four allowed-axiom audits.
# URF Cross-Domain Transfer 001 — independent cycle-space characterization

**Date:** 2026-11-09. **Status:** `PROVED` by mathematical argument, subject to independent review; `COMPUTATION_PASS` in an isolated Python runtime; `LEAN_VERIFIED := NOT_RUN`; `ACTUAL_TOOLKIT := NOT_RUN`; `NOVELTY := NOT_ESTABLISHED`.

## Stronger theorem: observed-cycle span determines information loss

Let `G=(V,E)` be any finite loopless undirected graph with a fixed orientation; let `F=F_p` with prime `p`. Regard one-chains as vectors in `F^E`, define the boundary `∂: F^E → F^V` by `∂(u→v)=[v]-[u]`, and let `Z_1(G)=ker ∂`. For each predetermined observed subgraph `H_i ⊆ G`, let `Z_1(H_i)` be its cycle space included in `Z_1(G)` by extending edge coordinates with zero. Define

`W = span_F ( ⋃_i Z_1(H_i) ) ⊆ Z_1(G)`.

The global edge-transport quotient is `Q(G)=F^E/im(δ_G)`, where `δ_G: F^V→F^E` is the transpose of `∂`. Its restriction observation map is `L:Q(G)→∏_i Q(H_i)` with each local quotient calculated independently, without overlap synchronization.

**Cycle-span transfer theorem.** Set `b=dim Z_1(G)` and `s=dim W`. Then

1. `rank L = s` and `dim ker L = b-s`.
2. Global gauge-class recovery from all the local gauge quotients is possible exactly when `W=Z_1(G)`.
3. If the global gauge class is uniformly distributed, its information loss is `(b-s) log₂ p` bits and optimal full-class reconstruction succeeds with probability `p^{-(b-s)}`.

This is an **explicit graph-theoretic criterion** for an information-theoretic question. The criterion requires calculating a span of *embedded local cycles* rather than searching over edge gauge orbits or all possible decoders.

### Proof

Use the nondegenerate standard dot product on `F^E`. The orthogonal complement of `im δ_G = im ∂ᵀ` is `ker ∂ = Z_1(G)`. Thus the pairing

`Q(G) × Z_1(G) → F`, `([a],z) ↦ ⟨a,z⟩`

is well-defined and perfect: if `a` pairs to zero with all cycles, it lies in `(ker ∂)⊥=im ∂ᵀ` and represents zero in `Q(G)`; dimensions agree. This identifies `Q(G)` canonically with `Z_1(G)^*`.

For each subgraph `H_i`, restriction `Q(G)→Q(H_i)` is dual under these pairings to inclusion `Z_1(H_i)↪Z_1(G)`. Consequently, `L` is dual to the linear map `⊕_i Z_1(H_i)→Z_1(G)` that sums the included cycle vectors. The image of this map is precisely `W`. Transposition preserves rank, so `rank L=dim W=s`. Rank–nullity gives `dim ker L=b-s`. The two recovery assertions and uniform-prior probability formula then follow from the exact fiber theorem in the preceding note. QED.

This result uses finite-dimensional linear algebra; no URF-specific axiom is introduced. It is not a new theorem of algebraic topology or a claim of originality.

### Sharp-radius corollary

For every simple cycle `C_n`, `n≥3`, every proper induced radius-`r` ball for `r<floor(n/2)` is a path. Its cycle space is zero, giving `W=0` and one hidden global cycle dimension. At `r=floor(n/2)` every ball is the entire cycle, giving `W=Z_1(C_n)`. Thus the sharp threshold and information-loss formulas of the companion note follow *without directly computing global gauge orbits*.

### Nontrivial partial-observation example

On the chorded five-cycle with edges `(0,1),(1,2),(2,3),(3,4),(4,0),(0,2)`, the global graph has `b=2` independent cycle dimensions. The radius-one induced-ball observations collectively span **one** dimension and leave **one** hidden. For `F₂`, the observer learns one bit of the global two-bit gauge class, with exactly one bit of conditional entropy and optimal full-class success `1/2`. On the three-path theta graph with path lengths 2, 3, and 4, radius-two observations likewise reveal one of its two independent cycle dimensions. These demonstrate partial information transfer, not merely the trivial all-or-nothing behavior of a single long cycle.

### Counterfactual boundaries

- **Raw edge data** or **gauge overlap transition functions** change the observation map; the theorem does not apply unchanged.
- **General field coefficients** are possible with the same linear-algebra proof, but the finite-class entropy expression presupposes a finite field of size `p` and uniform sampling.
- **Graphs with faces** require cellular cohomology and cocycle/flatness conditions; do not substitute graph `H¹` without proof.
- This does not imply a radius lower bound for unrestricted distributed computation, a result about Chronos `FMT.Types`/`FMT.Game`, Poincaré global descent, or fifth-dimensional physical necessity.

## Independent computation

`urf_cycle_span_transfer_20261109.py` computes each subgraph's *fundamental cycle vectors* using a local spanning forest, embeds them in the global edge space, confirms the incidence boundary is zero, and calculates their span rank. This is compared to the prior verifier's **independently implemented global-gauge quotient-restriction matrix**. The new cycle-span calculation does not call the former quotient rank algorithm to construct its rows.

Exact isolated result:

- 540 cycle/field/radius comparisons (`C_3`–`C_20`, `p=2,3,5,7`).
- 74 graphs (all labelled simple graphs on 2–4 vertices), with 1,074 graph/radius/field comparisons (`p=2,3,5`).
- 84 adversarial comparisons on bridge-connected triangles, chorded cycle, theta graph, and complete `K_5`.
- Complete run: `COMPUTATION_PASS`. Receipt SHA256 `90b2a601d7460b0b0cdf9253fc99fc0fbfadf99c4ea85602c5a9386bfe296bcd`.

Initial prototype failed with an `IndexError` because a local-ball-sized boundary array was used while embedding into global edge coordinates. The isolated code was repaired by sizing the boundary against all endpoints of global edges and the complete suite reran successfully. The failed attempt is not counted as evidence.

## Formalization boundary

`URF_ObservationFactorization_Candidate.lean` expresses the basic observation-factorization / collision obstruction in Lean Core with no project axioms or proof holes. Its status is **NOT_RUN**: Lean is unavailable in the isolated execution environment, and the user's Mac remains authoritative. It is deliberately limited to the abstract reconstruction core; it does not claim the cycle-space or information-theory theorem has been Lean verified.

**Weakest remaining Lean lemma for the full transfer:** for a finite oriented graph and selected subgraphs, establish the perfect pairing `Q(G) ≃ₗ[F_p] (Z₁(G) →ₗ[F_p] F_p)` and prove that the induced restriction map is the transpose of the inclusions `Z₁(H_i) ↪ Z₁(G)`. All rank, cycle and entropy corollaries depend on this precise interface.
# URF: Sharp Adaptive Reconstruction Threshold for Finite Graph Observations

**Date:** 2026-11-23. **Status:** `PROVED` (self-contained finite mathematical argument),
`COMPUTATION_PASS` (strictly bounded independent tests), `LEAN := NOT_RUN`.
**Independent scholarly review / novelty:** `OPEN` / `NOT_ESTABLISHED`.
**Repository publication:** `NONE`. No Mac checkout or current local HEAD/status was inspected.

## 1. Sources inspected and relationship to existing results

- `inaciovasquez2020/urf-core`, main `lean/URF/Foundation/SharpCliqueEntropy.lean`
  and `research/certificates/entropy_bridge/SHARP_CLIQUE_ENTROPY_CHECKPOINT.md`:
  finite-field graph observation kernels, sharp uniform entropy formula (previous work).
- `inaciovasquez2020/urf-core` PR #597, **draft / not merged** at remote
  head `8e3857350353e43f3e1f93122e5269148c9f1d05` when inspected;
  `research/multiscale-information-recovery/README.md`:
  general-radius cycle span, entropy, reconstruction, persistence, complexity.
  Receipt `research/certificates/general_radius_support/VERIFICATION.md`
  reports Lean verification and 54 axiom audits, not independently reproduced here.
  PR body references an *older* head; promotion must use the actual head and its receipts.
- `inaciovasquez2020/chronos-urf-rr`, main
  `docs/research/s3_three_loop_reconstruction_20261118.md`:
  nonabelian S3 shared-root mixed-word reconstruction, a distinct model.
- Literature context: finite graph homology/cycle bases and linear representable
  entropic matroids; the present mathematics is assembled from classical linear
  algebra and information theory, not claimed as a new general theorem.

**Non-duplication boundary:** The equality of graph-local entropy to hidden rank,
including uniform decoding probability before extra measurements, is **existing**
URF work. The additional result proved below is an **optimal query-complexity
threshold against arbitrary adaptive q-ary protocols**, with an explicit cycle
measurement construction attaining the bound, for **every radius**. It is not a
new entropy upper bound and not a claimed physical 5D consequence.

## 2. Precise observation model

Let `G=(V,E)` be any finite, connected, undirected simple graph with at least
one vertex, and let `K=F_q` be a finite field, `q>=2`. Choose an orientation on
all edges. Let `C_1=K^E`, `C_0=K^V`, `∂_1:C_1→C_0` the incidence boundary,
`Z=ker ∂_1` the graph cycle space, and `b=dim_K Z=|E|-|V|+1`.

An edge-transport configuration for the **abelian additive group** `(K,+)` is
an edge cochain `a∈C_1^*`. Vertex-gauge potentials change it by an element of
`im(∂_1^*)`. The global gauge classes are canonically

`X := C_1^*/im(∂_1^*) ≅ Z^*`,

via evaluation on cycles. This identity is exact: the kernel of restriction
`C_1^*→Z^*` is `im(∂_1^*)` by finite-dimensional annihilator duality.

For a vertex `v` and radius `r∈N`, take the induced subgraph on the closed
radius-`r` ball. An observer receives the **independently gauge-quotiented**
restriction of the connection to *each* such ball, not coordinated edge labels
or overlap gauge transformations. Let `R_r≤Z` be the span of all cycles
supported in one of these balls. All the local gauge-class information is
exactly the linear map

`O_r : Z^* → R_r^*`, `O_r(x)=x|_{R_r}`.

Set `d_r := dim_K(Z/R_r) = b−dim_K(R_r)`.
For finite simple graphs, the already established radius-support relation is
`R_r = span{cycles supported on at most 2r+1 edges}`; at `r=1`, `R_1` is the
span of triangle boundaries (the clique-complex 2-boundaries).

## 3. NEW: sharp adaptive q-ary query threshold

**Theorem (exact recovery threshold).** Draw `X` **uniformly** from the `q^b`
global gauge classes. Give a decoder `O_r(X)` for free and allow at most `m`
subsequent queries. Each query yields **at most q possible answers**, and may
be nonlinear and chosen adaptively based on the local observation and prior
answers. Randomized query choices and randomized decoding are permitted.
Then

    P[decoder identifies X exactly] ≤ min(1, q^(m−d_r)).       (1)

Moreover, equality is attainable by nonadaptive linear cycle-evaluation
queries. Consequently **the minimum number of extra q-ary measurements for
error-free universal reconstruction is exactly d_r**. This includes the
worst-case requirement of correctness for every global gauge class.

Under the same uniform input, for any such query transcript `T`,

    H(X | O_r(X), T) ≥ max(0,d_r−m) log q,                    (2)

where entropy uses natural logarithms. Equality is attainable by those same
nonadaptive cycle probes. Under a *fixed* family `z_1,...,z_m∈Z` of linear
cycle probes, putting `s=dim(R_r+span(z_1,...,z_m))−dim R_r`, the sharper
exact formulas hold:

    H(X | O_r(X), x(z_1),...,x(z_m)) = (d_r−s) log q,         (3)
    P_optimal_exact = q^(s−d_r).                             (4)

The formulas apply to the full **global gauge class**, not merely a selected
invariant of it. They make no claim about arbitrary nonabelian gauge groups.

### Proof

(1) The restriction `O_r` is surjective because every linear functional on
`R_r` extends to `Z`. Its kernel is the annihilator `R_r^⊥`, with dimension
`d_r` and cardinality `q^d_r`. Thus each local observation has exactly
`q^d_r` compatible global classes, uniformly distributed conditionally on that
observation.

Fix any local observation `y` and (for randomized methods) condition on the
internal random seed. A decision tree of depth at most `m` with at most `q`
possible answers at every node has at most `q^m` leaves, including trees with
early stopping. At any leaf a full-class decoder can correctly name **at most
one** of the `q^d_r` equally likely input classes. Conditional success is thus
at most `min(q^m,q^d_r)/q^d_r`. Averaging over `y` and the random seed proves
(1). The same conclusion holds for stochastic observations because a channel
with at most `q^m` possible transcripts has uniform-prior optimal decoding
success at most `q^m/q^d_r`.

(2) From the uniform fiber law,
`H(X|O_r(X))=d_r log q`. A transcript with at most `q^m` possible values has
`I(X;T|O_r(X))≤H(T|O_r(X))≤m log q`, even when queries are adaptive. The
nonnegativity of conditional entropy gives (2). Internal decoder/query
randomness may be conditioned on and averaged; it cannot enlarge a channel's
information budget.

(3–4) For chosen linear probes, the joint observation is the restriction map
`Z^*→W^*` with `W=R_r+span(z_i)`. It is surjective. Its fibers have cardinality
`q^(dim Z−dim W)=q^(d_r−s)`. Uniform input gives exactly the Shannon entropy
and maximum a posteriori decoding probability stated in (3–4).

**Attainment:** Choose a basis of `Z/R_r`, and lift it to
`z_1,...,z_{d_r}∈Z`. For `m≤d_r`, the first `m` lift evaluations increase
observation rank by `m`, so the posterior has `q^(d_r−m)` elements, and
(1–2) are equalities. For `m≥d_r`, `d_r` such probes give a full dual basis
modulo `R_r` and reconstruct the global class exactly. QED.

## 4. Constructive examples and sharpness

| Graph / observer | `b` | `dim R_r` | `d_r` | Uniform exact success before probes | Extra probes to 100% |
| --- | ---: | ---: | ---: | --- | ---: |
| Six-cycle `C6`, radius 1, `F2` | 1 | 0 | 1 | 1/2 | 1 |
| Six-cycle `C6`, radius 2, `F2` | 1 | 0 | 1 | 1/2 | 1 |
| Six-cycle `C6`, radius 3, `F2` | 1 | 1 | 0 | 1 | 0 |
| Triangular prism, radius 1, `F2` | 4 | 2 | 2 | 1/4 | 2 |
| Triangular prism, radius 1, `F3` | 4 | 2 | 2 | 1/9 | 2 |
| Complete graph `K4`, radius 1, `F2` | 3 | 3 | 0 | 1 | 0 |
| Wedge of two squares, radius 1, `F2` | 2 | 0 | 2 | 1/4 | 2 |

For the `F2` triangular prism, one well-chosen nonlocal bit raises optimal
success from `1/4` to `1/2`, and two to `1`; no adaptive protocol with only
one binary response can do better. A **redundant** probe changes neither
entropy nor reconstructability. Probes complementing `R_r` are nonlocal in
general; they cannot be silently treated as available inside the original
radius-r observation channel.

### Minimum-cycle-basis formula (corollary)

Let `B={c_1,...,c_b}` be any *minimum-total-edge-length cycle basis*
(over the specified coefficient field), and write `ell_i` for the number
of edges in the simple cycle `c_i`. The greedy algorithm for the linear
matroid of simple-cycle vectors, ordered by length, has the property that
its chosen vectors of length at most `k` form a basis of the span of all
simple cycles of length at most `k`. The multiset of chosen lengths is the
same for every minimum-weight basis: otherwise the first rank discrepancy
would permit exchanging a longer basis vector for a shorter cycle and
strictly lowering the total weight. Because the graph cycles of support
at most `k` are spanned by the simple cycles of length at most `k`, the
radius-support theorem gives the explicit reconstruction formula

    minimum_extra_qary_queries(G, r) = #{i : ell_i > 2*r+1}.

This turns the abstract rank `d_r` into a count of persistent
cycle-basis features. It is a statement about finite graph cycles and
independently gauge-quotiented radius balls, *not* a Rips persistence
or physical spacetime theorem. It is a corollary of the mathematical
arguments in URF Core PR #597, rather than a separate novelty claim.

## 5. Independent finite verification

Source: `verify_multiscale_adaptive.py` (standard-library Python, no source
repository modifications). It uses two generators for radius-local cycle
spaces (all simple cycles contained in balls vs. all simple cycles of bounded
length), exact modular Gaussian elimination, explicit dual coordinate
observations, full enumeration of local and augmented observation fibers, and
an independent *raw edge-label / vertex-gauge orbit* check. The companion
`verify_urf_probe_completion.py` checks the radius-one/triangle form.

**Actually executed in the assistant's temporary container, not the Mac**:

- Python `3.13.5`.
- `F2`: all `771` connected labeled simple graphs with 2–5 vertices.
- `F3`: all `43` connected labeled simple graphs with 2–4 vertices.
- Six-/seven-cycles, triangular prism, wedge of squares, and `K5`, additionally
  checked over `F2`, `F3`, and `F5`.
- Total: **829 graph/field instances**, **4,065 graph/radius instances**, **5,609 probe-depth checks**, **218,940 enumerated augmented states**, **28,509 raw gauge states**.
- Full gauge-orbit controls: 5, including triangular prism over `F3`
  (`19,683` raw assignments, `81` gauge orbits).
- All exact rank, fiber-size, radius/support equivalence, and reconstruction
  assertions passed. No unexpected collision. Finite tests are **not** a proof
  of the unrestricted theorem.
- Time guard: `65 s`; state guard: `100,000` per graph/radius; hitting either is
  `INCOMPLETE`, not `PASS`.
- Script SHA-256:
  `15afbdee1e6d12041b5f357b8db76458745ab4834146cb570d6812a68901c4b7`.
- Raw receipt SHA-256:
  `786395d8370a3f99d6027b3cf3f568ec68169c25bd36449a2d92d2a332bf061e`.

## 6. What this strengthens, and what it does not

**Adds an optimal solution rather than only an obstruction:** identifies the
smallest number of additional global measurements, shows adaptivity cannot
beat the stated threshold, and gives an explicit attaining construction.

**Connects URF's precise concepts:** locality (cycle subspace `R_r`), finite
capacity (q-ary response budget), information loss (`d_r log q`), and
reconstruction (`m=d_r`). The statement remains valid at all graph radii and
is testable via rank certificates. It supports URF Core / Chronos-style finite
information modeling **without** assuming a physical interpretation.

**Limits:** The theorem does not imply that the requisite nonlocal cycle
measurements are physically accessible. The `F_q` additive gauge group is
abelian; the S3 relative-conjugation result must remain a separate theorem.
The decoding probability assumes the uniform distribution on *global gauge
classes*. Repeated unlimited queries, coordinated overlap data, and larger
answer alphabets can change the bounds. It does not imply fifth-dimensional
necessity, a global URF law, Poincare, or a complexity-class separation.

**Novelty:** The underlying information-theoretic decision-tree argument,
duality, homology quotient, and rank-counting are classical. The contribution
here is the tight integration with the user's already formalized multiscale
observation models. Independent novelty review and a journal-level claim of
originality are not established.

## 7. Exact next implementation target (not performed)

Repository: `inaciovasquez2020/urf-core`; inspect *current* PR #597 HEAD first
(it was `8e3857350353e43f3e1f93122e5269148c9f1d05` when read). Prefer a
small isolated theorem module in `lean/URF/Foundation` after exact-head build
and axiom checks. Formal obligations:

1. For any `S≤Z` and finite list of `z_i:Z`, characterize the kernel of
   `Z*→S* × (Fin m→K)` as `(S+span{z_i})^⊥`.
2. Show its finrank and exact cardinality `q^(dim Z−dim(S+span{z_i}))`.
3. Construct a complement basis and prove minimum *linear* probe count `d`.
4. Separately formalize the adaptive **decision-tree cardinality** bound,
   maintaining the q-ary answer and uniform prior hypotheses explicitly.
5. Integrate using existing `SharpCliqueEntropy` and `GeneralRadius*` modules;
   run exact Lean compilation and `#print axioms` on load-bearing declarations.

**No branch write, commit, push, or merge performed.** Do not mark this
`LEAN_VERIFIED` from the mathematical proof or finite Python audit alone.

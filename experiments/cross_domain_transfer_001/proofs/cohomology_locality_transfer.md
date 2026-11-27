# URF Cross-Domain Transfer 001: Cohomological Observation–Information Theorem

**Date:** 2026-11-09  
**Status:** `PROVED` (self-contained mathematical argument, subject to independent review); `COMPUTATION_PASS` (bounded exact tests); `LEAN_VERIFIED := NOT_RUN`; toolkit CI `NOT_RUN`; `NOVELTY := NOT_ESTABLISHED`.  
**Domains:** graph cohomology / gauge transport → bounded-locality observation and finite-field information theory.  
**Reference:** URF formalization schema in `inaciovasquez2020/urf-core` README on `main` (merge `f03a5ad38ccd307d3f2e79996e1884b0eaa7a92d`); toolkit investigation via `inaciovasquez2020/chronos-urf-rr` PR #1338, exact source HEAD `b0fd6ef97cf0b73658ad7067d0272084c2d60622`. The toolkit's existing `urf_ai.benchmark.cycle_witness` tests locality-versus-connectivity for cycles; the present module adds gauge-equivalence classes, cohomology rank, and exact information accounting. It has not been imported into that draft PR.

## 1. Formal URF instance

Fix a prime `p` and a finite undirected loopless graph `G=(V,E)` with an orientation selected for each edge. Set `F=F_p`. An edge connection is `a ∈ C¹(G; F) = F^E`. A vertex gauge `g ∈ C⁰(G; F) = F^V` acts by `a ↦ a + δg`, where `(δg)(u→v)=g(v)-g(u)`.

Define the global *gauge-class space*

`Q(G)=C¹(G;F)/im(δ_G) = H¹(G;F)`.

No face-flatness constraints are imposed: this is a one-dimensional graph, not a 2-complex. Let `H₁,…,H_t` be predetermined subgraphs of `G` with inherited edge orientations. Restriction of connections descends to a well-defined linear map

`L_H : Q(G) → ∏_{i=1}^t Q(H_i),     [a] ↦ ([a|_{H_i}])_i`.

**Observation boundary:** each `Q(H_i)` is calculated *modulo its own independent local vertex gauge*. The observer receives no raw edge labels, global gauge fixing, transition functions between local gauges, or overlap synchronization. It may postprocess the entire tuple of local quotient classes without resource restrictions. This is the precise URF observation map `O`; the resource bound `B` is the family of observed subgraphs (for the radius corollary, induced balls). The target invariant is the full global class or a specified function of it. Proof/test receipts are the verification component `C`.

## 2. Theorem: exact cohomology-to-information transfer

**Theorem (finite cohomological observation transfer).** For any finite loopless graph `G`, any prime `p`, and any fixed family of subgraphs `H_i` as above, write

`b = dim_F Q(G) = |E| - |V| + components(G)`,  
`rho = rank_F L_H`,  
`k = b-rho = dim_F ker(L_H)`.

Then:

1. **Exact global recovery criterion:** A function `D` of the observed tuple recovers the full global gauge class on *all* inputs if and only if `k=0`.
2. **Arbitrary invariant criterion:** A target `f:Q(G)→T` is exactly recoverable if and only if `f(x+h)=f(x)` for every `x∈Q(G)` and every `h∈ker(L_H)`. If `f` is linear, this reduces to `ker(L_H) ⊆ ker(f)`.
3. **Exact information loss:** If global classes `X` are sampled uniformly from `Q(G)` and `Y=L_H(X)`, then

   `H(X|Y)=k log₂ p`,  
   `I(X;Y)=rho log₂ p`.

4. **Sharp optimal reconstruction success:** Under the same uniform prior, any deterministic or randomized full-class decoder from `Y` has success probability at most `p^{-k}`, and this bound is attained by selecting any one representative in each observation fiber (or sampling uniformly from it).

These conclusions have no unverified hypotheses; they follow from the defined observation model, linear algebra, and elementary finite probability. They are **not** statements about all distributed algorithms, all local logics, or all physical gauge measurements.

### Proof

Choose a spanning forest `T` of `G`. On each component, fixing a root gauge allows one to cancel edge labels successively along `T`. Exactly the `|E|-|V|+components(G)` non-tree edges remain, freely parameterizing `Q(G)`; hence `dim Q(G)=b`. The same argument holds for each `H_i`.

If `a` is replaced by `a+δ_Gg`, its restriction to `H_i` is changed by `δ_{H_i}(g|_{V(H_i)})`; therefore `L_H` is well-defined and linear on the quotient. By rank–nullity, every nonempty fiber `L_H^{-1}(y)` is a coset of `ker(L_H)` and has exactly `p^k` elements. Full-class exact recovery is possible iff all these fibers are singletons, i.e. `k=0`. For a general target `f`, the value is decodable from `y` iff it is constant on each fiber; for linear `f`, this is equivalent to vanishing on `ker L_H`.

Under the uniform distribution on `Q(G)`, all nonempty fibers have the same cardinality `p^k`, and conditioning on any observation produces the uniform distribution on its fiber. Consequently `H(X|Y)=log₂ p^k=k log₂ p`. Since `H(X)=b log₂ p`, the mutual information equals `(b-k)log₂ p=rho log₂ p`. For any fixed observation `y`, a decoder—randomized or not—cannot select the correct member of its uniform fiber with probability greater than `1/p^k`. Averaging over observations gives the optimal bound, achieved by picking one representative per fiber. QED.

## 3. Sharp transfer to bounded-radius locality on cycles

Let `G=C_n` for `n≥3`, let `H_v=G[B_r(v)]` be the *induced* radius-`r` ball at `v`, and take all `n` such independently gauge-quotiented observations.

**Corollary (exact cycle threshold).** Put `d=floor(n/2)`, the diameter of `C_n`. Then:

- For `0≤r<d`, every induced `H_v` is a path (or isolated vertex), hence `Q(H_v)=0` and `L_r=0`. Since `dim H¹(C_n;F_p)=1`, `k=1`. Every global holonomy class has identical local observation data. Thus no decoder can recover global holonomy exactly, and for uniform holonomy its maximum success probability is `1/p` and conditional entropy is `log₂ p` bits.
- For `r≥d`, every ball is the entire graph. Its local quotient class is the global quotient class, so `L_r` is injective, `k=0`, and exact recovery is possible.

Therefore the **sharp radius threshold is `r*=floor(n/2)`** for this observation model; no weaker radius suffices, and that radius does suffice.

**Example:** On `C_10` with `F_2`-valued transport, the ten radius-4 local gauge classes cannot reveal the global parity holonomy, even when combined. Their mutual information about the global holonomy is zero, and optimal recovery success is `1/2`. At radius 5, each observation includes the entire cycle, and recovery is exact.

### Proof of corollary

For `r<floor(n/2)`, the radius-`r` ball in a cycle omits at least one vertex, and the induced connected subgraph is a path: it has no cycle, so its degree-one cohomology vanishes. The global cycle has `n` edges, `n` vertices, and one component, giving dimension `1`. Apply the theorem with `rho=0`. For `r≥floor(n/2)`, the maximum graph distance from any root is at most `r`, so every ball is `C_n` and at least one quotient restriction is the identity. Apply the theorem with `rho=1`. QED.

## 4. Transfer significance and counterexamples to overgeneralization

This is a genuine *mathematical transfer* from topology (nonzero `H¹`, cycles, gauge equivalence) to a sharp information-theoretic lower bound and impossibility statement for a specified locally restricted observation model. The transfer involves established ingredients—graph cohomology, rank–nullity, and entropy of uniform linear images. **No claim of a novel theorem or fundamental unification is made before an independent literature review.**

Crucial **negative controls**:

1. **Raw edge observations:** if local observations include individually oriented raw edge labels in a shared gauge rather than local gauge classes, radius-1 observations can reveal every edge. Their union permits exact global holonomy recovery. The cycle lower bound does not apply.
2. **Overlap synchronization:** if the observer receives transition functions identifying local gauges on overlaps, it may reconstruct a global connection even below `r*`. The theorem assumes independent local quotients without such data.
3. **Distributed communication:** multiple rounds can exchange new data; a one-shot radius lower bound is not a runtime lower bound for arbitrary distributed algorithms or a complexity separation.
4. **Higher-dimensional faces:** adding face-flatness constraints changes the domain from unrestricted graph cochains to cocycles of a 2-complex. The same linear-fiber argument still applies to any induced linear observation map, but the cycle corollary must be re-established for that complex.
5. **Non-prime/nonabelian groups:** the vector-space rank and entropy formulas are specific to finite fields. Do not assume them for arbitrary group-valued connections.
6. **Chronos FMT semantics:** no equivalence with the existing `FMT.Types`/`FMT.Game` structures is established. A Lean declaration-level correspondence remains open.
7. **Physics:** the result does not require or demonstrate an extra dimension, new physical laws, or observational predictions.

## 5. Validation and toolkit gate

The independent exact-arithmetic verifier `urf_cross_domain_transfer_20261109.py` computes the map using spanning-forest representatives, Gaussian elimination modulo `p`, independently enumerates every global gauge class to calculate observation fibers, and checks gauge-class classification against explicit gauge orbits on every simple graph with 2–4 vertices over `F_2`. It also tests adversarial multi-cycle graphs over `F_2` and `F_3` and the sharp cycle threshold over `F_2`, `F_3`, `F_5` for lengths 3–15.

Run without dependencies:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B urf_cross_domain_transfer_20261109.py --max-cycle 15 --seconds 35 --out urf_cross_domain_transfer_receipt_20261109.json
```

**Observed local result:** `COMPUTATION_PASS`: 243 cycle checks; 74 exhaustive small-graph gauge-orbit checks; 716 arbitrary-graph/radius/field rank-versus-fiber tests; 56 targeted multicycle checks. This is bounded corroboration, not the theorem's logical proof. `TIME_GUARD` or resource exhaustion is `INCOMPLETE`, not `PASS`. Runtime tests performed in an isolated Python environment, **not on the user's Mac**.

**Toolkit integration boundary:** actual `urf_ai.assistant.answer('cycle_locality')` / `urf_ai.benchmark.cycle_witness` from experimental PR #1338 were inspected, but **not executed** in the isolated runtime. The toolkit's classifier must continue to return an incomplete theorem ledger absent a genuine proof-checker receipt; the human mathematical proof above and the finite audit do not substitute for Lean verification or independent review. Integration and complete toolkit CI are `NOT_RUN`. Do not merge into the experimental draft or promote to the canonical URF theorem layer until the on-Mac/source-pinned toolkit validation and appropriate formalization gates are completed.

## 6. Most useful next formal obligation

Construct in Lean a canonical `F_p` cochain quotient `Q(G)` and restriction maps for induced subgraphs; prove that the restrictions descend to the quotient and have coset fibers of cardinal `p^(dim ker)`. The cycle-radius specialization and entropy corollary then follow. This is a **high-impact formalization candidate**, but no Lean file in this artifact is labeled verified. Avoid introducing project axioms, `sorry`, `admit`, or `native_decide`.

## 7. Prior literature / novelty discipline

- *Finite group gauge theory on graphs and gravity-like modes* (2025), especially its discussion of spanning-tree gauge fixing and fundamental holonomies: https://doi.org/10.1016/j.nuclphysb.2025.117117
- Raymond W. Yeung, *Information Theory and Network Coding*, discussion of entropy/rank for linear transformations of finite-field uniform variables (Theorem 7.3 in the available tutorial): https://iest2.ie.cuhk.edu.hk/~whyeung/publications/tutorial.pdf

Both the holonomy classification and the finite-field rank/entropy identity are known. The combined URF presentation is useful as a reproducible bridge and sharply scoped formalization target; **novelty has not been established**.

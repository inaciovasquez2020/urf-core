# Sharp radius-local cycle-information minimax theorem

Status: **PAPER_PROVED; PARTIALLY_LEAN_VERIFIED**  
Date: 2026-11-25. Branch: `research/exact-local-entropy-minimax-20261125` (draft PR #603).  
Do not report a complete Lean verification of the radius-local graph theorem.

## Theorem

Fix integers `r >= 0`, `N >= L >= max(3, 2*r+2)` and a finite field
`F_q` of cardinality `q >= 2`. Let `C(N,L)` be the finite simple graphs
that are disjoint unions of cycles, each of length at least `L`, with
exactly `N` vertices. Let `O_r(G)` be the multiset of isomorphism classes
of **rooted induced radius-r neighborhoods**, including multiplicities.
Put `I_q(G) = (dim_Fq Z_1(G;F_q))*log(q)`. For deterministic estimators
`f` acting only on `O_r(G)`:

```
inf_f sup_{G in C(N,L)} |f(O_r(G)) - I_q(G)|
  = ((floor(N/L)-1)/2)*log(q).
```

The same bound applies to random estimators evaluated by worst-case
expected absolute loss, since randomization cannot improve the endpoint
two-point lower bound and the deterministic midpoint attains it.

## Proof

1. Each rooted radius-r induced ball in a cycle of length `m>=L` is
   a path with `2r+1` vertices, rooted at its central vertex. Indeed the
   two radius-r arcs from the root have disjoint non-root vertices; their
   boundary points have no adjacent wraparound edge when `m>=2r+2`.
   Thus `O_r(G)` is exactly `N` copies of the same rooted path for every
   `G in C(N,L)`. This is graph-local **indistinguishability**, not an
   assumption of the scalar minimax lemma.
2. Each cycle contributes one independent vector to `Z_1(G;F_q)`;
   hence `dim Z_1(G;F_q)=c(G)`, the number of connected components.
   Every cycle has at least `L` vertices, giving
   `1<=c(G)<=M=floor(N/L)`.
3. The single `N`-cycle has `c=1`. The graph with `M-1` cycles of
   length `L` and one cycle of length `L+N mod L` has `c=M`.
   This construction works without divisibility assumptions.
4. These endpoint graphs have identical observations, but information
   values `log(q)` and `M*log(q)`. The triangle inequality gives a
   worst-case error at least `(M-1)*log(q)/2` for any estimator.
   The constant midpoint `(M+1)*log(q)/2` attains that error.

## Exact formal bridges (2026-11-25 audit)

**Rooted ball:** For each component size `m >= L >= 2*r+2` and root
`x ∈ Fin m`, the map `d ↦ (x+d) mod m` for integers `-r <= d <= r`
is a root-preserving bijection from the path `[-r,r]` to the
graph-distance-`r` ball of `x` in `C_m`. Moreover, two images are
adjacent exactly when `|d-e|=1`: the potentially exceptional
wraparound pair would need `m=2*r+1`, which is excluded. The
resulting induced-ball isomorphism is independent of `m,x`, hence all
rooted-ball multisets coincide. The cutoff is sharp for this claim:
at `r=1,m=3`, the ball is a rooted triangle, rather than the rooted
three-vertex path in `C_6`.

**Cycle-space dimension, every field:** With `B : K^E → K^V` the
oriented incidence boundary, its dual sends vertex potential `f` to
the edge differences `f(head(e))-f(tail(e))`. A potential lies in
`ker(Bᵀ)` exactly when it is constant along each graph edge, hence
along each path; therefore `ker(Bᵀ) ≃ (π₀(G) → K)` and
`rank(B)=|V|-|π₀(G)|`. Rank-nullity gives
`dim(ker B)=|E|-|V|+|π₀(G)|`. For a disjoint union of cycles,
`|E|=|V|`, yielding `dim Z₁(G;K)=|π₀(G)|`.
This proof is characteristic-independent. Lean must additionally
show that the chosen ordered-edge incidence linear map is the same
boundary `B`; replacing it by a surrogate would not discharge the
stated obligation. The mathematically correct natural-number
subtraction is `|E|-(|V|-|π₀(G)|)` (not the potentially truncated
`(|E|-|V|)+|π₀(G)|`).

**Finite adversarial recheck (non-Mac, exact arithmetic):** Independently
enumerated all nondecreasing integer partitions of `N` into parts
`>=L`, for `3<=N<=36`. An explicit signed-displacement map was
checked against every induced rooted adjacency pair across
4,012 parameter triples `(N,L,r)` and 22,944 partition/observation
instances, with zero failures. Independently constructed the GF(2)
oriented incidence rows as integer bit vectors and applied XOR
Gaussian elimination to 11,408 distinct graph partitions; in all
cases the exact rank was `N-c`, so nullity was `c`. These checks
are **COMPUTATION_PASS**, not a universal theorem and not Lean
compilation. No Mac computations or downloads were performed.
The graph proof above, rather than these finite checks, supplies
the unrestricted mathematical justification.

**Related formalization:** The repository
`wwawrzy/paying-for-fractional-error-lean`, at commit
`79218794d8ea0b8a4e01c3f9647e6b71cd05eb56`, contains
`GraphTheory/SimpleGraph/CycleCutDimensions.lean` with a graph
cycle-space dimension formula over `ZMod 2`. Another reference,
`Shilun-Allan-Li/tcslib` at
`0fbb65f2072e5cea340e1f69e0bdcd57cd56945b`, has an oriented
real-field incidence rank formula. Neither was compiled or imported
against this repository's pinned Mathlib, and neither is evidence
that the *current* ordered-edge kernel bridge is Lean-verified.

## Verification boundary

- Lean verified: exact scalar and observation minimax; extremal cycle
  partitions; simple graph construction; vertex cardinality;
  reachability iff equal component index; connected-component quotient
  equivalence and exact connected-component cardinality.
- The observed vertex-count (radius-zero) minimax assembly is submitted
  separately for compiler/axiom verification.
- OPEN IN LEAN: induced radius-r rooted-ball equivalences for all allowed
  variable cycle lengths; formal identification of the constructed
  graph's `Z_1(-;F_q)` dimension with its component count; hence the
  **full radius-local entropy theorem is not LEAN_VERIFIED**.
- Any Hanf-locality / first-order quantifier-rank consequence requires
  a separate bound and formalization; it is not part of this certificate.
- Novelty and external independent review: NOT_ESTABLISHED.

The main branch is unchanged. A green isolated Lean audit must not be
mistaken for merger, full pipeline completion, or novelty review.

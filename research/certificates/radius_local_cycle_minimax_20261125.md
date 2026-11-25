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

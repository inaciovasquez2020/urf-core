# Radius-local cycle spaces: nontrivial comparison theorem

Date: 2026-11-18
Status: **mathematical argument supplied; finite computation PASS; Lean formalization NOT_RUN**.
Field for computation: `F₂`. The mathematical statements hold over any field with a
fixed orientation of edges.

## Definitions

Let `G` be a finite undirected simple graph. Let `C(G;K)` denote the kernel of
its oriented edge-to-vertex incidence map over a field `K`.

Define `S_k(G;K)` as the linear span in `C(G;K)` of circulations
with at most `k` nonzero edge coefficients. This is the existing
`boundedSupportCycleSpace`.

Let `B_r(v)` be the set of graph vertices at distance at most `r` from
`v`. Define `R_r(G;K)` as the span of circulations whose support lies
entirely in the induced subgraph `G[B_r(v)]` for *some* `v`.

This radius-local construction is not yet defined in the verified Lean file.

## Theorem 1 — universal one-way inclusion

For all finite simple graphs, fields and nonnegative integers `k,r`:

`k ≤ 2*r + 1  ==>  S_k(G;K) ⊆ R_r(G;K)`.

### Mathematical proof

Every finitely supported circulation in a finite graph can be decomposed into
a linear combination of oriented simple cycles lying inside its support.
For an input circulation with support size at most `k`, each such simple cycle
has length at most `k`. If its length is `L`, choose any vertex `v` on
that cycle. Every other cycle vertex has *graph* distance at most
`floor(L/2)` from `v` (follow the shorter of the two arcs along the cycle).
When `L ≤ k ≤ 2*r+1`, this is at most `r`, so the full cycle lies in the
induced ball `G[B_r(v)]`. Thus each generator of `S_k` belongs to `R_r`,
and hence `S_k ⊆ R_r`.

The exact Lean formalization additionally requires the flow/circulation
decomposition lemma and the radius-ball definition.

## Theorem 2 — chordal-graph equality

If `G` is chordal (has no induced cycle of length greater than 3), then
for all `k ≥ 3` and `r ≥ 1`:

`S_k(G;K) = R_r(G;K) = C(G;K)`.

### Mathematical proof

Any simple cycle of length at least 4 in a chordal graph has a chord, splitting
its oriented circulation into a sum of circulations of two strictly shorter
cycles (orient consistently; cancellation occurs on the chord). Induction on
cycle length expresses every circulation as a linear combination of triangles.
Every triangle is supported on three edges, hence belongs to `S_k` when
`k ≥ 3`. Every triangle lies inside the radius-one ball around any of its
vertices, hence belongs to `R_r` when `r ≥ 1`. Both subspaces lie in
`C(G;K)`; equality follows.

This is a sufficient condition, not a characterization of all graphs for which
the two spaces agree.

## Sharp warning — unconditional equivalence is false

For `C6` over `F₂`, `S_6` has dimension 1 whereas `R_1` has
dimension 0. The one-way theorem does not apply since `6 > 2*1+1`.

## Exact computational audit

The companion `check_radius_inclusions.py` enumerates all labeled undirected
simple graphs on 1–5 vertices: `1+2+8+64+1024 = 1099` graphs.
For each graph, it enumerates all `F₂` edge chains exactly, finds the cycles,
constructs the spans by binary Gaussian elimination, and checks:

1. `S_k ⊆ R_r` for every `r=0,1,2` and `k ≤ min(|E|,2r+1)`.
2. For chordal graphs, `S_3=R_1` (and thus, by the mathematical argument,
   full equality under the theorem's stronger parameters).

Independent script-equivalent execution: **PASS** on 1099 graphs, of which
894 satisfy the chordality predicate.

This exhaustive finite check challenges the proposed theorem but does not
establish it over arbitrary fields or arbitrarily large graphs.

## Remaining verification obligations

1. Define `R_r` from `SimpleGraph` balls in Lean.
2. Prove finite-support circulation decomposition into simple cycles.
3. Prove `S_k ⊆ R_r` for `k ≤ 2r+1`.
4. Define chordality and prove the triangle decomposition/equality theorem.
5. Run exact-HEAD Lean builds and permitted-axiom audit before promotion.

Global URF rigidity remains OPEN. The uniform conditional entropy equality
remains LEAN_OPEN and is logically independent of these comparison results.

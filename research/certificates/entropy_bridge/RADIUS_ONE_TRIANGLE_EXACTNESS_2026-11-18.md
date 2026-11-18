# Universal radius-one cycle-space identity

Date: 2026-11-18
Scope: finite undirected simple graphs and arbitrary coefficient fields.
Status: **MATHEMATICAL PROOF**, **COMPUTATION_PASS**, **LEAN_FORMALIZATION_OPEN**.
This sharpens the previous sufficient-condition results and does not establish
any global URF rigidity claim.

## Exact statement

Let `C(G;K)` be the kernel of the oriented edge-to-vertex incidence
boundary over a field `K`. Let `S_k(G;K)` be the subspace spanned by
circulations with support on at most `k` edges. Let `R_r(G;K)`
be the span of circulations whose edges lie inside an induced
closed graph ball `G[B_r(v)]` for some center `v`.

**Theorem (radius-one exactness):** For EVERY finite simple graph `G`
and every field `K`,

`R_1(G;K) = S_3(G;K) = span_K{oriented triangle cycles of G}.`

No chordality, connectedness or positive-degree hypothesis is needed.
A graph with no triangles has both subspaces equal to zero.

## Proof

Fix a center `v`. Its induced closed radius-one ball is precisely the
subgraph on `{v} ∪ N(v)`. Every vertex `u ≠ v` in this induced ball is
adjacent to `v`; it is a cone over the graph induced by `N(v)`.

For each edge `{a,b}` between two neighbors of `v`, there is a
triangle `v-a-b-v`. Orient its incidence chain so that the coefficient
of the nonspoke edge `{a,b}` agrees with a given circulation `z` on
that edge. Sum these signed triangle cycles over all nonspoke edges of
`z`, with the same coefficients.

Subtracting the sum from `z` eliminates ALL nonspoke coefficients.
The remainder is a circulation supported only on the star edges
`{v,u}`. At each leaf `u`, conservation of boundary forces the
coefficient of `{v,u}` to vanish (because only that star edge is
incident to `u` within the support). Hence the remainder is zero.
Therefore every cycle in a radius-one ball lies in the span of
triangles. Since `v` was arbitrary, `R_1 ⊆ span(triangles)`.

Conversely, every triangle `a-b-c-a` lies inside the induced
radius-one ball around `a`, so `span(triangles) ⊆ R_1`.

Finally, over a simple graph with no loops or parallel edges, a
nonzero circulation supported on at most three edges must be a
scalar multiple of a triangle cycle: each nonzero incident vertex
needs at least two supported incident edges, and the only simple
cycle with at most three edges is a triangle. More generally, any
circulation with support of size ≤3 can be decomposed into simple
cycles in that support. Thus `S_3 = span(triangles)`.

The proof works over EVERY field, including characteristic two, since
it uses linear combinations with oriented signs, not positivity.

## Independent exact computational check

`check_radius_one_exactness.py` enumerates ALL labeled simple graphs
on n=1,...,6 vertices:

`1+2+8+64+1024+32768 = 33867` graphs, and 202013 vertex-ball instances.

For each closed radius-one ball, it computes the local cycle-space
dimension using `|E(B)| - |V(B)| + components(B)`, and independently
counts triangles through the center via edges within `N(v)`.
They agree in every instance. The local dimension identity is a
necessary consequence of the constructive triangle-basis proof
above, not by itself a universal proof. Exact check result: PASS,
33867 graphs and 202013 vertex-balls.

The mathematical proof gives the two subspace inclusions for all fields.
The numerical test independently challenges the central cone-basis step.

## Consequences and limits

* The preexisting generic inclusion `S_k ⊆ R_r` when `k ≤ 2r+1`
  becomes a FULL equality at the special pair `(k,r)=(3,1)`.
* In particular, the radius-one local cycle space can be represented
  with the existing bounded-support definition using `cutoff=3`.
* The previously constructed `C6` counterexample remains valid:
  `R_1(C6)=S_3(C6)=0` but `S_6(C6)=C(C6)` is one-dimensional.
* This identity does NOT assert equality for arbitrary `k,r`;
  for example `R_1=S_6` fails on `C6`.
* The conditional entropy upper bound for `concreteGraphChain G 3`
  is mathematically the radius-one observation bound, once the
  equivalence of observation definitions is formally supplied.

## Exact Lean obligation

1. Define induced closed balls and the radius-one local subspace.
2. Define oriented triangle circulations over an arbitrary field.
3. Prove the cone decomposition of a radius-one circulation using the
   explicit incidence boundary, with signs for ordered edges.
4. Show every support-≤3 circulation lies in the triangle span.
5. Establish `R_1 = boundedSupportCycleSpace G 3`; run Lean on the pinned
   toolchain and audit only `propext, Classical.choice, Quot.sound`.

No source code here has been Lean-compiled for this new theorem.

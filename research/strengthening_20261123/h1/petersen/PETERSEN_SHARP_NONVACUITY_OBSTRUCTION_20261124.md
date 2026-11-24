# URF H1: Petersen obstruction to cycle–orbit type splitting

Date: 2026-11-24. **Status:** PROVED (self-contained finite graph argument); COMPUTATION_PASS (two independent cycle-rank computations and 120 verified automorphisms); LEAN := NOT_RUN. This is a correction to an unverified lemma in URF documentation, not a new theorem in the literature.

## Target and source provenance

Repository: `inaciovasquez2020/urf-core`, main base `5deab2c9a4f57734e50d0e15e8effc9103128c3a`. File `papers/fo-k-locality/cycle_orbit_splitting.tex`, Git blob `016d1452401f485e8b920aae2324ca323f8890c4`, currently states:

> For degree bound Delta and local cycle complexity `CycComp_R(G) = max_v dim_F2 Z_1(B_{2R}(v))`, there exists a threshold `t*(k,Delta,R)` such that complexity at least the threshold forces two vertices with different `FO^k` radius-`R` types.

The file contains no nonvacuity requirement `t* <= sup_{degree <= Delta} CycComp_R`, no parameterized concrete type semantics, and no proof beyond a reference to Cycle Fan Predicate / EF Cycle-Linkage Trap.

Also inspect `papers/fo-k-locality/configuration_pumping.tex`, blob `4e9caabf860473c981d814942a92aae892220f46`. Its inference from repeated/equal local types to unequal local types does not follow; the two conclusions are logically opposite. Even the initial pigeonhole inference needs an explicit collection of more than `|T|` actual, distinguishable configurations, not merely a vector-space dimension without an encoding from independent cycles to configurations.

## Sharp theorem: no nonvacuous splitting threshold for Delta=3, R=1

Let `C` be the class of finite simple uncolored undirected graphs of maximum degree at most three, and let the rooted `FO^k` type be any isomorphism-invariant type of a vertex (in particular the ordinary `FO^k` type, with or without counting). Define

`CycComp_1(G) := max_v dim_F2 Z_1(G[B_2(v)])`, with induced closed radius-two balls.

**Proposition.** For every `k >= 1` and every real threshold `t`, the implication

`forall G in C, CycComp_1(G) >= t -> exists v,w, tp^FOk_1(v) != tp^FOk_1(w)`

is false whenever `t <= 6`; when `t > 6` it is true only vacuously, because the antecedent cannot occur. Consequently the paper's stated existence of some `t*` is formally trivial at these parameters and cannot supply any nonvacuous cycle-to-type-splitting mechanism.

**Proof.** Every radius-two ball of a degree-at-most-three graph is connected and has at most `1 + 3 + 3*2 = 10` vertices, by counting successive neighbors. If its vertex and edge counts are `n,m`, the degree bound gives `2m <= 3n`. Since it is connected, its cycle-space dimension is `m-n+1 <= n/2+1 <= 6`. Thus `CycComp_1(G) <= 6` for every graph in `C`.

Construct the Petersen graph as the Kneser graph `KG(5,2)`: its vertices are the ten 2-element subsets of `{0,1,2,3,4}`, and two vertices are adjacent iff they are disjoint. Every vertex is adjacent to precisely the three 2-subsets of its 3-element complement. Two intersecting, distinct 2-subsets have their union of size three, so the complementary 2-subset is adjacent to both. Therefore the graph is connected of diameter two. Its 10 vertices have degree three and hence 15 edges. The closed radius-two ball around every vertex is the entire graph, with cycle-space dimension `15 - 10 + 1 = 6`.

Every permutation of the 5 underlying labels induces an automorphism of this graph, and the symmetric group `S_5` acts transitively on 2-subsets. Consequently the graph has a single vertex orbit. Any isomorphism-invariant rooted vertex type takes the same value on all ten vertices; the proposed split is false for every `k`. For `t <= 6`, this graph satisfies the premise and violates the conclusion; for `t > 6`, the previously established uniform upper bound makes the premise impossible. QED.

This is stronger than an `FO^1`-only obstruction: transitivity makes any invariant rooted type constant even if the logic admits counting or arbitrary quantifier depth. It does **not** refute statements with externally named vertices, asymmetry assumptions, a distinguished root used as an additional constant, non-invariant vertex IDs, or different conclusions about classes of *tuples* or *cycles*. Those require a new precise theorem.

## Independent bounded check

`verify_petersen_cycle_split.py` (stdlib Python) constructs the Kneser graph, independently computes rank of the mod-two incidence matrix (`9`) and the cycle rank from a spanning forest (`6`), checks connectedness/diameter, verifies each of the 120 automorphisms induced by `S_5`, confirms a vertex orbit of size `10`, and checks the exact degree/radius bound `10` vertices, `15` edges, cycle dimension `6`.

Observed run: Python 3 in isolated assistant Linux container, exit code 0, receipt `PETERSEN_EXECUTION_RECEIPT.txt`. Script SHA-256 `466e6251f7eb8f76d21f5e420a601801127dab083550f9ae860ddab4a851c980`; receipt SHA-256 `6df2040445170ac4c414037a5657ad470294e938ea8cc9498c1fee63fac14229`. This is bounded computational evidence, not a formal Lean proof. The mathematical argument above independently proves the general threshold dichotomy for these fixed parameters.

## Necessary correction and impact

1. Do **not** use `Cycle--Orbit Splitting Lemma` to discharge H1 or any global entropy/computation separation. At `(Delta,R)=(3,1)` it is either false (nonvacuous) or true vacuously.
2. Add an explicit nonvacuity condition to future threshold claims, and separately prove that the hypotheses can force *asymmetric observable types*; cycle rank alone cannot do so in this class.
3. Correct `configuration_pumping.tex`: equality of types does not entail inequality of types. Pigeonhole requires an explicitly constructed map from a large finite set of distinct configurations to a bounded set of types; rank of a cycle space by itself is insufficient.
4. The actual algorithm-specific H1 remains OPEN. A fixed, repository-defined `R_repo`, exact logic/vocabulary, treatment of counting, and uniform variable bound must precede any locality proof.

No change is proposed to production Lean, and no mainstream mathematical novelty claim is made. This note is a research-only counterexample checkpoint pending independent review.

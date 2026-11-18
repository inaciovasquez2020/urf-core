# URF-Core radius-one entropy bridge: first clique homology

Date: 2026-11-18
Base published checkpoint: `a06477e82e96e90c316611c6bf71073e70297d62`
Research branch: `research/entropy-uniform-radius-audit-20261118`

**Status: MATHEMATICAL PROOF; COMPUTATION_PASS; LEAN_FORMALIZATION_OPEN.**
This is not an independent proof of global URF rigidity.

## Definitions

Let `G=(V,E)` be a finite simple graph, `K` a field and `X(G)`
its clique (flag) simplicial complex. Let
`C1=K^E` be the oriented edge-chain space and
`C0=K^V`. The existing `simpleGraphBoundary` is the
simplicial `∂1:C1→C0` for ordered edge orientations.

Let `C2` be the vector space with basis the triangles (3-cliques) of G,
with each triangle (a<b<c) oriented by increasing vertices.
Define `∂2(a,b,c) = (b,c) - (a,c) + (a,b)`.
Then `∂1 ∂2=0` by direct signed cancellation.

Write `Z1=ker ∂1` and `B1=im ∂2`.

The previously established *mathematical* radius-one cone theorem gives
`R1 = span{triangle circulations} = B1`.
Its Lean proof has NOT yet been compiled.

## Theorem A: exact local/global quotient

`H1(X(G);K) = Z1/B1 = Z1/R1`
by the definition of simplicial homology in degree 1.

This identification is canonical once graph orientations and the
triangle boundary map are fixed.

## Theorem B: the hidden observation is the dual of H1

The URF graph observation for the local subspace `R1⊆Z1` is

    restriction : Module.Dual K Z1 →ₗ[K] Module.Dual K R1.

The kernel is the annihilator
`Ann(R1)={ℓ∈Z1*: ∀z∈R1, ℓ(z)=0}`.

Every `ℓ∈Ann(R1)` uniquely factors through the quotient `Z1/R1`,
and conversely every functional on `Z1/R1` pulls back to a member
of `Ann(R1)`. These constructions are mutually inverse and linear.
Thus:

    ker(restriction) ≃ₗ[K] Module.Dual K (Z1/R1)
                        ≃ₗ[K] Module.Dual K H1(X(G);K).

In particular, for finite graphs:

    dim_K ker(restriction) = β1(X(G);K)
                           = |E| - rank(∂1) - rank(∂2).

Note that this equivalence is with the *dual* of homology, not
canonically homology itself.

## Corollary: topology-valued conditional entropy bound

For finite `K` with `q=|K|≥2`, any probability law on the
finite dual space `Z1*`, and its radius-one restriction observation,
the previously verified abstract linear conditional entropy bound gives

    H(input | observation) ≤ log |ker(restriction)|
                            = β1(X(G);K) * log q.

The equality `|ker|=q^β1` is elementary finite-dimensional linear
algebra. **Uniform-input equality** is mathematically true but remains
unverified in the Lean project; do not label it LEAN_VERIFIED.

When `β1=0`, the observation is injective and the conditional entropy
is zero for any input law. This is a consequence of the zero-dimensional
observation kernel, provided the observation is indeed defined on `R1`.

## Exact independent finite check

`check_clique_h1_entropy_bridge.py` enumerates all labeled undirected
simple graphs with `1≤|V|≤5` (1,099 graphs). For each graph and each of
the fields F2, F3, F5:

1. Construct the signed oriented incidence matrix `∂1`.
2. Construct the signed triangle-boundary matrix `∂2`.
3. Check every entry of `∂1*∂2` is exactly zero modulo p.
4. Compute ranks by modular Gaussian elimination.
5. Check `β1 = |E|−rank(∂1)−rank(∂2) ≥0`.

**Actual independently executed result: PASS.** For each field:
`β1=0`: 909 graphs; `β1=1`: 180; `β1=2`: 10.
Total graph-field cases: 3,297.

Finite checks are not the general proof or Lean compilation receipt.

## Precise Lean obligations

1. Establish `R1 = B1` using the existing `OrderedEdge` and
   `simpleGraphBoundary`. The spoke-only lemma remains a prerequisite.
2. Define triangle chains and their boundary, verify `∂1∘∂2=0`.
3. Define the first-homology quotient `Z1/B1` and identify the graph
   observation annihilator with its dual.
4. Derive the dimension and finite-cardinality identities.
5. Specialize the existing verified entropy inequality; run an
   exact-HEAD build and axiom audit.

The separate uniform conditional entropy Lean candidate is still
NOT_RUN and must not be presented as certified.
No merge or modification of the Mac's local repository is asserted.

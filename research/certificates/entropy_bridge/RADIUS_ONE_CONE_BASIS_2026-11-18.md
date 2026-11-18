# Radius-one cone cycle basis (strong form)

Date: 2026-11-18

**MATHEMATICAL PROOF** (any field). **INDEPENDENT FINITE COMPUTATION_PASS**
(fields F2, F3, F5; graphs up to five vertices). **LEAN_NOT_RUN**.

## The theorem

Let G be a finite undirected simple graph, v any vertex, and H the
induced subgraph on its closed radius-one ball B_1(v) = {v} ∪ N(v).
Let E_rim be the edges of the induced neighbor graph G[N(v)].

For any field K, the restriction of edge coefficients to E_rim is a
K-linear isomorphism

    (ker boundary_H) ≃ₗ[K] (E_rim → K).

In particular,

    dim_K(ker boundary_H) = |E_rim|
                         = number of triangles of G containing v.

A preferred basis is the family of triangle circulations t_(a,b)
for rim edges {a,b}, each with coefficient 1 on its own rim edge and
zero on all other rim edges. This works over characteristic 2 as well
as odd-characteristic fields; orientation signs must be respected.

## Proof without a rank assumption

Fix an arbitrary orientation on every edge in H. For every rim edge
e={a,b} of H there is a unique triangle with edges {v,a},{a,b},{b,v}.
Define t_e to be its oriented incidence cycle, scaled to have
coefficient +1 at e.

For any circulation z in ker(boundary_H), define

    T(z) = sum_(e in E_rim) z_e * t_e.

At each rim edge e, the coefficient of T(z) is z_e. Hence z-T(z) is a
circulation supported only on spokes {v,u}. At any u≠v, the boundary
of that residual cycle consists of ± its sole spoke coefficient, and
therefore that coefficient is zero. Thus z=T(z).

Conversely, any rim coefficient assignment c determines a circulation
sum_e c_e*t_e. The rim restriction of this sum is exactly c.

These two linear maps are inverse, proving the claimed linear
equivalence. Surjectivity is constructive and injectivity follows from
the spoke-supported-cycle argument. No chordality or connectivity
assumption on the ambient graph is needed.

## Implications

1. Every radius-one local circulation is a combination of triangle
   circulations over any field.
2. The graph-global radius-one-generated subspace R_1 equals
   boundedSupportCycleSpace G 3 = span of all triangle cycles.
3. This does not make R_1 equal the global cycle space on arbitrary G:
   C6 has no triangles, but its global cycle space is nonzero.
4. The formula gives an exact, local basis with one basis vector per
   neighbor-neighbor edge. It eliminates the need to enumerate all
   edge chains when constructing a radius-one certificate.
5. The Lean target should start with this *local restriction
   equivalence* before proving the global span identity.

## Independent computational audit

The script `check_cone_cycle_basis_multifield.py` independently
builds incidence matrices and triangle vectors, computes modular
Gaussian-elimination ranks, and checks:

    rank(triangle_vectors)
      = |E_rim|
      = |E(H)| - rank(boundary_H)

for every radius-one ball of every labeled simple graph with n=1..5
vertices, independently over fields F2, F3, and F5.

Result: 1,099 graphs, 5,405 balls, 16,215 field-specific checks, PASS.
This is finite evidence, not universal formal verification.

## Precise Lean obligations

1. Implement an oriented incidence cycle `triangleAtCenter` for
   each rim edge, using the source's `simpleGraphBoundary`.
2. Show its rim restriction is the relevant coordinate delta.
3. Prove every spoke-only circulation is zero by checking the
   boundary at each noncentral vertex.
4. Assemble a linear equivalence from rim restriction and the
   triangle-cycle synthesis map.
5. Deduce global `R_1 = boundedSupportCycleSpace G 3` after
   introducing the actual `R_1` definition.

No Lean compiler claim is made for these new declarations.
Published checkpoint a06477e82e96e90c316611c6bf71073e70297d62
remains immutable; do not merge without an exact-HEAD build and axiom audit.

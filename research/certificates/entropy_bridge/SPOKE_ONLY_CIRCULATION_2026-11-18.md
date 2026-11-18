# Spoke-only circulation vanishing theorem

Date: 2026-11-18
Repository branch: `research/entropy-uniform-radius-audit-20261118`
Published base: `a06477e82e96e90c316611c6bf71073e70297d62`

**PROVED (mathematical proof). COMPUTATION_PASS (exact finite audit).
LEAN_VERIFICATION := NOT_RUN.**

## Precise statement

Let G be a finite undirected *simple* graph, with a fixed orientation on
each edge and coefficients in any field K. Fix a vertex v. Suppose z is
an edge chain such that

  (i) z_e=0 whenever e is not incident to v; and
 (ii) the oriented incidence boundary ∂z is zero at every vertex.

Then z=0.

This is also true for coefficients in an arbitrary ring with 1, or any
additive abelian group, since the relevant incidence entries are ±1.
Simplicity is important: if G has parallel edges, a nonzero 2-edge
circulation supported at v may exist.

## Proof

For any neighbor u≠v, there is exactly one edge e={u,v}. At row u,
all supported coefficients except z_e are zero, so

    (∂z)(u) = s(u,e) z_e

where s(u,e)=+1 if u is the terminal vertex in the chosen orientation,
and -1 otherwise. Since ∂z=0, multiplication by the unit s(u,e)
implies z_e=0. All nonspoke coefficients were already assumed zero,
hence z=0.

A useful strengthened formulation is that the submatrix of the
incidence map consisting of the spoke columns and noncentral vertex
rows has full column rank. After ordering rows by the corresponding
neighbors, the square submatrix is diagonal with ±1 entries.
Consequently it is injective over any field.

## Connection to the actual Lean definitions

The existing verified source defines:

`OrderedEdge G := {e : V × V // e.1 < e.2 ∧ G.Adj e.1 e.2}`.

`simpleGraphIncidence G v e :=
    if v = e.val.1 then -1 else if v = e.val.2 then 1 else 0`.

`simpleGraphBoundary G := (simpleGraphIncidence G).mulVecLin`.

The next Lean target is an elementwise lemma, with `z : OrderedEdge G → K`,

    (∀ e, z e ≠ 0 → e.val.1 = v ∨ e.val.2 = v) →
    simpleGraphBoundary G z = 0 →
    ∀ e, z e = 0

and the result `z=0` by function extensionality.

The essential proof-specific lemma: for a supported edge e={u,v},
evaluating `simpleGraphBoundary G z` at its noncentral endpoint u
reduces the finite sum to the one coefficient ±z_e.
The uniqueness comes directly from the `OrderedEdge` subtype and
simple-graph structure; no topological hypothesis is required.

Suggested formalization order:
1. Prove every distinct spoke edge contributes 0 at u.
2. Simplify the single remaining incidence coefficient to ±1.
3. Read the zero-boundary equation to infer z_e=0.
4. Finish by pointwise equality.

## Exact independent finite computation

`check_spoke_injectivity_multifield.py` enumerates all labeled simple
graphs with 1..6 vertices (33,867 graphs), every possible star (202,013
vertex stars), and verifies the noncentral-row incidence restriction has
column rank equal to the number of spoke edges over F2, F3 and F5.

Actual independently executed result:
  GRAPHS = 33867
  VERTEX_STARS = 202013
  FIELD_CHECKS = 606039
  ASSERTIONS = PASS

This test checks the theorem's injectivity condition but is not an
unrestricted Lean proof.

## Consequence for the radius-one cone basis

For the radius-one induced graph G[B1(v)], any circulation z can have
its neighbor-neighbor ('rim') coefficients removed by subtracting an
explicit linear combination of triangle cycles through v. The
remaining circulation is spoke-supported, hence zero by this theorem.

Therefore restriction to rim edges gives the linear isomorphism

    ker(boundary on B1(v)) ≃ₗ[K] (rim edges → K).

Both the cone-basis equivalence and the global identity R1=S3
are mathematical theorems, but their Lean formalizations remain OPEN.

## Verification and repository discipline

The spoke lemma has NOT undergone a Lean 4.27.0 compile or axiom audit.
No new verified Lean theorem is claimed. Preserve the published
checkpoint, do not merge on mathematical argument or finite tests
alone, and keep untracked local directories untouched.

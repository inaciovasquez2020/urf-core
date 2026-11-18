# Sharp hidden entropy capacity and first clique homology

Date: 2026-11-18
Repository branch: `research/entropy-uniform-radius-audit-20261118`
Base verified checkpoint: `a06477e82e96e90c316611c6bf71073e70297d62`

Status: **MATHEMATICAL PROOF**, **COMPUTATION_PASS** on 682 F2 linear maps.
**LEAN_VERIFICATION := OPEN** for the maximizing equality and clique bridge.
This is a standard finite linear-information consequence; novelty NOT ESTABLISHED.

## Theorem A: sharp finite linear-observation entropy capacity

Let K be a finite field with q=|K|≥2, and let f:Q→ₗ[K]W be linear
between finite-dimensional vector spaces. For any probability law p
on the finite input type Q, define the finite conditional entropy as
in `URFCoreConcreteGraphStage.lean`:

    H_p(X | f(X))
      = Σ_(y:W) P_p(f(X)=y) H_p(X | f(X)=y).

Then

    max_(p on Q) H_p(X | f(X)) = log |ker f|
                            = (dim_K ker f) * log q.

The upper bound has already been obtained in the published abstract
linear entropy theorem (and its graph specialization).

### Proof of attainability

Choose the uniform law on Q. Every y in im f has a fiber f⁻¹(y)
that is an affine translate of ker f, hence has the same number
k=|ker f| of points. A uniform input conditioned on an observed y
is uniform on this fiber, so its Shannon entropy is log k.
All other y have zero observation mass. The weighted average is
thus Σ_(y in im f) P(f(X)=y)*log k = log k.
This proves the bound is sharp.

The proof does not require f to be surjective onto W. It does require
the input space Q to be nonempty (automatic for a vector space).

## Theorem B: exact topology-valued hidden capacity

For a finite simple graph G and its clique (flag) simplicial complex
X(G), the global cycle space Z1=ker∂1, and the triangle-generated
radius-one local space R1=im∂2, restriction of dual linear functionals

    Obs_R1: Z1* →ₗ[K] R1*

has kernel canonically isomorphic to (Z1/R1)*, hence to H1(X(G);K)*.
Therefore its kernel has dimension β1(X(G);K), and by Theorem A:

    max_p H_p(X | Obs_R1(X)) = β1(X(G);K) * log q.

For arbitrary p the same expression is an upper bound; the uniform
law on the FULL dual space Z1* attains equality.

### Zero-entropic criterion and nonvacuity

The following are equivalent:

(1) β1(X(G);K)=0.
(2) Obs_R1 is injective.
(3) H_p(X | Obs_R1(X))=0 for EVERY probability distribution p on Z1*.
(4) max_p H_p(X | Obs_R1(X))=0.

Proof: (1) iff (2) by the kernel dimension theorem.
If the observation is injective, its positive-mass fibers are
singletons, giving (3) and (4).

Conversely, if β1>0, the kernel has at least q≥2 elements. Choose
two distinct input points x and x+k in the same observation fiber,
where 0≠k∈ker Obs_R1. The law assigning mass 1/2 to each has output
constant and conditional entropy log 2 >0. Thus (3) and (4) fail.

This also distinguishes the universal zero-entropy property from
accidental zero conditional entropy under a particular concentrated
input distribution.

## Important qualification

This is a consequence of the radius-one identity R1=im∂2,
which has a mathematical proof in this branch but is not yet
LEAN_VERIFIED. The complete uniform-input conditional entropy equality
also remains LEAN_OPEN. Neither mathematical statement is promoted as
a compiler certificate.

No claim is made about independent global URF rigidity or Poincaré.

## Independent finite audit

The companion `check_hidden_entropy_capacity.py` exhaustively
enumerates all binary linear maps F2^n→F2^m with 1≤n,m≤3.
Each fiber has exactly |ker f| elements. Classification:

    ALL_MAPS = 682
    INJECTIVE = 227
    NONINJECTIVE = 455
    MAX_KERNEL_SIZE = 8

For each noninjective map the kernel contains distinct inputs whose
observation agrees, furnishing a strictly positive conditional-entropy
witness (uniform over those two inputs).

The script tests the combinatorial equal-fiber and injectivity claims.
It does not numerically certify unrestricted Shannon inequalities,
which are supplied by the mathematical entropy proof.

## Next formalization target

1. Verify `uniform_fiber_entropy_exact_candidate` against pinned Lean,
   with the kernel Fintype instance made available at declaration time.
2. Verify `linear_uniform_conditional_entropy_exact_candidate`.
3. Finish `R1=im∂2`, then the annihilator/quotient dual equivalence.
4. Instantiate the upper bound and uniform equality at Obs_R1.
5. Inspect exact HEAD, build, axiom audit, and diff before any promotion.

No source integration, merge, or local Mac changes asserted.

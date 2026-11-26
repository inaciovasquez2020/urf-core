# Archimedean kernel density-coercivity: evidence correction

Frozen source: [akr_density_coercivity.tex](../../archimedean-kernel-rigidity/akr_density_coercivity.tex), blob c216bb93e33279b28bc610f7bec60259ec46b71e. Preserve the frozen source. Status of the substantive uniform coercivity claim on the evidence supplied by that manuscript: CONDITIONAL / OPEN.

If on the same specified domain D and for a specified family of decompositions E=E_diag+E_osc one has <E_diag f,f> >= c0 ||f||^2 with c0>0 uniform in f and R, and |<E_osc f,f>| <= epsilon(R)||f||^2 uniformly with epsilon(R)->0, choosing R with epsilon(R)<=c0/2 gives <Ef,f> >= (c0/2)||f||^2. This combination is valid. The manuscript does not derive the two uniform estimates, define the role of R sufficiently, or give a complete operator/kernel and domain specification.

Positivity does not imply uniform coercivity: on L2(0,1) multiplication by x is bounded self-adjoint and strictly positive in quadratic form on every nonzero vector, yet unit vectors sqrt(j) times the indicator of (0,1/j) have Rayleigh quotient 1/(2j)->0. This is a counterexample to the general inference, not a counterexample to the specific Euler-Gram operator.

Closure requires an appropriate form core and uniform estimate (or bounded operator continuity), not merely ambient norm density for an unbounded operator. A fixed frequency cutoff and orthogonality condition must be reconciled with the claimed density and the reduced domain. The two load-bearing estimates and extension are the exact unresolved obligations in the supplied paper. No claim that these estimates are false, and no claim about independently supplied proofs elsewhere. No Riemann hypothesis implication, Lean verification, or change to existing declarations.

# URF research-strengthening audit — complete four-target pass

Date: 2026-11-23. Scope: public remotely accessible GitHub source plus bounded, self-contained, independent finite tests in the assistant container. The user's Mac and private worktree were **not** inspected. No repository branch, source, commit, push, PR, or merge was modified.

## Result inventory

| Target | Result | Verification boundary |
|---|---|---|
| General adaptive q-ary graph reconstruction | Mathematical theorem established; previously written proof independently inspected and finite verifier replayed | PROVED; COMPUTATION_PASS; new Lean NOT_RUN |
| General finite-fiber reconstruction, including unequal S3 orbit fibers | New exact operational theorem and attainability proof; independently enumerated S3 | PROVED; COMPUTATION_PASS; new Lean NOT_RUN |
| PR #597 general-radius and NP-completeness review | Examined actual PR head and source/axiom/regression receipts; independent small unrestricted edge-augmentation audit | SOURCE_AUDIT; COMPUTATION_PASS on tested instances; global NP-hardness proof has not been independently formalized |
| Physically meaningful Chronos–DFM observable | 4D flat-U(1) countermodel shows holonomy obstruction does not imply 5D necessity | PROVED conditional mathematical countermodel; CHRONOS-DFM physical transfer OPEN |
| URF H1 FO^k semantics | Explicit trivial inhabitation of current existential H1 and nominally nonvacuous witness gate | PROVED by definitional witness on paper; Lean source candidate NOT_RUN; intended FO^k mathematics OPEN |

## A. Finite-fiber theorem (strongest unifying result)

Let X be a nonempty finite set, let O : X -> Y be a deterministic observation map, and let F_y = O^{-1}(y) for y in O(X). Fix an alphabet of cardinality q >= 2, m >= 0 additional state-dependent queries, and Q=q^m. The queries may be nonlinear, adaptive, and arbitrarily designed, but are not constrained by locality, computational complexity, or physical realizability. Each yields at most q answers. The observer knows O(x), and X is initially uniform on X.

**Theorem A.1 (sharp success / zero-error threshold).** Under this information model,

    maximum exact decoding probability = (1/|X|) sum_{y in O(X)} min(|F_y|, Q),
    minimum m for zero-error identification = ceil(log_q(max_y |F_y|)).

The displayed ceiling should be interpreted as the *least nonnegative integer* m with q^m >= max_y |F_y|, avoiding floating-point logs.

**Proof.** Fix y. A deterministic depth-m decision tree with at most q children per node has <= Q distinct transcripts. The decoder maps each transcript to one candidate x, so it can be correct on at most min(|F_y|,Q) states in F_y. Under the uniform prior each such state has mass 1/|X|, giving the upper bound after summing over y. For attainment, assign distinct Q-ary codewords to min(|F_y|,Q) states of each fiber. Assign every remaining state any existing code. Each digit of the assigned code is an admissible (though generally global) q-ary measurement. Decoder outputs the selected representative associated with a codeword. It is correct on exactly min(|F_y|,Q) states in F_y. The zero-error statement follows by requiring the code to be injective on every fiber. For randomized strategies, condition on independent internal coins: every deterministic conditioned strategy satisfies the same bound, so averaging cannot beat it. QED.

**Theorem A.2 (nonuniform prior).** Let p(x) be any probability law on X. Write p_{y,(1)} >= p_{y,(2)} >= ... for the *joint* probabilities p(x) of the elements in fiber F_y, ranked in decreasing order. Then

    maximum exact decoding probability = sum_y sum_{i=1}^{min(Q,|F_y|)} p_{y,(i)}.

Same proof, substituting weighted best representatives. The bound is achieved by mapping these top Q candidates to distinct codewords. No uniformity premise is needed for Theorem A.2.

**Theorem A.3 (sharp residual Shannon entropy for a uniform input).** Put n_y=|F_y| and write n_y=Q a_y+b_y with 0 <= b_y < Q. Define 0 log(0)=0. Then the smallest achievable H(X|O(X),T), where T denotes the Q-valued transcript, is

    (1/|X|) sum_y [b_y (a_y+1) log(a_y+1) + (Q-b_y) a_y log(a_y)].

Proof: within an observation fiber, a deterministic transcript partitions n_y uniformly weighted inputs into at most Q buckets of sizes n_1,...,n_Q (zeros permitted). Under the global uniform prior its contribution to conditional entropy is (1/|X|) sum_i n_i log(n_i). Convexity of t log t (or the discrete exchange inequality) shows this sum is minimized when bucket sizes differ by at most one. Distribute n_y among Q buckets as evenly as possible to attain the expression. Any extra independent randomness cannot reduce the minimum average entropy since conditioning on its realized seed gives a deterministic partition with entropy at least this minimum. QED.

**Transfer to the finite-field graph theorem:** The map O_r : Z* -> R_r* is surjective with constant fiber size q^{d_r}. Therefore Theorem A.1 reduces to min(1,q^{m-d_r}), and minimum m=d_r. Theorem A.3 reduces to max(0,d_r-m) log q, attained by a complement of R_r. This is a recovery *from the original independent-local gauge classes*. Additional probes may not themselves be radius-r local.

**Transfer to nonabelian S3:** The orbit fibers are nonuniform. For k=4 independent loops, N=251 global classes and M=81 local signatures. The independently enumerated fiber histogram is 1:21,2:24,3:12,4:8,5:4,6:6,8:1,9:4,14:1. With binary queries, optimal exact success at depths m=0,1,2,3,4 is respectively 81/251, 141/251, 201/251, 241/251, 251/251. Four extra bits are necessary and sufficient for *unrestricted* query functions. This is not a claim that four short shared-root Wilson-product observations exist with those abilities.

**Novelty:** Not established. These are finite Bayesian decision-tree/guessing-capacity formulas using established probability and combinatorics. Closely related standard notions include posterior Bayes vulnerability, conditional guessing probability and quantitative information flow (e.g. Issa–Wagner–Kamath, *An Operational Approach to Information Leakage*, 2018, https://arxiv.org/abs/1807.07878; Alvim et al., *Measuring Information Leakage Using Generalized Gain Functions*, IEEE CSF 2012, https://doi.org/10.1109/CSF.2012.26). The contribution here is an exact, verified-in-finite-cases URF cross-model synthesis, not an asserted priority claim.

## B. Existing general-radius and NP-completeness source audit

- Repo: `inaciovasquez2020/urf-core`.
- PR #596: **merged**; earlier integration-pending narrative is historical. Main contains `lean/URF/Foundation/SharpCliqueEntropy.lean`.
- PR #597: **draft, unmerged**; actual remote head `8e3857350353e43f3e1f93122e5269148c9f1d05` as fetched on 2026-11-23. PR body contains an older head identifier; the body says exactly two research files while current changes contain 32 files. Treat the actual diff and head as authoritative, not older prose.
- Read actual head's `research/multiscale-information-recovery/README.md`, `research/certificates/general_radius_support/VERIFICATION.md`, `.../RECEIPT.txt`, `.../axioms.log`, and `.../final-regression.log`, and relevant Lean sources. The receipts report `radiusCycles_eq_boundedSupportCycleSpace` in Lean 4.27.0 with mathlib a3a10db0, 54 axiom audits, and 451 passing regressions. Axiom log entries use only `propext`, `Classical.choice`, `Quot.sound` or no axioms. THESE ARE INSPECTED REPOSITORY RECEIPTS, NOT COMPILATIONS PERFORMED BY THIS AUDIT.
- The paper proof of the radius cutoff R_r=S_{2r+1} is mathematically consistent: a nonzero circulation decomposes into simple cycles; an induced radius-r ball has a rooted BFS tree; non-tree edges yield cycles of length at most 2r+1; short simple cycles fit inside a radius-r ball. The finite independent replay checks both generators for 829 graph/field instances over 4065 radii.
- The Set Cover reduction's use of 2t+1 independent layers permits an untouched layer after at most t arbitrary edge additions, because any edge can touch at most two layers. That yields the uncovered vertex as an isolated component in the link of b; Mayer–Vietoris for the cone-on-link cover gives nonvanishing H1. The forward cover makes the deletion contractible and the link connected. I found no contradiction in these exact arguments, but no mechanized proof of the entire NP-completeness claim was run.
- A separate, independently written GF(2) verifier constructed 42 small unrestricted-augmentation Set Cover instances and checked 5,449 augmentations, including arbitrary shortcut edges and t=2 adversarial pairs. All tests passed (26 successful augmentations, all with extracted covers). It does NOT prove NP-hardness, address every t or coefficient domain, or establish novelty.

## C. Four-dimensional countermodel: no inference to fifth-dimensional necessity

Take ordinary four-dimensional Lorentzian spacetime

    M = R_t × (R² \ {0}) × R_z

with the standard local Minkowski metric on this open submanifold. Choose p >= 2 an integer (prime if identifying the finite holonomy group with F_p). Let theta be the angular coordinate on the punctured spatial plane and write the globally defined closed 1-form

    dtheta = (-y dx + x dy)/(x²+y²).

For j=0,...,p-1, define the smooth U(1) gauge potential

    A_j = (j/p) dtheta.

Then curvature F_j = dA_j = 0 everywhere on M. On every simply connected contractible coordinate patch, dtheta=d(theta_local), so A_j is gauge-equivalent to zero there. If each patch is independently quotiented by its local gauge group, *all* these p connections give identical local gauge observations. However a loop winding once around the excised axis has Wilson holonomy exp(i∮A_j) = exp(2πij/p), which distinguishes the p global gauge classes. Distinct holonomies prevent global gauge equivalence. One p-ary Wilson-holonomy measurement reconstructs j. This is a continuous 4D realization of the local/global nonidentifiability pattern with a one-query completion threshold, requiring no extra spacetime dimension.

This is a standard Aharonov–Bohm-type example, not a new physical prediction: Aharonov & Bohm, *Physical Review* 115 (1959) 485–491, https://doi.org/10.1103/PhysRev.115.485. The result is an obstruction to the proposed **implication** 'local holonomy information loss implies a necessary fifth dimension'; it is NOT a disproof of a specific 5D Kaluza–Klein theory or any observed cosmology.

The weakest missing Chronos–DFM bridge object is a model-specific gauge-respecting map from physical configurations to an observation space, with evidence that the actual physical detector implements precisely that map, plus a matched 4D comparator and a discriminating prediction. The finite S3 and F_p models are different: no linear kernel/dimension formula can be imported directly into S3; only Theorem A's finite-fiber law transfers without extra assumptions.

## D. FO^k locality: critical formal-specification vacuity

Inspect `inaciovasquez2020/urf-core` main `lean/URF/H1Locality.lean`:

    structure FOkAdmissibleRefinementInterface where
      k : Nat
      k_pos : 0 < k
      RefinementProcedure : Type
      FOkAdmissible : RefinementProcedure -> Prop
    def H1Locality : Prop :=
      exists I : FOkAdmissibleRefinementInterface,
        forall R : I.RefinementProcedure, I.FOkAdmissible R

This can be inhabited with k=1, RefinementProcedure=Unit, FOkAdmissible=(fun _ => True). The subsequent `ConcreteRepositoryNativeFOkWitnessComponents` gate ALSO admits this witness, taking RepositoryNativeSemanticBinding=Unit and nonvacuous_semantic_content=True. The prose comment stating that the structure blocks Unit/True is therefore mathematically incorrect: it records a requirement **as an unconstrained Prop-valued field that the caller chooses**. Its `Nonempty` 'open' gate is trivially true by construction.

This is a **formal specification defect**, not a proof of the intended FO^k locality. See `URFH1VacuityAuditCandidate.lean` for a small proof candidate written against the actual interface; Lean execution remains NOT_RUN. No existing H1 theorem should be promoted to a semantic universal locality theorem using this existential interface.

**Safe correction:** Fix the actual refinement-procedure universe P and a semantic predicate externally. Define the target relative to that fixed data, e.g. `∀ (R : P), ActualProcedure R -> ∃ (φ : FOFormula k), SemanticallyRepresents φ R`, with the syntax and interpretation imported from the real FO^k development. `P`, `ActualProcedure`, `FOFormula`, and `SemanticallyRepresents` must be real repository-native objects, not arbitrarily chosen existential witnesses. A proof must verify representation for the intended class of refinements. If it includes unrestricted graph connectivity tests, a uniform FO^k characterization for all finite graphs is impossible: connectivity is not FO-definable (in particular not in fixed-variable FO^k), as seen from Hanf/Gaifman locality using large cycles versus disjoint unions of cycles with matching bounded neighborhoods; consult Libkin, *Elements of Finite Model Theory* (Springer) and Martin Otto's FMT lectures, https://www2.mathematik.tu-darmstadt.de/~otto/LEHRE/FMT16.pdf.

The weakest remaining **semantic** obligation is not `Nonempty ConcreteRepositoryNativeFOkWitnessComponents` (trivial); it is a fixed actual-representation theorem for the precisely designated refinement class.

## E. Formalization candidate / compiler boundary

`URFAdaptiveCountingCandidate.lean` contains three no-hole source declarations: correct-state count on one observation fiber, correct-state count globally, and q-ary word specialization. Its first proof obligation is an injectivity argument: if two correctly decoded inputs share a transcript, they are the same state. The code does **not** yet formalize the entire graph observation type, the protocol-to-word compiler, or randomized averaging. Stop at the first Lean compiler error and repair only that error before attempting the next obligation.

`URFH1VacuityAuditCandidate.lean` is a negative test for the current H1 specification, not a theorem to promote. Neither file was compiled. Do not mark any of these declarations LEAN_VERIFIED without exact repo/toolchain compilation and `#print axioms` checks. Only `propext`, `Classical.choice`, `Quot.sound` are permitted.

## F. Reproducibility and constraints

Available scripts, standard library only:

- `verify_multiscale_adaptive.py`: 829 graph-field instances, 4065 radius checks, 5609 probe-depth checks, 218940 probe-state checks, 28509 raw edge/gauge states. Replay passed in this environment.
- `verify_urf_probe_completion.py`: 875 graph instances including controls, 1087 probe-depth cases, 786 redundant-probe checks. Replay passed.
- `verify_fiber_spectrum.py`: 3630 finite map cases, 717588 exhaustive transcript assignments, exact integer entropy partition optimization, exact S3 orbit enumeration k<=4. PASS.
- `verify_pr597_setcover_independent.py`: 42 reduction instances, 5449 unrestricted augmentations, 23 checked forward covers, 26 zero-H1 successes all entailing cover. PASS.

All computations are bounded. A guard hit is INCOMPLETE, never PASS. Source files and final run output are preserved alongside this report. No Lean or Lake executable was available in this container, and no user Mac execution was claimed.

## Promotion boundary

TARGET: the finite-fiber exact reconstruction theorem and a corrected H1 semantic interface, independently.
RESULT: mathematical PROVED, finite COMPUTATION_PASS, Lean NOT_RUN.
REPO: remote public URF Core; PR #597 draft, unmerged; remote HEAD inspected, Mac HEAD/DIRTY NOT_INSPECTED.
OPEN: Lean compiler/axiom audit for new counting lemmas; external-nonvacuity FO^k semantics; physical Chronos–DFM observation map; broad independent NP-completeness and novelty review.
PUSH/MERGE/DELETE: NONE.

Recommended next actions (not executed):

1. Compile `URFAdaptiveCountingCandidate.lean` with exact URF Core Lean 4.27.0 / mathlib pin, stopping on the first error and performing an axiom audit after success.
2. Independently compile the H1 negative test, then correct the semantic interface in a separate, explicitly reviewed proposal; do not advertise trivial proof as locality closure.
3. Audit PR #597's current 32-file diff and exact-HEAD CI receipts before any publication or merge; its PR-body base/head narrative is stale.
4. State a physically explicit Chronos observational map and a matched 4D comparator before transferring any 5D interpretation.
5. Solicit independent mathematical and literature novelty review for the finite-fiber synthesis and the unrestricted Set Cover reduction.

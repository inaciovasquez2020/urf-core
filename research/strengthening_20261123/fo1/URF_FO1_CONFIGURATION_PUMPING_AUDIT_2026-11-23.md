# URF FO¹ semantic repair and configuration-pumping counterexample

Date: 2026-11-23. Status: **counterexample PROVED under the stated pure uncolored graph semantics**; **bounded finite tests COMPUTATION_PASS**; mathlib-free Lean formalization **NOT_RUN** pending authoritative Mac compilation. Repo writes / commits / push / merge: NONE.

## Inspected repository sources

- `inaciovasquez2020/urf-core` at `b02b6a965930ddb22e3cbfe6c733f727baf925f0` for `lean/URF/H1Locality.lean` (blob `393b679a5d76daf755d0be683d4b10fa4332f6a2`). Existing H1 specification vacuity established separately by user Mac: `LEAN_VERIFIED_ISOLATED`, four verbatim declarations, two proof declarations, zero axioms.
- Main public source `papers/fo-k-locality/configuration_pumping.tex` (`https://github.com/inaciovasquez2020/urf-core/blob/main/papers/fo-k-locality/configuration_pumping.tex`), which asserts: if `dim_F2 Z1(B_{2R}(v)) > |T(k,Delta,R)|`, then distinct configurations of the same type exist, **consequently** vertices `x≠y` with **different** FO^k local types exist.
- Main public source `papers/fo-k-locality/cycle_orbit_splitting.tex` says a threshold guarantees distinct vertex types; the threshold is not quantified relative to attainable cycle-space dimension and can be vacuously greater than the uniform ball bound.
- `docs/normalization/Bounded-Rank-Logic.md` uses bounded-rank logic in its normalization statements. Its adopted interpretation must be kept distinct from the paper's unqualified FO^k-type counting.

## Concrete counterexample under standard pure FO¹ graph language

The signature is equality and a single symmetric irreflexive binary edge relation, with **no extra named constants, unary vertex colors, counting quantifiers, or external marks**. The one reusable variable is `x`, so atomic formulas are exactly `x=x` (always true) and `E(x,x)` (always false). By induction on negation, conjunction, and `∃x` quantification, on every nonempty loopless graph **all one-variable formulas have the same truth value at every vertex and across all such graphs**. Hence the type collection `T(1,3,1)` (local vertex FO¹ types under these semantics) has cardinality one.

Choose `G=K4`, `k=1`, `Delta=3`, `R=1`. The graph is degree three and every radius-2 ball is the whole graph. The exact mod-2 incidence matrix has rank three (four vertices, six edges), so

`dim_F2 Z1(B_2(v)) = 6 - 3 = 3 > |T(1,3,1)| = 1`.

Yet every vertex of `K4` has the same FO¹ local type (also follows from vertex transitivity, independently of FO¹ expressive weakness). The conclusion `∃x≠y : tp_R^FO¹(x) ≠ tp_R^FO¹(y)` is false.

**Scope:** This disproves the displayed implication under the natural uncolored pure FO¹ signature, including k=1 as allowed by the written quantification. If the intended `T` is a different object (e.g. marked pebble assignments, unary colors, k≥2, bounded rank, or another semantics), that object and its cardinality must be specified. No claim about every enriched or restricted version is made.

## Exact finite audit

Independent Python `verify_fo1_pumping_counterexample.py` enumerated all `1099` labeled undirected loopless graphs of 1 through 5 vertices. It checked 202 FO¹ syntax trees of length ≤5, independently computed cycle ranks by Euler characteristic **and** F₂ Gaussian elimination on incidence columns, and checked all rooted radius-1 FO¹ types against the singleton-vertex empty-edge structure.

```
GF2_INCIDENCE_RANK_CROSS_CHECKS := 5405
ROOTED_RADIUS1_FO1_TYPE_CHECKS := 1091810
FORMULAS_SIZE_LE_5 := 202
ALL_SIMPLE_GRAPHS_UP_TO_5_VERTICES := 1099
FORMULA_VERTEX_COMPARISONS := 2183620
GRAPHS_WITH_K1_R1_PREMISE_TRUE := 423
GRAPHS_WITH_DELTA_LE_3_AND_PREMISE_TRUE := 202
K4_VERTICES := 4
K4_EDGES := 6
K4_BETTI1_BALL_R2 := 3
FO1_UNCOLORED_LOOPLESS_LOCAL_TYPE_COUNT := 1
K4_FO1_VERTEX_TYPE_SPLIT := FALSE
CONFIGURATION_PUMPING_AS_STATED_K1 := COUNTEREXAMPLE
LEAN := NOT_RUN
```

Finite tests are corroboration of an unrestricted proof by structural induction; they do **not** constitute a substitute for that induction or Lean compilation.

## What pigeonhole counting actually proves

Let `C` be a finite set of actual local configurations and `tau:C→T` a **specified** map to a finite set of local types, with `|T|=t>0`. If `|C|>t`, there exist distinct `a,b∈C` with **equal** types `tau(a)=tau(b)`. More sharply, some type occurs at least `ceil(|C|/t)` times. Nothing in this hypothesis forces two configurations or vertices to have **different** types. The claimed type-splitting conclusion needs a genuinely additional *semantic separation* assumption.

Furthermore, a hypothesis involving `dim Z1` alone supplies only the number `2^dimZ1` of F₂ cycles, not a canonical map from these cycles to pebble configurations or their FO^k types. Such a map must be exhibited explicitly before applying pigeonhole.

For fixed finite maximum degree `Delta` and fixed `R`, the radius-2R ball has at most `N = 1 + Delta * sum_{j=0}^{2R-1}(Delta-1)^j` vertices (for `Delta≥2`) and at most `Delta N /2` edges. Its cycle rank is therefore at most `1 + (Delta/2 - 1)N`. Any proposed threshold above that ceiling makes `cycle_orbit_splitting.tex` formally true but vacuous. A substantive theorem must exhibit an **attainable** threshold and a **nonvacuous** configuration family.

## Rigorous next target

1. Define a fixed graph signature and an actual `FOkFormula k` syntax/interpretation, using independently defined satisfaction. Specify the quantifier-rank and locality-radius restrictions separately.
2. Fix the intended `RefinementProcedure` family independently of the statement to be proved. `FOkAdmissible k R` must be an externally defined semantic property, not a field the witness can choose.
3. State an honest repetition theorem with an explicit map `tau` and a *separate* type-splitting lemma with a demonstrably necessary separation condition.
4. Test the intended k≥2 or enriched signature on adversarial vertex-transitive bounded-degree graphs; do not infer physical, Poincaré, or complexity-theoretic conclusions from this FO¹ counterexample.

Companion files:
- `URF_FO1_FixedSemanticCounterexample.lean`: complete pure FO¹ syntax, evaluator, diagonal invariance, fixed-semantic nondefinability of edge existence, and homogeneous K4 type. **NOT_RUN;** intended to compile with Lean 4.27.0 and `import Init` only.
- `verify_fixed_fo1_mac.sh`: read-only, temporary-file compiler runner with exact source preflight and `#print axioms` checks for four target theorems.
- `verify_fo1_pumping_counterexample.py`: independently executed exact finite audit, no external Python dependencies.
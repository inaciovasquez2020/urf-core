# Fixed FO¹ counterexample — isolated Mac Lean evidence

Date: 2026-11-23. User-supplied actual Mac output, independently interpreted by the assistant.

- Local URF checkout HEAD: `b02b6a965930ddb22e3cbfe6c733f727baf925f0`, branch `main`, working-tree status empty at the final run.
- Exact `lean/URF/H1Locality.lean` Git blob: `393b679a5d76daf755d0be683d4b10fa4332f6a2`.
- Toolchain: Lean `4.27.0`, arm64-apple-darwin24.6.0, compiler commit `db93fe1608548721853390a10cd40580fe7d22ae`.
- Compiler-input SHA-256: `9827616fce7ca63fe787ed3bcf9705bdcd506644cf0c86b1dce78572a4866555`.
- The accompanying `URF_FO1_FixedSemanticCounterexample.lean` preserves **exact compiler input bytes**. The source's pre-compilation `NOT_RUN` comment is historical; this receipt supersedes it.

Actual final compiler output (successful compilation, with printed axiom dependencies):
```
'URF.FixedFO1.sat_diagonal_invariant' does not depend on any axioms
'URF.FixedFO1.sat_vertex_invariant_of_irreflexive' does not depend on any axioms
'URF.FixedFO1.not_FO1Defines_hasEdge' depends on axioms: [propext]
'URF.FixedFO1.complete_same_FO1_type' does not depend on any axioms
AXIOM_AUDIT := INCOMPLETE not_FO1Defines_hasEdge
```

The final `AXIOM_AUDIT := INCOMPLETE` came from a **too-strict wrapper rule** requiring an empty axiom list for every theorem. `propext` belongs to the permitted axiom set `{propext, Classical.choice, Quot.sound}`. The corrected wrapper `verify_fixed_fo1_permitted_axioms_mac.sh` was checked for Bash syntax and acceptance logic, but was not independently rerun on the user's Mac. Its embedded source is identical to the successful compiler input.

**Status:** `LEAN_VERIFIED_ISOLATED` for exactly the four displayed declarations; NOT verified as an imported URF module, general FOᵏ locality theorem, or H1 repair. No mathlib cache was restored. No local Git mutation was performed.

**Independent assistant-container replay:** `verify_fo1_pumping_counterexample.py` passed on 1,099 simple labeled graphs through five vertices, including 5,405 exact F₂ incidence-rank comparisons and 1,091,810 rooted type checks. The Python script's `LEAN := NOT_RUN` reports that Python did not invoke the Lean compiler.

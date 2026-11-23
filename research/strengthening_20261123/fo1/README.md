# FO¹ locality specification audit — isolated Lean checkpoint

**Scope:** Research-only addition to draft PR #599. No production Lean imports, existing declarations, or mathematical claims are modified.

**Verified:** The exact Lean source `URF_FO1_FixedSemanticCounterexample.lean` was successfully compiled on the user's Mac with Lean 4.27.0. Source SHA-256: `9827616fce7ca63fe787ed3bcf9705bdcd506644cf0c86b1dce78572a4866555`. Three theorem axiom lists were empty; `not_FO1Defines_hasEdge` used only `propext` (permitted). This is `LEAN_VERIFIED_ISOLATED`, not whole-repository `LEAN_VERIFIED`.

**Proved obstruction:** Under pure uncolored, loopless graph semantics with one reusable variable, FO¹ cannot inspect off-diagonal edges. Every vertex in `K₄` has the same FO¹ local type, yet `dim_F₂ Z₁(B₂(v)) = 6 - 4 + 1 = 3` exceeds the singleton FO¹ type count. Thus the displayed type-splitting inference in `papers/fo-k-locality/configuration_pumping.tex` fails for `k=1`, `Δ=3`, `R=1`. Pigeonhole counting implies repeated **equal** types, not necessarily distinct types.

**Limits:** A different pebble-configuration definition, extra colors/constants, `k≥2`, or bounded-rank logic may change the target. This does not prove or refute the intended general FOᵏ program. The original `H1Locality.lean` imported module has not been recompiled in this audit because the local mathlib cache is missing.

**Evidence:**
- `URF_FO1_FixedSemanticCounterexample.lean` — exact compiler-input bytes (historical `NOT_RUN` header is superseded by the receipt).
- `MAC_ISOLATED_COMPILATION_RECEIPT.md` — reported Mac compiler output and precise axiom interpretation.
- `verify_fixed_fo1_permitted_axioms_mac.sh` — source-pinned, read-only reproducibility harness; wrapper itself not subsequently rerun on Mac.
- `verify_fo1_pumping_counterexample.py` and `FO1_REPLAY_2026-11-23.log` — actual independent bounded Python replay; the Python test's `LEAN := NOT_RUN` refers to Python alone.
- `URF_FO1_CONFIGURATION_PUMPING_AUDIT_2026-11-23.md` — detailed conditional reasoning and necessary refinements; earlier status language is superseded by the compilation receipt.

**Remaining open boundary:** Define independently specified intended refinement procedures and an FOᵏ admissibility semantics. Any future positive type-splitting result requires an additional separation hypothesis, not only a cycle-space rank count.

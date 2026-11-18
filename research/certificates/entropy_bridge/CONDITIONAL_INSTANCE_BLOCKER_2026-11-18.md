# Lean conditional entropy equality — root-cause and nonpromoted candidate

Date: 2026-11-18
Candidate: `research/candidates/URFCoreUniformConditionalExplicitKernelCandidate.lean`
Exact published base: `a06477e82e96e90c316611c6bf71073e70297d62`
Toolchain required for verification: Lean 4.27.0, pinned mathlib `a3a10db0e9d66acbebf76c5e6a135066525ac900`

## Observation

Three isolated Lean compiles on the user's Mac failed at the SAME location in the
`uniform_fiber_entropy_exact` theorem declaration (line 622, column 51 of
the previous concatenated source). The resulting goal was:

`Real.log ↑(Fintype.card ↥f.ker) = Real.log sorry`

Significantly, the local context at failure contained the full inferred
uniform-fiber identity:

* `hsame`: restricted conditional masses are constant on the fiber.
* `hs`: restricted masses total 1.
* `hc`: each equals one over fiber cardinality.
* `hdistribution`: fiber law equals the uniform distribution.
* `hcard`: fiber cardinality equals kernel cardinality.
* `h_entropy` and `h_kernel`: both final mathematical equalities established.

Thus modifying the last `calc` chain could not repair the open metavariable.
The likely root cause is instance synthesis for `Fintype (LinearMap.ker f)`
*at elaboration of the theorem statement*, not any missing mathematical
result. The previous compiler displayed `sorryAx` and therefore those
attempts MUST NOT be reported as proofs.

## Repair candidate (NOT_RUN)

The new file explicitly binds a `[Fintype (LinearMap.ker f)]` instance
after the linear map binder `(f : Q →ₗ[K] W)` in the statement of each
kernel-cardinality entropy equality. This makes the binder available at
statement elaboration time. The assumption is a data/instance choice,
not mathematical finiteness beyond `[Fintype Q]`: the kernel is a
subtype of finite `Q`, so its finiteness follows.

The candidate's two stages are `uniform_fiber_entropy_exact_candidate`
and `linear_uniform_conditional_entropy_exact_candidate`.

The averaged theorem treats positive-probability observations via exact
fiber entropy, and zero-probability observations via the vanishing
weight; it then uses `observedMass_sum_one`.

## Mandatory validation before promotion

1. Compile candidate as a single file using the repository's exact toolchain.
   Stop at the first compiler failure.
2. Run `#print axioms` on both load-bearing candidate theorems.
   Accept only `propext, Classical.choice, Quot.sound`.
3. Check that the added `Fintype` instance is not an independent
   mathematical restriction by supplying one from `Fintype Q`.
4. Only after 1–3 pass, integrate declarations into the authoritative
   source, rebuild the exact HEAD, inspect the diff, and consider promotion.

This note records a candidate, not a verified Lean theorem.
Local Mac repository state is not inferred from remote GitHub state.
The user's last reported local HEAD remained `a06477e82e96...`,
with `urf-cli/.venv/` and `urf-cli/dist/` untracked and untouched.

# Lean verification receipt — exact finite-obstruction tag exhaustion (2026-11-24)

**Result:** `LEAN_VERIFIED_ISOLATED` for six theorems; `AXIOM_AUDIT := PASS 6/6`.

The successful macOS Lean output was provided by the researcher in this conversation at 2026-11-24T17:18:41Z. The assistant has independently checked the GitHub source identities, exact script bytes and proof text, but **has not run Lean on the user's Mac or inspected the complete ephemeral local compiler log**. This is a user-supplied execution receipt, not a separately reproduced build.

## Exact input identity

- Repository: `inaciovasquez2020/urf-core`
- Local Mac checkout HEAD reported: `b02b6a965930ddb22e3cbfe6c733f727baf925f0`, branch `main`, clean `git status --short`.
- Original Lean source: `lean/URF/DescentSystem.lean`; local Git blob `a40427cc407f990040f0cf87870b2e9ccbde0b69` (reported and independently confirmed at remote commit).
- Repository Lean toolchain: `leanprover/lean4:v4.27.0`.
- mathlib pin / local checkout as previously checked: `a3a10db0e9d66acbebf76c5e6a135066525ac900`.
- Four extracted declarations: `Configuration`, `FiniteObstructionSelector`, `finiteObstructionDescentStep`, `finiteObstructionDescentNstep`. These sections were compared byte-for-byte with the corresponding sections in newer `DescentSystem.lean` Git blob `be8a64f877be7aaf0153e6b6779fd738bf34fb21` and found identical.
- Required sole mathlib import in generated proof: `Mathlib.Data.Finset.Card`. The earlier `Finset.Basic` trial failed because it does not expose `Finset.card`; that failure carried `sorryAx` and is **not** the verified checkpoint.
- Reproducer: `verify_sharp_rank_mac.sh`; Git blob `e1d56313ccc68d3cf50d90d564c344f62120e98d`, SHA-256 `89c18a1bb3d0dae333385fcef00dbf0d19d88d8ebf14208ac9a57bcb3ded9d65`. The script is **byte-identical** to the generated conversation attachment, including its trailing newline.
- Materialized proof: `SharpRankVerifiedIsolated.lean`, reconstructed from the exact extracted remote source declarations and the exact proof string embedded in the script; Git blob `e04dee2a775fdb5b0b160c08847f8dc9c4cbc0ee`.
- Mac source modifications / Git mutations: NONE, per user output.

## Exact reported macOS compiler output

```text
HEAD := b02b6a965930ddb22e3cbfe6c733f727baf925f0
BRANCH := main
STATUS_BEGIN
STATUS_END
EXACT_DECLARATIONS := 4
PROPOSED_THEOREMS := 6
=== LEAN COMPILATION ===
info: [root]: lakefile.lean and lakefile.toml are both present; using lakefile.lean
'URF.SharpRankAudit.step_card' depends on axioms: [propext, Classical.choice, Quot.sound]
'URF.SharpRankAudit.step_rank' depends on axioms: [propext, Classical.choice, Quot.sound]
'URF.SharpRankAudit.nstep_card' depends on axioms: [propext, Classical.choice, Quot.sound]
'URF.SharpRankAudit.nstep_rank' depends on axioms: [propext, Classical.choice, Quot.sound]
'URF.SharpRankAudit.rank_zero_at_initial_rank' depends on axioms: [propext, Classical.choice, Quot.sound]
'URF.SharpRankAudit.data_empty_at_initial_rank_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
SHARP_RANK_IFF := LEAN_VERIFIED_ISOLATED
AXIOM_AUDIT := PASS 6/6
STATUS_END
GIT_MUTATIONS := NONE
LOG := /var/folders/g7/t7cdygm521zfn6t572ncddgw0000gn/T/urf-rank-sharp.XXXXXX.zmJzWsPmHl/lean.log
```

## Exact mathematical result

For any type `O`, decidable equality and `selector : FiniteObstructionSelector O`, with `C : Configuration (Finset O)`, write `S_n` for `(finiteObstructionDescentNstep selector n C).data`.

The checked theorems establish
[
|S_n|=|C.data|mathbin{dot-}n,qquad
(finiteObstructionDescentNstep selector n C).rank=C.rankmathbin{dot-}n,
]
where `dot-` is truncated natural subtraction, and
[
S_{C.rank}=emptysetquadLongleftrightarrowquad |C.data|le C.rank.
]
No selector choice or graph-minor assumption is hidden in the statement.

A previous independent Mac run also reported `LEAN_VERIFIED_ISOLATED` and a 3/3 allowed-axiom audit for `URF.RankAudit.dominance_step`, `dominance_nstep`, `rank_zero_implies_empty`. These are corroborating **sufficient-condition** lemmas; the present six declarations prove the stronger sharp statement.

## Explicit boundary / merge gate

- **PROVED / LEAN_VERIFIED_ISOLATED:** exact finite-tag deletion and rank-count dynamics, sharp necessary-and-sufficient exhaustion criterion.
- **NOT_RUN:** integrating these theorems into the actual production `URF.DescentSystem` module, compiling that full source against the pinned mathlib, and running the corresponding production-module `#print axioms`.
- **OPEN:** faithful graph-to-tag encoding and whether any actual repository graph refinement operation has fixed FO^k semantics; `URF.H1Locality` is not established by these theorems.
- **INDEPENDENT_REVIEW:** not received as of this record.
- **RESEARCH_ONLY:** these files are stored outside `lean/` production imports and must not be represented by general GitHub CI green status as compiled by that CI.

This checkpoint is additive. The historical uncompiled candidate `RankDominanceCandidate.lean` remains unmodified and should not be relabeled `LEAN_VERIFIED` merely because a different isolated six-theorem source compiled.

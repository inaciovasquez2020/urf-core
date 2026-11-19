# Sharp clique entropy — verification checkpoint

## Evidence

- Source commit: `f5c51cca2fae70494e89abcf88d1739c7f97e8ee`.
- Source: `research/candidates/URFCoreSharpCliqueEntropyCandidate.lean`.
- Source Git blob: `786ce2b558867163eba50576b9d519659811db27`.
- Workflow Git blob: `a8475e737796b8f06e37ac0d666efb1ffec6de54`.
- Lean: 4.27.0; mathlib: `a3a10db0e9d66acbebf76c5e6a135066525ac900`.
- User-supplied GitHub Actions summary, 2026-11-18 Central time: all ten workflows successful at source commit, including URF isolated entropy verification #15 (4m 4s).
- Workflow inspected at source commit: exact HEAD and dependency checks, three isolated compilation commands with pipefail, mandatory axiom receipts for 3 entropy, 20 graph and 4 final declarations, allowed axioms only propext, Classical.choice, Quot.sound. Compiler logs and hashes configured for artifact upload.
- Raw successful run artifact not independently retrieved; this document is an evidence summary, not a raw compiler receipt.

## Mathematical scope

For a finite simple graph G over a finite field K of size q, let Z be the kernel of the oriented incidence map, B the span of oriented triangle boundaries inside Z, and R the span of circulations supported in closed one-neighborhoods. The verified chain construction gives R=B. The observation is restriction of linear functionals Z* -> R*, not observation of arbitrary vertex labels or arbitrary graph signals. H1 here is the explicit algebraic clique-chain quotient Z/B. The conditional entropy uses natural logarithms and finite probability masses.

The four final declarations prove kernel cardinality q^dim(H1), its logarithmic identity, the entropy upper bound for every input distribution, and attainment under uniform input. Together these imply the maximum formula. There is no separate supremum declaration. Explicit Fintype instances on the finite dual spaces remain in the statements. The source is an isolated research candidate, not a main-library integration.

## Final load-bearing declarations

In namespace URF.EntropyBridge:
- radiusOne_kernel_card_eq_pow_cliqueH1_candidate
- radiusOne_log_kernel_eq_cliqueH1_candidate
- radiusOne_entropy_le_cliqueH1_candidate
- radiusOne_uniform_entropy_eq_cliqueH1_candidate

Status: LEAN_VERIFIED via reported successful remote CI and inspected mandatory gates. The initial timeout and type mismatch were resolved by explicitly specializing Module.card_eq_pow_finrank to the field and kernel type, restoring the default heartbeat budget. No theorem hypotheses were changed by that repair. Historical NOT_RUN comments in the candidate record earlier development state, not the current evidence status.

## Limits

No claim of novelty, independent scholarly review, general radius equivalence, canonical dual equivalence, or global URF rigidity. Identification with a separate topological realization library is not asserted to be Lean-verified. Main-branch merge and Mac-local replay not performed. This documentation commit does not change Lean or workflow sources and is not itself the cited proof checkpoint.

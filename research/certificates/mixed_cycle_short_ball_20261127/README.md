# Generalized mixed-cycle minimax — isolated Lean certificate

STATUS: LEAN_VERIFIED for the global minimax theorem, at proof revision `30ec5c81deea4951741a48bfa11e291ed6cd810d`.

Target: `URF.EntropyBridge.cyclePartition_mixed_radius_minimax_value`.
For N >= L >= 3, observation radius r, and finite field cardinality q, the
least achievable worst-case absolute entropy estimation error on the original
admissible cycle families is

    max(0, floor(N / max(L, 2r+2)) - 1) * log(q) / 2.

The observation is the multiset of actual rooted induced radius-r neighborhoods.
The target is the existing uniform incidence-kernel entropy. The estimator uses
the recovered short-component count and the presence of long vertices; the
all-long subclass supplies the matching lower bound.

## Verification receipt

- Proof revision: `30ec5c81deea4951741a48bfa11e291ed6cd810d`.
- [Exact-head CI run](https://github.com/inaciovasquez2020/urf-core/actions/runs/46103936467).
- [Compiler and axiom audit](https://github.com/inaciovasquez2020/urf-core/actions/runs/46103936467/job/140852357914).
- Lean 4.27.0; mathlib `a3a10db0e9d66acbebf76c5e6a135066525ac900`.
- Dependency build: PASS (7893 jobs); compilation PASS; axiom audit PASS_9_OF_9.
- Final theorem axioms: propext, Classical.choice, Quot.sound only.
- Proof fragment Git blobs: ShortCycleProbe `27878a0b367c33a2b60f973e28acc3503f0b1253`,
  FinalMinimaxProbe `0fbc5cbc587937d05b9705627846bee4dc367088`.

The isolated workflow replays the pinned original neighborhood and radius-minimax
sources with the two proof fragments in temporary runner storage. It checks
exact head and dependency pins and audits all nine load-bearing declarations.
The original Lean library modules are unchanged. This certificate is not yet
an importable main-library theorem. No local Mac build or independent formal
proof review is claimed.

## Scope boundary

The global formula is Lean-verified for the represented admissible cycle
families. The [earlier paper and computational certificate](../mixed_cycle_minimax_20261127.md)
records the mathematical argument and historical pre-Lean status; the
pointwise deck-optimal formula itself is not asserted Lean-verified here.
Transfer to arbitrary finite simple 2-regular graphs, novelty, and independent
full formal-proof review remain open. No broader locality or complexity
separation is claimed.

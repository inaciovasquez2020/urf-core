# PR 596 — Transcript integration verification

Base revision: 0f45082cc9da4c5c31d0b1387a7ce465e4e2b3c6

Lean toolchain: leanprover/lean4:v4.27.0

Verification performed on the authoritative local Mac
using an isolated source tree and existing dependencies.

- Complete transcript mutual-information induction: PASS
- Conditional mutual-information capacity bound: PASS
- Transcript time-capacity bound: PASS
- Full URF library build: PASS (7956 jobs)
- Imported axiom audit: PASS (15 declarations)
- Allowed axioms: propext, Classical.choice, Quot.sound
- Original research checkpoint: preserved

Exactly two Lean source modules were repaired.
The existing theorem statements retain their hypotheses.
The step conditional-information definition was corrected
to condition on the preceding transcript.

The time-dependent capacity bound is valid but not sharp
in general. No claim of global URF rigidity or mathematical
novelty is made.

Public logs have local filesystem paths redacted.
Original receipts remain in the durable local checkpoint.

Remote CI for the promoted source must pass separately.

## Verified original SHA-256 receipts

- `lean/FiniteTranscriptChainInduction.lean`: `39c8b555a0d6059b22513b12a6bf2a7e2edddb57a2639ed4798be1448259cfa4`
- `lean/FiniteTranscriptCapacityBound.lean`: `eaeead4557aee58086ffd584f47d420928ff779dba179b22f983a572b48e58a7`
- `receipts/full-build.log`: `3029c7c76525016d2b956ecbb231a17bc8945bc5b3611fe06b71ba62d97b7439`
- `receipts/ImportedAudit.log`: `f234223c0a3af4de6b6231154ec5b62e687032ffdc9cffab69c349872a31bb2e`
- `receipts/ImportedAudit.lean`: `cf226549c38e6122a0d36f8916827f487150b20e09e090ee10f768b6753e8732`

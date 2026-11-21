# General radius-support equivalence

Status: LEAN_VERIFIED

The theorem `radiusCycles_eq_boundedSupportCycleSpace`
establishes equality of the radius-generated cycle
space and the bounded-support-generated cycle space
at cutoff 2r+1.

Scope:
- Finite simple graphs.
- Linearly ordered vertex type.
- Arbitrary coefficient field.
- Arbitrary natural-number radius.

Verification:
- Lean 4.27.0.
- Mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900.
- Both theorem inclusions compiled.
- Fundamental circulation basis compiled.
- Complete URF umbrella compiled.
- 54 axiom audits passed.
- 451 regression tests passed.
- Recovered proof patch checksum validated.

Permitted target axioms:
propext, Classical.choice, Quot.sound.

Maintenance boundaries:
The accompanying Python changes reconcile outdated
source-text assertions with existing declarations.
They do not independently prove mathematical results.

The obligation scanner is lexical, not a complete
Lean parser or kernel dependency audit.

Historical status documents describe earlier
checkpoints. Current Law 3 is a conditional
implication shell, not an independent derivation
of entropy nonamplification.

TM and RAM normalization consume explicit
invariants. Their unrestricted normalization
claims remain open.

Arithmetic spectral coercivity is established only
for the specified concrete finite family.

No claim of unrestricted URF closure, Poincare
closure, P versus NP resolution, or Clay problem
resolution is made.

Independent scholarly novelty remains unassessed.

The optional representation of every fundamental
basis vector as an actual simple-cycle walk remains
open.

Validation was performed in an isolated Mac
candidate using compatible existing dependencies.
Compiled dependency provenance was not independently
authenticated byte-for-byte.

# URF-Core finite graph entropy checkpoint

Status: LEAN_VERIFIED for the named declarations below.

Repository base:
d591fbde55e672e0950dfff5c3ffdfb7c3ee31b2

Toolchain: Lean 4.27.0
Mathlib: a3a10db0e9d66acbebf76c5e6a135066525ac900

Source: URFCoreConcreteGraphStage.lean

Verified at the final consolidated-source gate:
- URF.EntropyBridge.orderedEdge_finite
- URF.EntropyBridge.concreteGraph_hidden_finrank

Both depend only on:
propext, Classical.choice, Quot.sound.

The consolidated source also contains previously
individually compiler-verified probability, entropy,
linear-kernel, and graph-chain theorems.

Definitions included:
- SimpleGraph ordered edges
- incidence matrix and linear boundary
- cycle space
- bounded-edge-support cycle subspace
- graph-chain observation
- finite uniform probability

OPEN:
- concrete graph entropy inequality as one assembled theorem
- uniform-input conditional entropy equality
- radius-local cycle-space equivalence
- identification with all intended URF locality models

Bounded support is not equivalent to radius locality
without an additional theorem.

This is a verified research checkpoint, not a proof
of the open global rigidity conjectures.

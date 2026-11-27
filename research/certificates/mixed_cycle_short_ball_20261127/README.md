# Short-cycle neighborhood candidate

STATUS := NOT_RUN at branch creation.

Target: `URF.EntropyBridge.cyclePartition_shortBall_eq_component`.
This is an isolated candidate, not an integrated theorem or a closure claim.

Base: 297a633b164fd91dade9e2b47bda6056867e3f59. Existing audited source is preserved byte-for-byte.
The CI job concatenates the original neighborhood source and the candidate
fragment in runner temporary storage to reuse its private modular-offset lemmas,
builds the actual import dependency, checks the exact head and dependency pins,
and audits the target's axioms. A successful run would verify only this lemma.
A failed or timed-out run does not verify it. No local Mac storage required.

Mathematical proof: let m be the cycle length and d=y-x. If |d|<=r use d.
If d>r use d-m; if d<-r use d+m. The hypothesis m<=2r+1 ensures each chosen
representative lies in [-r,r], and modular equivalence identifies its endpoint.
The existing offset-walk lemma gives ball membership. Reachability excludes
vertices in other components.

Remaining: rooted isomorphism with the full cycle, separation of short-cycle
classes from path classes, deck decomposition, minimax assembly, and arbitrary
finite simple 2-regular graph classification. Generalized minimax remains OPEN
in Lean. No promotion or merge requested.

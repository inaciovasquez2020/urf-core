# Canonical edge uniqueness — minimal Lean gate

Date: 2026-11-18
Branch: `research/entropy-uniform-radius-audit-20261118`
Exact source: `research/candidates/CanonicalOrderedEdgeUniquenessCandidate.lean`

Status: MATHEMATICALLY PROVED; LEAN candidate NOT_RUN.
The original verified checkpoint remains unchanged.

## Why this particular lemma

The previous `URFCoreSpokeRowIsolationCandidate.lean` contains a
candidate general row-isolation proof but leaves its graph-specific
`SpokeIsolationTarget` proposition open. The smallest graph-specific
step is uniqueness of an undirected edge from its unordered endpoints
when each edge is represented by an increasing-order pair.

Precise theorem: let `e,d : {p : V × V // p.1 < p.2}`.
If either `(e.1,d.1)` and `(e.2,d.2)` match coordinatewise,
or the endpoint coordinates match after a swap, then `e=d`.

Proof: coordinatewise equality gives subtype equality. The swapped
case would imply `e.1 < e.2 = d.1 < d.2 = e.1`, contrary to
irreflexivity of `<`. This uses only linear-order axioms.

The candidate imports Mathlib, contains a complete tactic proof and
a `#print axioms` request, and deliberately uses no sorry/admit/axiom.

## Exact next use

Map each `OrderedEdge G` to the canonical increasing pair subtype.
For distinct supported spoke edges `e,d` contributing at the same
noncentral incidence row `u`, both have unordered endpoints
`{u,v}`. The uniqueness lemma then yields `d=e`, contradicting
the distinctness assumption. This supplies `SpokeIsolationTarget`,
which allows the existing matrix row-isolation proof to conclude
`z=0`.

## Verification gate

First compile ONLY `CanonicalOrderedEdgeUniquenessCandidate.lean`
with the pinned repository toolchain Lean 4.27.0 and inspect the axiom
report. Stop at first compiler error; do not stack additional untested
Lean proof patches or amend the authoritative source.

The GitHub write is an archival research commit, NOT an executed Lean
build. New exact-HEAD build, merge and promotion are NOT_RUN.

UNIFORM_CONDITIONAL_ENTROPY := OPEN
SPOKE_ONLY_LEAN := OPEN
RADIUS_ONE_CONE_BASIS_LEAN := OPEN
GLOBAL_URF_RIGIDITY := OPEN

# FO^k locality: cross-source consistency and dependency audit

Date: 2026-11-24. Scope: GitHub main base 5deab2c9a4f57734e50d0e15e8effc9103128c3a. Research-only source audit. Production files NOT edited; no full Lean build or mathematical novelty review.

## Verbatim source identities verified by GitHub blob ID

1. papers/fo-k-locality/cycle_orbit_splitting.tex — 016d1452401f485e8b920aae2324ca323f8890c4.
2. toolkit/URF-Core/final-wall-fo-k-locality/lemmas/cycle_orbit_splitting.tex — same Git blob 016d1452401f485e8b920aae2324ca323f8890c4.
3. final-wall-fo-k-locality/clr/clr_cycle_orbit_splitting.tex — b624852c410721d2bd09f43374a2889e10cc02c5. Explicitly describes the cycle-rank-to-type-splitting implication as MISSING and warns that finiteness of types does not imply diversity.
4. papers/fo-k-locality/configuration_pumping.tex — 4e9caabf860473c981d814942a92aae892220f46.
5. toolkit/URF-Core/final-wall-fo-k-locality/lemmas/configuration_pumping.tex — same Git blob 4e9caabf860473c981d814942a92aae892220f46.
6. papers/fo-k-locality/cycle_fan_predicate.tex — 3ecf5d5c8a91c7cea378c91075005cc4266eb270.
7. toolkit/URF-Core/final-wall-fo-k-locality/lemmas/cycle_fan_predicate.tex — same Git blob 3ecf5d5c8a91c7cea378c91075005cc4266eb270.
8. papers/fo-k-locality/fo-k-locality.tex — 8f0469869a73c4592abfa2e7eaf1bad6c140a65b. Imports both pumping and splitting text; labels final result conditional on pumping.

## Exact mathematical defects

**A. No nonvacuous cycle-rank threshold.** Under the source's standard uncolored simple graph setting, with Delta=3 and R=1, every induced radius-two ball has at most 10 vertices and F2 cycle rank at most 6. KG(5,2) (Petersen) attains 6, but every vertex belongs to the same automorphism orbit. Thus the displayed splitting implication is FALSE for any threshold t*<=6; for t*>6 it is VACUOUS. See PETERSEN_SHARP_NONVACUITY_OBSTRUCTION_20261124.md and exact checker receipt in this directory. This holds for any automorphism-invariant vertex type, including standard pure FO^k and counting logic, independent of k. Does not cover parameterized types anchored by an additional distinguished vertex, non-invariant vertex IDs, or different configuration conclusions.

**B. Pigeonhole cannot create type diversity.** configuration_pumping.tex states that two distinct configurations have identical type and then "Consequently" asserts the existence of two vertices of *different* type. That implication is invalid. Moreover, the numerical hypothesis rank > |T| counts independent cycles, not necessarily a set of distinct pebble configurations; a map from a cycle basis into configurations is an additional obligation before any pigeonhole argument can even produce a pair of equal types.

**C. The purported FO^k cycle-fan predicate contains \`exists^{>=m} z\`.** This is a counting-quantifier form, not automatically part of ordinary FO^k. If intended as an abbreviation, the expansion must be exhibited with at most k variable names; when m exceeds the available variable bound this is a serious missing step. Alternatively the logic must explicitly be changed to counting logic C^k, with corresponding altered theorem assumptions. The issue is orthogonal to the Petersen symmetry obstruction.

**D. Cross-source classification conflict.** The CLR variant explicitly records the missing lemma and warns that finite type count does not force type diversity, but the two other copies still present the same transfer as an operative lemma. The paper's "conditional on pumping" disclaimer is not a proof: pumping as written has an invalid implication and does not yield splitting.

## Safe repair boundary

- Promote the CLR file's MISSING classification as authoritative; do not use cycle-rank-to-vertex-type splitting in any unconditional or conditional derivation whose condition is claimed discharged.
- Separate legitimate finite-type pigeonhole statements (for explicitly counted configurations) from false type-splitting conclusions.
- Fix signature and vocabulary (uncolored/colored, order, constants), FO^k versus C^k, free variables, named parameters, quantifier rank, and whether types classify vertices or tuples.
- Identify a **fixed actual repository refinement operator** and its run semantics before stating that it is FO^k-admissible.
- A new nonvacuous splitting lemma must impose and verify additional hypotheses that overcome automorphism transitivity; cycle rank alone does not.

STATUS: SOURCE_AUDIT + PROVED obstruction (paper) + COMPUTATION_PASS (bounded Petersen check). No independent novelty claimed. LEAN_FOR_NEW_PETERSEN_THEOREM := NOT_RUN. PRODUCTION_FILES := UNCHANGED. MERGE := NOT_PERFORMED.

# Exact computational replay, 2026-11-26

Status: COMPUTATION_PASS (container, not Mac). Two complete Python 3.13.5 runs of each source produced byte-identical logs; SymPy 1.14.0 was used for symbolic physics checks. No new Lean build. Run with Python assertions enabled, from this directory:
```sh
python3 -B urf_foundations_audit.py
python3 -B urf_normalization_physics_audit.py
```
Each script has a 90-second process alarm; timeout/nonzero exit is INCOMPLETE or FAIL, not PASS. No network or repo mutations in scripts. Second script requires the already installed SymPy. Compare stdout to the adjacent .log files. Exact tested source and log Git blobs:

| File | Git blob | SHA256 |
| --- | --- | --- |
| urf_foundations_audit.py | 8e6e170deceda441a317933214464a38c6045d45 | 70246207a9063fea2d61a1b206eec3355c231d7218d1ac1c7fb72bac89e75300 |
| urf_foundations_audit.log | 9c2e874e1c98a659eb73291773ca036b2dcd907e | f5a4464e1dba87384efe6e33f30dd8916e6de3c9af242ef2bf20c925282e47bc |
| urf_normalization_physics_audit.py | 8baddae82bf6d0d6d1d1a7697596e755cf4d363a | 146b386bda3549e20d90142ed8f79bc6fd0ffa5d81f3be4f5be4533334418b0f |
| urf_normalization_physics_audit.log | 5d770a54c9475837447231525eba5dd70063f31a | bfcd81b67a3bffe40b80b8dc4dab148207a0b5e67bcbb4fcf77422882d89c2c2 |

The finite tests include 390 COR spectrum cases, 464 binary subspaces, 13,130 class-marginal comparisons, 464 optimal decision-tree evaluations, 3,876 entropy identities (integer prime-log coefficients), 2,198 packing cases, 3,297 coloring/cover cases, 98,304 machine-step comparisons, and 90,112 expanded-DAG color decoder checks. Counts describe different units and are not independent theorem proofs. Symbolic checks derive the flat-spatial static Einstein tensor, Gaussian derivatives, and shell algebra; they do not establish physical realizability. The cosmological check is for the specified normalization convention, not observed cosmology. Earlier unsupported 312-case receipt in Chronos #1386 is withdrawn.

Lean reuse audit at base 322d1af0f2338b6b61df25cb342ca377a5441a95: FiniteMutualInformationDecomposition.lean (bf41ddace7b40f4869726679c4c1db27b10dfa32) proves MI = marginal entropy minus conditional entropy; FiniteTranscriptChainInduction.lean (031ab4b60b69c899fea2514b630f261527d7c49c) proves transcript MI = sum of conditional MI increments; FiniteTranscriptCapacityBound.lean (f9a66e3190c5ecaad0eb560fc31911f4a6dd7057) uses log of retained input alphabet size, NOT observation alphabet size. A new right-cardinality bound is required for an observation-capacity theorem. Historical axiom audit exists, but this session did not replay Lean. No status promotion for global TRAP or P vs NP.

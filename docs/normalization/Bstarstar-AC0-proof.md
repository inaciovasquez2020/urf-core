# B** normalization proof sketch — withdrawn inference

**Status: OPEN.** See [AC0 mathematical erratum](../math/AC0_CSP_NORMALIZATION_ERRATUM_2026_11_26.md). Historical statements remain available at the source blobs listed there.

The historical argument inferred O(1) aggregate information per round from bounded fan-in and arity. For n independent uniform bits, parallel coordinatewise copying or negation exposes n bits relative to an input-independent initial transcript. Thus the inference is REFUTED even for depth-one radius-zero updates. Bounded fan-in bounds dependency size per output, not the number of outputs. The statement also needs a circuit wiring/encoding and a proved cost-preserving simulation; bounded quantifier rank alone is not strict neighborhood locality.

A valid restricted statement: if each round exposes at most c bits of conditional entropy given the preceding nested transcript, its conditional mutual information about a fixed hidden variable is at most c. Summing the increments bounds total information acquisition. This does not establish the missing refinement simulation, terminal uncertainty requirement, or unrestricted separation. The exact path-broadcast theorem in the erratum remains valid.

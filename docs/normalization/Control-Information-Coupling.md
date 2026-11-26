# Control–information accounting — corrected scope

**Status: historical write-count inference REFUTED under data-memory-only conditioning/cost; general coupling and equivalence to TRAP OPEN.** See the [foundational erratum](../foundations/ENTROPY_TRAP_FOUNDATIONAL_ERRATUM_2026_11_26.md) and [AC0 erratum](../math/AC0_CSP_NORMALIZATION_ERRATUM_2026_11_26.md).

If initial configuration includes the complete input of a fixed deterministic program, the trace is determined by it and conditional entropy is zero. If conditioning excludes read-only random input and the cost counts only data-memory writes, a branching program can read n independent bits, branch and rejoin at each read, and expose all n bits through the control trace without any data-memory writes. Indirect addressing is not required. Charging control-state changes or registers defines a different model. Variable costs also require a pathwise or expected formulation.

Valid replacement: for finite random variables, if P is a deterministic function of initial side information M and observations R_1,...,R_T, then H(P|M) <= H(R_1,...,R_T|M) <= sum_t log |alphabet(R_t)|, in consistent units. Fix/pad the horizon or charge termination. This is observation-capacity accounting, not a memory-write bound or a TRAP equivalence. No P vs NP conclusion follows.

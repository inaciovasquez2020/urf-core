# URF-Core Uniform Graph Entropy Certificate

Status: LEAN_VERIFIED

Base HEAD: a06477e82e96e90c316611c6bf71073e70297d62
Branch: research/entropy-graph-chain-20261117
Toolchain: leanprover/lean4:v4.27.0
Mathlib: a3a10db0e9d66acbebf76c5e6a135066525ac900

## Main result

URF.EntropyBridge.graphObservation_uniform_entropy_eq_finrank_gap

Uniform-input conditional entropy equals the difference
between global and selected local cycle dimensions,
multiplied by the logarithm of the finite-field cardinality.

## Validation

- Nine named declarations compiled and axiom-audited.
- Permitted axioms: propext, Classical.choice, Quot.sound.
- No sorryAx in the compiler output.
- Original checkpoint source independently recompiled.
- Certificate is standalone and does not alter existing imports.

## Limitations

- The identity applies to the specified graph observation map.
- Bounded-support locality is not automatically radius locality.
- Broader URF rigidity and Poincare claims remain open.
- Full repository build not performed by this certificate step.
- Independent mathematical review remains open.

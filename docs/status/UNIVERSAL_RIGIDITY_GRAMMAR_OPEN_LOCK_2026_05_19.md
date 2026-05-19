# Universal Rigidity Grammar Open Lock

Status: `CONDITIONAL_DEFINITIONS_AND_OPEN_PROBLEM_LOCK`

This package defines the local data needed for a universal rigidity grammar surface:

- `UniversalRigidityGrammarData`
- `AdmissibleDomainEncoder`
- `UniversalTranslationTheorem`
- `UnrestrictedUFEG`
- `OpenProblemPromotionLock`

It proves only the conditional theorem:

```lean
UniversalTranslationTheorem_conditional_on_equal_ranges
Meaning: if two injective admissible-domain encoders into the same grammar have equal ranges, then the already-verified shared-code bijection theorem gives a code-preserving equivalence between their carriers.
It also locks unrestricted UFEG as a terminal missing theorem:
UnrestrictedUFEG_open_problem_lock
Boundary:
Does not prove:
existence of a universal RigidityGrammar
unconditional UniversalTranslationTheorem
unrestricted UniversalFiberEntropyGap
Chronos-RR
H4.1/FGL
P vs NP
any Clay problem

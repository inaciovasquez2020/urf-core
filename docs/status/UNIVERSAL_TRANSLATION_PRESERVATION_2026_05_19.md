# Universal Translation Preservation

Status: `CONDITIONAL_TRANSLATION_PRESERVATION_CLOSED`

This package proves preservation consequences for the conditional universal translation surface.

Closed Lean theorems:

```lean
UniversalTranslationTheorem_two_sided_conditional_on_equal_ranges
UniversalTranslationTheorem_predicate_preservation
UniversalTranslationTheorem_relation_preservation
Meaning: once two admissible-domain encoders into the same grammar have equal encoder ranges, the already-verified shared-code bijection machinery supplies:
two-sided code preservation
grammar-level predicate preservation
grammar-level binary-relation preservation
Boundary:
Does not prove:
existence of a universal RigidityGrammar
unconditional UniversalTranslationTheorem
unrestricted UniversalFiberEntropyGap
Chronos-RR
H4.1/FGL
P vs NP
any Clay problem

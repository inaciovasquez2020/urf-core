import URF.Foundation.SharedRigidityCodeBijectionRangeIff

universe u v w

/-- Data for a proposed universal rigidity grammar. This is a data surface only. -/
structure UniversalRigidityGrammarData where
  Grammar : Type u

/-- An admissible-domain encoder into a fixed grammar, with injective code map. -/
structure AdmissibleDomainEncoder
    (G : UniversalRigidityGrammarData.{u})
    (Carrier : Type v) where
  encode : Carrier → G.Grammar
  injective_encode : Function.Injective encode

/-- The range of an admissible-domain encoder inside the grammar. -/
def AdmissibleDomainEncoder.range
    {G : UniversalRigidityGrammarData.{u}}
    {Carrier : Type v}
    (E : AdmissibleDomainEncoder G Carrier) : Set G.Grammar :=
  Set.range E.encode

/--
Conditional universal translation theorem surface.

For two admissible encoders into the same grammar, equality of encoder ranges
implies existence of a code-preserving equivalence between carriers.
-/
def UniversalTranslationTheorem
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B) : Prop :=
  Set.range EA.encode = Set.range EB.encode →
    ∃ e : A ≃ B, ∀ a : A, EB.encode (e a) = EA.encode a

/-- The conditional universal translation theorem follows from the local shared-code bijection theorem. -/
theorem UniversalTranslationTheorem_conditional_on_equal_ranges
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B) :
    UniversalTranslationTheorem G A B EA EB := by
  intro h_range
  exact SharedRigidityCodeBijection
    EA.encode
    EB.encode
    EA.injective_encode
    EB.injective_encode
    h_range

/-- Terminal missing theorem surface for unrestricted UFEG. No proof of the statement is provided here. -/
structure UnrestrictedUFEG where
  statement : Prop

/-- Promotion state for terminal missing theorem locks. -/
inductive OpenProblemPromotionLock where
  | frontierOpen

/-- Unrestricted UFEG remains locked as a frontier-open terminal missing theorem. -/
def UnrestrictedUFEG_terminal_missing_theorem_status : OpenProblemPromotionLock :=
  OpenProblemPromotionLock.frontierOpen

/-- Open-problem lock preventing this package from promoting unrestricted UFEG. -/
theorem UnrestrictedUFEG_open_problem_lock :
    UnrestrictedUFEG_terminal_missing_theorem_status =
      OpenProblemPromotionLock.frontierOpen := rfl

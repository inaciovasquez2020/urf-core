import URF.Foundation.UniversalTranslationPreservation

universe u v w

/-- Existence of a universal-code-preserving equivalence forces equal encoder ranges. -/
theorem UniversalTranslationTheorem_range_eq_of_exists
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B)
    (h : ∃ e : A ≃ B, ∀ a : A, EB.encode (e a) = EA.encode a) :
    Set.range EA.encode = Set.range EB.encode := by
  exact SharedRigidityCodeBijection_range_eq_of_exists
    EA.encode
    EB.encode
    h

/-- Equal encoder ranges exactly characterize conditional universal translation. -/
theorem UniversalTranslationTheorem_exists_iff_range_eq
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B) :
    (∃ e : A ≃ B, ∀ a : A, EB.encode (e a) = EA.encode a) ↔
      Set.range EA.encode = Set.range EB.encode := by
  exact SharedRigidityCodeBijection_exists_iff_range_eq
    EA.encode
    EB.encode
    EA.injective_encode
    EB.injective_encode

/-- The conditional universal translation proposition is definitionally the range-exact implication. -/
theorem UniversalTranslationTheorem_iff_range_exact
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B) :
    UniversalTranslationTheorem G A B EA EB ↔
      (Set.range EA.encode = Set.range EB.encode →
        ∃ e : A ≃ B, ∀ a : A, EB.encode (e a) = EA.encode a) := by
  rfl

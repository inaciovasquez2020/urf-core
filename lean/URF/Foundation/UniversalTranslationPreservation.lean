import URF.Foundation.UniversalRigidityGrammarData

universe u v w

/-- Conditional universal translation with two-sided code preservation. -/
noncomputable theorem UniversalTranslationTheorem_two_sided_conditional_on_equal_ranges
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B)
    (h_range : Set.range EA.encode = Set.range EB.encode) :
    ∃ e : A ≃ B,
      (∀ a : A, EB.encode (e a) = EA.encode a) ∧
      (∀ b : B, EA.encode (e.symm b) = EB.encode b) := by
  exact SharedRigidityCodeBijection_two_sided
    EA.encode
    EB.encode
    EA.injective_encode
    EB.injective_encode
    h_range

/-- Conditional universal translation preserves grammar-level predicates. -/
noncomputable theorem UniversalTranslationTheorem_predicate_preservation
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B)
    (h_range : Set.range EA.encode = Set.range EB.encode)
    (P : G.Grammar → Prop) :
    ∃ e : A ≃ B,
      (∀ a : A, EB.encode (e a) = EA.encode a) ∧
      (∀ a : A, P (EA.encode a) ↔ P (EB.encode (e a))) := by
  exact SharedRigidityCodeBijection_predicate
    EA.encode
    EB.encode
    EA.injective_encode
    EB.injective_encode
    h_range
    P

/-- Conditional universal translation preserves grammar-level binary relations. -/
noncomputable theorem UniversalTranslationTheorem_relation_preservation
    (G : UniversalRigidityGrammarData.{u})
    (A : Type v) (B : Type w)
    (EA : AdmissibleDomainEncoder G A)
    (EB : AdmissibleDomainEncoder G B)
    (h_range : Set.range EA.encode = Set.range EB.encode)
    (R : G.Grammar → G.Grammar → Prop) :
    ∃ e : A ≃ B,
      (∀ a : A, EB.encode (e a) = EA.encode a) ∧
      (∀ a₁ a₂ : A,
        R (EA.encode a₁) (EA.encode a₂) ↔
        R (EB.encode (e a₁)) (EB.encode (e a₂))) := by
  exact SharedRigidityCodeBijection_relation
    EA.encode
    EB.encode
    EA.injective_encode
    EB.injective_encode
    h_range
    R

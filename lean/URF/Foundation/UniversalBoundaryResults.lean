import URF.Foundation.UniversalTranslationRangeExact

universe u v

/-- A weak tagged universal grammar for a family of carriers. -/
def TaggedUniversalGrammar
    (Domain : Type u)
    (Carrier : Domain → Type v) : Type (max u v) :=
  Sigma Carrier

/-- The canonical tagged encoder into the weak tagged universal grammar. -/
def TaggedUniversalGrammar.encode
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain) : Carrier D → TaggedUniversalGrammar Domain Carrier :=
  fun x => ⟨D, x⟩

/-- The tagged encoder is injective on each carrier. -/
theorem TaggedUniversalGrammar_encode_injective
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain) :
    Function.Injective (TaggedUniversalGrammar.encode (Carrier := Carrier) D) := by
  intro x y h
  cases h
  rfl

/-- Weak tagged universal rigidity grammar existence. -/
theorem TaggedUniversalRigidityGrammarExistence
    (Domain : Type u)
    (Carrier : Domain → Type v) :
    ∃ Γ : Type (max u v),
      ∀ D : Domain, ∃ encode : Carrier D → Γ, Function.Injective encode := by
  refine ⟨TaggedUniversalGrammar Domain Carrier, ?_⟩
  intro D
  exact ⟨
    TaggedUniversalGrammar.encode (Carrier := Carrier) D,
    TaggedUniversalGrammar_encode_injective (Carrier := Carrier) D⟩

/-- Lift a carrier-level predicate to the tagged grammar by restricting to the selected tag. -/
def TaggedUniversalGrammar.PredicateLift
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain)
    (P : Carrier D → Prop) :
    TaggedUniversalGrammar Domain Carrier → Prop :=
  fun y => ∃ x : Carrier D, y = TaggedUniversalGrammar.encode (Carrier := Carrier) D x ∧ P x

/-- The predicate lift factors the original predicate through the tagged encoder. -/
theorem TaggedUniversalGrammar_predicate_factors
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain)
    (P : Carrier D → Prop)
    (x : Carrier D) :
    TaggedUniversalGrammar.PredicateLift (Carrier := Carrier) D P
      (TaggedUniversalGrammar.encode (Carrier := Carrier) D x) ↔ P x := by
  constructor
  · intro h
    rcases h with ⟨x', hx', hP⟩
    cases hx'
    exact hP
  · intro hP
    exact ⟨x, rfl, hP⟩

/-- Lift a carrier-level binary relation to the tagged grammar by restricting both arguments to the selected tag. -/
def TaggedUniversalGrammar.RelationLift
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain)
    (R : Carrier D → Carrier D → Prop) :
    TaggedUniversalGrammar Domain Carrier →
      TaggedUniversalGrammar Domain Carrier → Prop :=
  fun y z =>
    ∃ x₁ x₂ : Carrier D,
      y = TaggedUniversalGrammar.encode (Carrier := Carrier) D x₁ ∧
      z = TaggedUniversalGrammar.encode (Carrier := Carrier) D x₂ ∧
      R x₁ x₂

/-- The relation lift factors the original relation through the tagged encoder. -/
theorem TaggedUniversalGrammar_relation_factors
    {Domain : Type u}
    {Carrier : Domain → Type v}
    (D : Domain)
    (R : Carrier D → Carrier D → Prop)
    (x₁ x₂ : Carrier D) :
    TaggedUniversalGrammar.RelationLift (Carrier := Carrier) D R
      (TaggedUniversalGrammar.encode (Carrier := Carrier) D x₁)
      (TaggedUniversalGrammar.encode (Carrier := Carrier) D x₂) ↔ R x₁ x₂ := by
  constructor
  · intro h
    rcases h with ⟨y₁, y₂, hy₁, hy₂, hR⟩
    cases hy₁
    cases hy₂
    exact hR
  · intro hR
    exact ⟨x₁, x₂, rfl, rfl, hR⟩

/-- The Bool grammar used for the unconditional-translation counterexample. -/
def TranslationCounterexampleGrammar : UniversalRigidityGrammarData.{0} where
  Grammar := Bool

/-- Unit is encoded as the singleton code `false`. -/
def UnitFalseEncoder : AdmissibleDomainEncoder TranslationCounterexampleGrammar Unit where
  encode := fun _ => false
  injective_encode := by
    intro x y h
    cases x
    cases y
    rfl

/-- Bool is encoded by the identity. -/
def BoolIdEncoder : AdmissibleDomainEncoder TranslationCounterexampleGrammar Bool where
  encode := fun b => b
  injective_encode := by
    intro x y h
    exact h

/-- The counterexample encoders have unequal ranges. -/
theorem UnitFalseEncoder_range_ne_BoolIdEncoder_range :
    Set.range UnitFalseEncoder.encode ≠ Set.range BoolIdEncoder.encode := by
  intro h
  have htrue : true ∈ Set.range UnitFalseEncoder.encode := by
    rw [h]
    exact ⟨true, rfl⟩
  rcases htrue with ⟨u, hu⟩
  cases u
  cases hu

/-- There is no equivalence between Unit and Bool. -/
theorem no_Unit_equiv_Bool : ¬ Nonempty (Unit ≃ Bool) := by
  intro h
  rcases h with ⟨e⟩
  have hsymm : e.symm false = e.symm true := by
    cases e.symm false
    cases e.symm true
    rfl
  have hfalse_true : false = true := by
    calc
      false = e (e.symm false) := (e.apply_symm_apply false).symm
      _ = e (e.symm true) := by rw [hsymm]
      _ = true := e.apply_symm_apply true
  cases hfalse_true

/--
Unconditional universal translation from injective encoders alone is impossible.

The Unit/Bool counterexample defeats the statement.
-/
theorem not_unconditional_translation_from_injective_encoders :
    ¬ (∀ (G : UniversalRigidityGrammarData.{0})
        (A B : Type)
        (EA : AdmissibleDomainEncoder G A)
        (EB : AdmissibleDomainEncoder G B),
        ∃ e : A ≃ B, ∀ a : A, EB.encode (e a) = EA.encode a) := by
  intro h
  obtain ⟨e, _he⟩ :=
    h TranslationCounterexampleGrammar Unit Bool UnitFalseEncoder BoolIdEncoder
  exact no_Unit_equiv_Bool ⟨e⟩

/--
A minimal unrestricted UFEG obstruction surface:
an unrestricted vanishing-index family has no uniform finite floor.
-/
def UnrestrictedUFEGVanishingNatFloorTarget : Prop :=
  ∃ N : Nat, ∀ n : Nat, n ≤ N

/-- No natural number uniformly bounds all natural indices. -/
theorem UnrestrictedUFEG_vanishing_gap_obstruction :
    ¬ UnrestrictedUFEGVanishingNatFloorTarget := by
  intro h
  rcases h with ⟨N, hN⟩
  exact Nat.not_succ_le_self N (hN (N + 1))

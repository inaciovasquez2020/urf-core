import Mathlib

namespace URF
namespace Frontier

structure ArithmeticSpectralFamily
    (A : Type*) [Fintype A] where
  space : A → Type
  inner : (a : A) → space a → space a → ℝ
  normSq : (a : A) → space a → ℝ
  normSq_eq_inner_self :
    ∀ (a : A) (v : space a),
      normSq a v = inner a v v
  operator : (a : A) → space a → space a
  domain : (a : A) → space a → Prop
  admissible : (a : A) → space a → Prop

def ArithmeticSpectralCoercive
    {A : Type*} [Fintype A]
    (family : ArithmeticSpectralFamily A)
    (c : ℝ) : Prop :=
  0 < c ∧
    ∀ (a : A) (v : family.space a),
      family.domain a v →
      family.admissible a v →
      c * family.normSq a v ≤
        family.inner a (family.operator a v) v

inductive ReducedPrimitiveBinaryQuadraticForm
  | discriminantNegThree
  | discriminantNegFour
  | discriminantNegSeven
  deriving DecidableEq, Fintype

def reducedPrimitiveFormA :
    ReducedPrimitiveBinaryQuadraticForm → ℤ
  | .discriminantNegThree => 1
  | .discriminantNegFour => 1
  | .discriminantNegSeven => 1

def reducedPrimitiveFormB :
    ReducedPrimitiveBinaryQuadraticForm → ℤ
  | .discriminantNegThree => 1
  | .discriminantNegFour => 0
  | .discriminantNegSeven => 1

def reducedPrimitiveFormC :
    ReducedPrimitiveBinaryQuadraticForm → ℤ
  | .discriminantNegThree => 1
  | .discriminantNegFour => 1
  | .discriminantNegSeven => 2

def reducedPrimitiveFormDiscriminant
    (q : ReducedPrimitiveBinaryQuadraticForm) : ℤ :=
  reducedPrimitiveFormB q ^ 2 -
    4 * reducedPrimitiveFormA q * reducedPrimitiveFormC q

@[simp]
theorem reducedPrimitiveFormDiscriminant_negThree :
    reducedPrimitiveFormDiscriminant .discriminantNegThree = -3 := by
  norm_num [
    reducedPrimitiveFormDiscriminant,
    reducedPrimitiveFormA,
    reducedPrimitiveFormB,
    reducedPrimitiveFormC
  ]

@[simp]
theorem reducedPrimitiveFormDiscriminant_negFour :
    reducedPrimitiveFormDiscriminant .discriminantNegFour = -4 := by
  norm_num [
    reducedPrimitiveFormDiscriminant,
    reducedPrimitiveFormA,
    reducedPrimitiveFormB,
    reducedPrimitiveFormC
  ]

@[simp]
theorem reducedPrimitiveFormDiscriminant_negSeven :
    reducedPrimitiveFormDiscriminant .discriminantNegSeven = -7 := by
  norm_num [
    reducedPrimitiveFormDiscriminant,
    reducedPrimitiveFormA,
    reducedPrimitiveFormB,
    reducedPrimitiveFormC
  ]

def reducedPrimitiveFormInner
    (_q : ReducedPrimitiveBinaryQuadraticForm)
    (u v : ℝ × ℝ) : ℝ :=
  u.1 * v.1 + u.2 * v.2

def reducedPrimitiveFormNormSq
    (_q : ReducedPrimitiveBinaryQuadraticForm)
    (v : ℝ × ℝ) : ℝ :=
  v.1 ^ 2 + v.2 ^ 2

noncomputable def reducedPrimitiveFormOperator
    (q : ReducedPrimitiveBinaryQuadraticForm)
    (v : ℝ × ℝ) : ℝ × ℝ :=
  (
    (reducedPrimitiveFormA q : ℝ) * v.1 +
      (reducedPrimitiveFormB q : ℝ) * v.2 / 2,
    (reducedPrimitiveFormB q : ℝ) * v.1 / 2 +
      (reducedPrimitiveFormC q : ℝ) * v.2
  )

def reducedPrimitiveFormAdmissible
    (_q : ReducedPrimitiveBinaryQuadraticForm)
    (v : ℝ × ℝ) : Prop :=
  v ≠ (0, 0)

noncomputable def reducedPrimitiveBinaryQuadraticFamily :
    ArithmeticSpectralFamily
      ReducedPrimitiveBinaryQuadraticForm where
  space := fun _ => ℝ × ℝ
  inner := reducedPrimitiveFormInner
  normSq := reducedPrimitiveFormNormSq
  normSq_eq_inner_self := by
    intro q v
    rcases v with ⟨x, y⟩
    simp [
      reducedPrimitiveFormNormSq,
      reducedPrimitiveFormInner,
      pow_two
    ]
  operator := reducedPrimitiveFormOperator
  domain := fun _ _ => True
  admissible := reducedPrimitiveFormAdmissible

theorem reducedPrimitiveForm_energy_lower_bound
    (q : ReducedPrimitiveBinaryQuadraticForm)
    (v : ℝ × ℝ) :
    (1 / 2 : ℝ) * reducedPrimitiveFormNormSq q v ≤
      reducedPrimitiveFormInner q
        (reducedPrimitiveFormOperator q v) v := by
  rcases v with ⟨x, y⟩
  cases q with
  | discriminantNegThree =>
      simp [
        reducedPrimitiveFormNormSq,
        reducedPrimitiveFormInner,
        reducedPrimitiveFormOperator,
        reducedPrimitiveFormA,
        reducedPrimitiveFormB,
        reducedPrimitiveFormC
      ]
      nlinarith [sq_nonneg (x + y)]
  | discriminantNegFour =>
      simp [
        reducedPrimitiveFormNormSq,
        reducedPrimitiveFormInner,
        reducedPrimitiveFormOperator,
        reducedPrimitiveFormA,
        reducedPrimitiveFormB,
        reducedPrimitiveFormC
      ]
      nlinarith [sq_nonneg x, sq_nonneg y]
  | discriminantNegSeven =>
      simp [
        reducedPrimitiveFormNormSq,
        reducedPrimitiveFormInner,
        reducedPrimitiveFormOperator,
        reducedPrimitiveFormA,
        reducedPrimitiveFormB,
        reducedPrimitiveFormC
      ]
      nlinarith [sq_nonneg (x + y), sq_nonneg y]

noncomputable def ArithmeticSpectralCoercivityTarget :
    ArithmeticSpectralFamily
      ReducedPrimitiveBinaryQuadraticForm :=
  reducedPrimitiveBinaryQuadraticFamily

theorem ArithmeticSpectralCoercivityTarget_coercive :
    ArithmeticSpectralCoercive
      ArithmeticSpectralCoercivityTarget (1 / 2) := by
  constructor
  · norm_num
  · intro q v _ _
    exact reducedPrimitiveForm_energy_lower_bound q v

end Frontier
end URF

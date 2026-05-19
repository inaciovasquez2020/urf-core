import Mathlib

universe u v w

namespace URF
namespace Foundation
namespace CapacitySoundnessReduction

structure CapacityInterface where
  State : Type u
  Generator : Type v
  Trace : Type w
  Adm : Trace → Prop
  Encodes : Trace → Generator → Prop
  StableGen : Generator → Prop
  I : Generator → ℝ

variable (X : CapacityInterface)

def AdmissibleInformationSet : Set ℝ :=
  { r | ∃ g : X.Generator, ∃ τ : X.Trace,
      X.Adm τ ∧ X.Encodes τ g ∧ r = X.I g }

noncomputable def C_adm : ℝ :=
  sSup (AdmissibleInformationSet X)

def StableGenAdmissibleTrace : Prop :=
  ∀ g : X.Generator, X.StableGen g →
    ∃ τ : X.Trace, X.Adm τ ∧ X.Encodes τ g

def CapacitySoundness : Prop :=
  ∀ g : X.Generator, X.StableGen g → X.I g ≤ C_adm X

theorem admissibleTraceBound
    (hbounded : BddAbove (AdmissibleInformationSet X))
    {g : X.Generator} {τ : X.Trace}
    (hτ : X.Adm τ)
    (henc : X.Encodes τ g) :
    X.I g ≤ C_adm X := by
  dsimp [C_adm]
  exact le_csSup hbounded ⟨g, τ, hτ, henc, rfl⟩

theorem capacitySoundness_from_stableTrace
    (hbounded : BddAbove (AdmissibleInformationSet X))
    (htrace : StableGenAdmissibleTrace X) :
    CapacitySoundness X := by
  intro g hg
  obtain ⟨τ, hτ, henc⟩ := htrace g hg
  exact admissibleTraceBound X hbounded hτ henc

theorem capacity_obstruction_contrapositive
    (hbounded : BddAbove (AdmissibleInformationSet X))
    (htrace : StableGenAdmissibleTrace X)
    {g : X.Generator}
    (hover : C_adm X < X.I g) :
    ¬ X.StableGen g := by
  intro hg
  have hle : X.I g ≤ C_adm X :=
    capacitySoundness_from_stableTrace X hbounded htrace g hg
  exact not_lt_of_ge hle hover

end CapacitySoundnessReduction
end Foundation
end URF

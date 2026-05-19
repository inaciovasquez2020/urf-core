import Mathlib.Data.Nat.Basic

namespace URF

universe u v

structure CapacityObstructionSchema where
  System : Type u
  Goal : Type v
  Adm : System → Prop
  I : Goal → Nat
  C_adm : System → Nat
  StableGen : System → Goal → Prop

namespace CapacityObstructionSchema

variable (U : CapacityObstructionSchema)

def CapacitySoundness : Prop :=
  ∀ S G, U.Adm S → U.StableGen S G → U.I G ≤ U.C_adm S

def CapacityViolation (S : U.System) (G : U.Goal) : Prop :=
  U.Adm S ∧ U.C_adm S < U.I G

def CapacityObstruction : Prop :=
  ∀ S G, CapacityViolation U S G → ¬ U.StableGen S G

theorem contrapositive_obstruction
    (hSound : CapacitySoundness U) :
    CapacityObstruction U := by
  intro S G hViol hGen
  rcases hViol with ⟨hAdm, hLt⟩
  exact Nat.not_lt_of_ge (hSound S G hAdm hGen) hLt

theorem stable_generation_requires_capacity
    (hSound : CapacitySoundness U)
    {S : U.System} {G : U.Goal}
    (hAdm : U.Adm S)
    (hGen : U.StableGen S G) :
    U.I G ≤ U.C_adm S :=
  hSound S G hAdm hGen

theorem capacity_excess_blocks_generation
    (hSound : CapacitySoundness U)
    {S : U.System} {G : U.Goal}
    (hAdm : U.Adm S)
    (hExcess : U.C_adm S < U.I G) :
    ¬ U.StableGen S G := by
  intro hGen
  exact Nat.not_lt_of_ge (hSound S G hAdm hGen) hExcess

end CapacityObstructionSchema

end URF

import URF.DescentSystem

namespace URF

/--
Minimal formal interface for H1 Locality.

It records that a refinement procedure is judged admissible relative to one
fixed finite-variable bound `k`.
-/
structure FOkAdmissibleRefinementInterface where
  k : Nat
  k_pos : 0 < k
  RefinementProcedure : Type
  FOkAdmissible : RefinementProcedure → Prop

/--
H1 Locality target.

Document-level meaning:
Refinement procedures are FO^k-admissible for fixed k.

This file does not prove H1. It only creates the exact Lean target that must
eventually replace the informal referee-document hypothesis.
-/
def H1Locality : Prop :=
  ∃ I : FOkAdmissibleRefinementInterface,
    ∀ R : I.RefinementProcedure, I.FOkAdmissible R

/--
Boundary marker: H1 is now named as a Lean target, but remains only a target
until the FO^k-admissibility interface is supplied.
-/
def H1LocalityMissingFormalInterface : Prop :=
  True

/--
Conditional bridge: H1 follows from a supplied fixed-k FO^k admissibility
interface covering all refinement procedures in that interface.

This does not construct the interface.
-/
theorem h1_locality_from_fok_interface
    (I : FOkAdmissibleRefinementInterface)
    (hI : ∀ R : I.RefinementProcedure, I.FOkAdmissible R) :
    H1Locality := by
  exact ⟨I, hI⟩

theorem h1_locality_missing_formal_interface :
    H1LocalityMissingFormalInterface := by
  trivial

end URF

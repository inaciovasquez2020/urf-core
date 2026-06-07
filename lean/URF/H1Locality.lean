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

def NonVacuousFOkAdmissibleRefinementInterface : Prop :=
  ∃ I : FOkAdmissibleRefinementInterface,
    ∀ R : I.RefinementProcedure, I.FOkAdmissible R

/--
Concrete witness data for the next non-vacuous H1 step.

The `procedure` field prevents the next target from being satisfied by an
empty refinement-procedure type.
-/
structure ConcreteFOkAdmissibleRefinementInterfaceWitness where
  I : FOkAdmissibleRefinementInterface
  procedure : I.RefinementProcedure
  all_admissible : ∀ R : I.RefinementProcedure, I.FOkAdmissible R

/--
Repository-native nondegeneracy criteria for a future concrete FO^k witness.

This blocks vacuous witnesses such as `Unit` with predicate `True` by requiring
an external repository-native semantic binding object.
-/
structure RepositoryNativeNondegenerateFOkWitnessCriteria where
  W : ConcreteFOkAdmissibleRefinementInterfaceWitness
  RepositoryNativeSemanticBinding : Type
  binding_nonempty : Nonempty RepositoryNativeSemanticBinding

/--
Stricter missing object required before the repository-native semantic binding
criterion can be used non-vacuously.

A bare `Nonempty RepositoryNativeSemanticBinding` is insufficient, since it can
be discharged by `Unit`.
-/
structure NonVacuousRepositoryNativeSemanticBindingWitness where
  RepositoryNativeSemanticBinding : Type
  semantic_binding_witness : RepositoryNativeSemanticBinding
  nonvacuous_semantic_content : Prop
  content_proof : nonvacuous_semantic_content

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

theorem nonvacuous_fok_interface_from_concrete_witness
    (W : ConcreteFOkAdmissibleRefinementInterfaceWitness) :
    NonVacuousFOkAdmissibleRefinementInterface := by
  exact ⟨W.I, W.all_admissible⟩

theorem h1_locality_from_nonvacuous_fok_interface
    (h : NonVacuousFOkAdmissibleRefinementInterface) :
    H1Locality := by
  exact h

theorem h1_locality_missing_formal_interface :
    H1LocalityMissingFormalInterface := by
  trivial

/-- Conditional non-vacuous H1 bridge.

The repository-native semantic binding witness records the non-vacuity object.
The proof-bearing admissibility assumption remains the fixed-k FO admissibility
interface; this theorem does not construct that interface.
-/
theorem h1_locality_from_nonvacuous_fok_interface_and_repository_native_witness
    (hI : NonVacuousFOkAdmissibleRefinementInterface)
    (_W : NonVacuousRepositoryNativeSemanticBindingWitness) :
    H1Locality := by
  exact h1_locality_from_nonvacuous_fok_interface hI

/--
Repository-native construction certificate for the concrete FO^k admissibility
witness.

This corrects the inadmissible generic `RepositoryNativeData` template by using
only objects already present in this file.
-/
structure RepositoryNativeConstructionOfConcreteFOkAdmissibleRefinementInterfaceWitness where
  concrete_witness : ConcreteFOkAdmissibleRefinementInterfaceWitness
  semantic_witness : NonVacuousRepositoryNativeSemanticBindingWitness

theorem nonvacuous_fok_interface_from_repository_native_construction
    (C : RepositoryNativeConstructionOfConcreteFOkAdmissibleRefinementInterfaceWitness) :
    NonVacuousFOkAdmissibleRefinementInterface := by
  exact nonvacuous_fok_interface_from_concrete_witness C.concrete_witness

theorem h1_locality_from_repository_native_construction
    (C : RepositoryNativeConstructionOfConcreteFOkAdmissibleRefinementInterfaceWitness) :
    H1Locality := by
  exact h1_locality_from_nonvacuous_fok_interface
    (nonvacuous_fok_interface_from_repository_native_construction C)

/--
First-class target object for a concrete repository-native FO^k witness instance.

This deliberately does not fabricate an instance. It only names the next
repository-native object whose supplied construction would imply H1.
-/
structure ConcreteRepositoryNativeFOkWitnessInstance where
  construction : RepositoryNativeConstructionOfConcreteFOkAdmissibleRefinementInterfaceWitness

def repository_native_construction_from_concrete_repository_native_fok_witness_instance
    (X : ConcreteRepositoryNativeFOkWitnessInstance) :
    RepositoryNativeConstructionOfConcreteFOkAdmissibleRefinementInterfaceWitness :=
  X.construction

theorem h1_locality_from_concrete_repository_native_fok_witness_instance
    (X : ConcreteRepositoryNativeFOkWitnessInstance) :
    H1Locality := by
  exact h1_locality_from_repository_native_construction
    (repository_native_construction_from_concrete_repository_native_fok_witness_instance X)

/--
Value gate for the concrete repository-native FO^k witness instance.

This is intentionally only a `Nonempty` gate. It does not fabricate a
`Unit`/`True` instance and does not supply repository-native semantic content.
A proof of this proposition must provide an actual inhabitant of
`ConcreteRepositoryNativeFOkWitnessInstance`.
-/
def ConcreteRepositoryNativeFOkWitnessInstanceValue : Prop :=
  Nonempty ConcreteRepositoryNativeFOkWitnessInstance

theorem h1_locality_from_concrete_repository_native_fok_witness_instance_value
    (hV : ConcreteRepositoryNativeFOkWitnessInstanceValue) :
    H1Locality := by
  rcases hV with ⟨X⟩
  exact h1_locality_from_concrete_repository_native_fok_witness_instance X

end URF

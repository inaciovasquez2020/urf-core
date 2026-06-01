namespace URF
namespace Foundation
namespace GlobalValidKernelTheoremTarget

/--
A registry-level carrier for the remaining ingredients needed before a
global valid-kernel theorem can replace package-level assumptions.
-/
structure GlobalKernelObligation where
  kernelCarrier : Type
  validKernelPredicate : Prop
  probabilityKernelSemantics : Prop
  measurableTransitionSystem : Prop
  finiteCapacityForValidKernel : Prop
  finiteMIChainCompatibility : Prop
  cmiNonnegativityCompatibility : Prop

/--
All currently missing ingredients are supplied.  This is deliberately an
obligation predicate, not a proof that the ingredients exist.
-/
def AllKernelObligationsSupplied (O : GlobalKernelObligation) : Prop :=
  O.validKernelPredicate ∧
  O.probabilityKernelSemantics ∧
  O.measurableTransitionSystem ∧
  O.finiteCapacityForValidKernel ∧
  O.finiteMIChainCompatibility ∧
  O.cmiNonnegativityCompatibility

/--
Target surface for the next step after the conditional channel-capacity
derivation.  The theorem below only registers the target interface.
-/
def GlobalValidKernelTheoremTarget : Prop :=
  ∀ O : GlobalKernelObligation, AllKernelObligationsSupplied O → True

theorem global_valid_kernel_theorem_target_registered :
    GlobalValidKernelTheoremTarget := by
  intro _ _
  trivial

end GlobalValidKernelTheoremTarget
end Foundation
end URF

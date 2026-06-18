import URF.Foundation.GlobalValidKernelTheorem
import URF.Foundation.ChannelCapacityBoundDerivation

namespace URF.Foundation

/--
A restricted valid-kernel Law 3 instance package.

This structure records the exact remaining bindings as hypotheses:
a restricted domain, a valid-kernel binding, finite local CMI nonnegativity,
finite chain-rule binding, capacity-bound binding, and the restricted Law 3
consequence statement.
-/
structure RestrictedValidKernelLaw3Input where
  Domain : Type
  validKernelAssumptionBinding : Domain → Prop
  finiteLocalCMINonnegativityBinding : Domain → Prop
  finiteChainRuleBinding : Domain → Prop
  capacityBoundBinding : Domain → Prop
  restrictedLaw3ConsequenceStatement : Domain → Prop
  law3ConsequenceFromBindings :
    ∀ x : Domain,
      validKernelAssumptionBinding x →
      finiteLocalCMINonnegativityBinding x →
      finiteChainRuleBinding x →
      capacityBoundBinding x →
      restrictedLaw3ConsequenceStatement x

/--
Lean-checked restricted valid-kernel Law 3 instance.

This closes only the restricted conditional instance once the six bindings in
`RestrictedValidKernelLaw3Input` are supplied. It does not prove any unrestricted
global URF Law 3 theorem.
-/
theorem lean_checked_restricted_valid_kernel_law3_instance
    (I : RestrictedValidKernelLaw3Input)
    (x : I.Domain)
    (hVK : I.validKernelAssumptionBinding x)
    (hCMI : I.finiteLocalCMINonnegativityBinding x)
    (hChain : I.finiteChainRuleBinding x)
    (hCap : I.capacityBoundBinding x) :
    I.restrictedLaw3ConsequenceStatement x :=
  I.law3ConsequenceFromBindings x hVK hCMI hChain hCap

end URF.Foundation

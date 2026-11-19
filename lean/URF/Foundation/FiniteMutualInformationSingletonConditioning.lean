import Mathlib
import URF.Foundation.JointFiniteConditionalMutualInformation

namespace URF.Foundation

noncomputable def singletonConditioningJoint
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    JointFiniteDistributionData α β PUnit.{u+1} where
  joint := fun p => P.joint (p.1, p.2.1)
  nonneg := by
    intro p
    exact P.nonneg (p.1, p.2.1)
  sum_one := by
    simpa [Fintype.sum_prod_type] using P.sum_one

theorem jointConditionalMI_singletonConditioning
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    jointConditionalMI (singletonConditioningJoint P) =
      finiteMutualInformation P := by
  unfold jointConditionalMI
  classical
  simp [singletonConditioningJoint, jointWeight, jointConditional,
    finiteMutualInformation]

end URF.Foundation

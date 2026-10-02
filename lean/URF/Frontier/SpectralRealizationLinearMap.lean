import URF.Frontier.SpectralContinuousRealizationInterface

namespace URF
namespace Frontier

/--
The existing additive and real-scalar realization obligations determine a
real-linear map between the normed realization spaces. This construction does
not assert existence of an interface instance.
-/
def SpectralContinuousRealizationInterface.realizationLinearMap
    (I : SpectralContinuousRealizationInterface) :
    I.target.space →ₗ[ℝ] I.realization :=
  { toFun := I.toRealization
    map_add' := I.realization_additive
    map_smul' := I.realization_smul }

theorem SpectralContinuousRealizationInterface.realizationLinearMap_apply
    (I : SpectralContinuousRealizationInterface) (v : I.target.space) :
    I.realizationLinearMap v = I.toRealization v := rfl

end Frontier
end URF

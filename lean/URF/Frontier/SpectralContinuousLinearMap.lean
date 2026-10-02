import URF.Frontier.SpectralRealizationLinearMap

namespace URF
namespace Frontier

/--
The existing bounded real-linear realization map is promoted to a genuine
continuous linear map using its explicit norm bound. This construction does not
assert existence of an interface instance or an analytic spectral realization.
-/
def SpectralContinuousRealizationInterface.realizationContinuousLinearMap
    (I : SpectralContinuousRealizationInterface) :
    I.target.space →L[ℝ] I.realization :=
  LinearMap.mkContinuousOfExistsBound
    I.realizationLinearMap
    (by
      rcases I.bounded_realization with ⟨C, hC, hbound⟩
      exact ⟨C, by
        intro v
        exact hbound v⟩)

theorem SpectralContinuousRealizationInterface.realizationContinuousLinearMap_apply
    (I : SpectralContinuousRealizationInterface) (v : I.target.space) :
    I.realizationContinuousLinearMap v = I.toRealization v := rfl

end Frontier
end URF

import URF.Frontier.SpectralRealScalarRealizationInterface

namespace URF
namespace Frontier

/--
Continuity obligation extending the real-scalar spectral realization
interface with explicit continuity of the realization map.
It does not assert that such a realization exists.
-/
structure SpectralContinuousRealizationInterface
    extends SpectralRealScalarRealizationInterface where
  realization_continuous :
    Continuous toRealization

end Frontier
end URF

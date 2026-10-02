import URF.Frontier.SpectralAdditiveRealizationInterface

namespace URF
namespace Frontier

/--
Zero-preserving realization interface extending the additive spectral
realization obligations with an explicit preservation condition at zero.
It does not assert that such a realization exists.
-/
structure SpectralZeroPreservingRealizationInterface
    extends SpectralAdditiveRealizationInterface where
  realization_zero :
    toRealization 0 = 0

end Frontier
end URF

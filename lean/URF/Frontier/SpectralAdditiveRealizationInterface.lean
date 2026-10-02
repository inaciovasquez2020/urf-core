import URF.Frontier.SpectralNormedRealizationInterface

namespace URF
namespace Frontier

/--
Additive realization interface extending the normed spectral realization
obligations with an explicit additivity condition for the realization map.
It does not assert that such a realization exists.
-/
structure SpectralAdditiveRealizationInterface
    extends SpectralNormedRealizationInterface where
  realization_additive :
    ∀ v w : target.space,
      toRealization (v + w) =
        toRealization v + toRealization w

end Frontier
end URF

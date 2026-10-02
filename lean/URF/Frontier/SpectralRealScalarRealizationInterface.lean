import URF.Frontier.SpectralZeroPreservingRealizationInterface

namespace URF
namespace Frontier

/--
Real-scalar realization interface extending the zero-preserving spectral
realization obligations with an explicit compatibility condition for real
scalar multiplication. It does not assert that such a realization exists.
-/
structure SpectralRealScalarRealizationInterface
    extends SpectralZeroPreservingRealizationInterface where
  targetNormedSpace : NormedSpace ℝ target.space
  realizationNormedSpace : NormedSpace ℝ realization
  realization_smul :
    ∀ (a : ℝ) (v : target.space),
      toRealization (a • v) =
        a • toRealization v

end Frontier
end URF

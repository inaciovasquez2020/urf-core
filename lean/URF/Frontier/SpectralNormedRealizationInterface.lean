import URF.Frontier.SpectralRealizationInterface

namespace URF
namespace Frontier

/--
Normed realization interface extending the existing spectral realization
obligations with explicit normed additive-group structures and a boundedness
obligation for the realization map. It does not assert that such a realization
exists.
-/
structure SpectralNormedRealizationInterface extends SpectralRealizationInterface where
  targetNormedAddCommGroup : NormedAddCommGroup target.space
  realizationNormedAddCommGroup : NormedAddCommGroup realization
  bounded_realization :
    ∃ C : ℝ,
      0 ≤ C ∧
        ∀ v : target.space,
          ‖toRealization v‖ ≤ C * ‖v‖

end Frontier
end URF

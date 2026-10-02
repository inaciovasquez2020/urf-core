import URF.Frontier.SpectralCoercivityTarget

namespace URF
namespace Frontier

/--
Minimal realization interface for a spectral target. This records a map from
the abstract spectral target into a concrete realization without asserting
that such a realization exists.
-/
structure SpectralRealizationInterface where
  target : SpectralCoercivityTarget
  realization : Type*
  toRealization : target.space → realization
  domain_preservation :
    ∀ v : target.space,
      target.domain v →
      True
  admissibility_preservation :
    ∀ v : target.space,
      target.admissible v →
      True

end Frontier
end URF

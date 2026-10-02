import URF.Frontier.SpectralCoercivityTarget

namespace URF
namespace Frontier

/--
Minimal realization interface for a spectral target. This records a concrete
realization map together with the operator intertwining condition; it does
not assert that such a realization exists.
-/
structure SpectralRealizationInterface where
  target : SpectralCoercivityTarget
  realization : Type*
  toRealization : target.space → realization
  realizedOperator : realization → realization
  operator_intertwining :
    ∀ v : target.space,
      toRealization (target.operator v) =
        realizedOperator (toRealization v)

end Frontier
end URF

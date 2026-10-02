import URF.Frontier.SpectralCoercivityTarget

namespace URF
namespace Frontier

/--
Minimal realization interface for a spectral target. This records a concrete
realization map together with the operator intertwining condition and a
distinguished-subspace alignment obligation; it does not assert that such a
realization exists.
-/
structure SpectralRealizationInterface where
  target : SpectralCoercivityTarget
  realization : Type*
  toRealization : target.space → realization
  realizedOperator : realization → realization
  distinguished : target.space → Prop
  realizedDistinguished : realization → Prop
  operator_intertwining :
    ∀ v : target.space,
      toRealization (target.operator v) =
        realizedOperator (toRealization v)
  distinguished_alignment :
    ∀ v : target.space,
      distinguished v ↔ realizedDistinguished (toRealization v)

end Frontier
end URF

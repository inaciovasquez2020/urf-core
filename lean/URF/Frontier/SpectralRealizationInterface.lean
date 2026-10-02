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
  realizedInner : realization → realization → ℝ
  fromRealization : realization → target.space
  distinguished : target.space → Prop
  realizedDistinguished : realization → Prop
  operator_intertwining :
    ∀ v : target.space,
      toRealization (target.operator v) =
        realizedOperator (toRealization v)
  distinguished_alignment :
    ∀ v : target.space,
      distinguished v ↔ realizedDistinguished (toRealization v)
  inner_preservation :
    ∀ v w : target.space,
      target.inner v w =
        realizedInner (toRealization v) (toRealization w)
  left_inverse :
    ∀ v : target.space,
      fromRealization (toRealization v) = v
  right_inverse :
    ∀ w : realization,
      toRealization (fromRealization w) = w

end Frontier
end URF

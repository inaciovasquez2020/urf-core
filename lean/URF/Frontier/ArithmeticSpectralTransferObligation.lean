import URF.Frontier.ArithmeticSpectralCoercivityTarget
import URF.Frontier.SpectralCoercivityTarget

namespace URF
namespace Frontier

/--
Minimal transfer obligation connecting the repository-defined arithmetic family
to an independently defined spectral target.

The correspondence is recorded explicitly through a map on admissible
arithmetic vectors together with preservation of norm-square and energy.
No existence theorem for the correspondence is asserted here.
-/
structure ArithmeticSpectralTransferObligation where
  arithmetic : ArithmeticSpectralFamily (Fin 3)
  spectral : SpectralCoercivityTarget
  toSpectral : ∀ (q : Fin 3), arithmetic.space q → spectral.space
  normSq_transfer :
    ∀ (q : Fin 3) (v : arithmetic.space q),
      arithmetic.normSq q v =
        spectral.normSq (toSpectral q v)
  energy_transfer :
    ∀ (q : Fin 3) (v : arithmetic.space q),
      arithmetic.inner q (arithmetic.operator q v) v =
        spectral.inner
          (spectral.operator (toSpectral q v))
          (toSpectral q v)
  domain_transfer :
    ∀ (q : Fin 3) (v : arithmetic.space q),
      arithmetic.domain q v →
      spectral.domain (toSpectral q v)
  admissible_transfer :
    ∀ (q : Fin 3) (v : arithmetic.space q),
      arithmetic.admissible q v →
      spectral.admissible (toSpectral q v)

end Frontier
end URF

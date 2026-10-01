import Mathlib

namespace URF
namespace Frontier

/--
Minimal independent spectral target interface for the arithmetic-to-spectral
coercivity bridge. This introduces spectral-side data without asserting any
transfer from the arithmetic family.
-/
structure SpectralCoercivityTarget where
  space : Type*
  inner : space → space → ℝ
  normSq : space → ℝ
  normSq_eq_inner_self : ∀ v : space, normSq v = inner v v
  operator : space → space
  domain : space → Prop
  admissible : space → Prop

end Frontier
end URF

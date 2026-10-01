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

/--
Spectral coercivity obligation for an independently defined spectral target.
This records the inequality that an arithmetic-to-spectral transfer must
eventually establish; it does not assert that the obligation is proved.
-/
def SpectralCoercive
    (target : SpectralCoercivityTarget)
    (c : ℝ) : Prop :=
  0 < c ∧
    ∀ (v : target.space),
      target.domain v →
      target.admissible v →
      c * target.normSq v ≤ target.inner (target.operator v) v

/--
Certificate object for a spectral coercivity bound. This records a proved
spectral-side coercivity witness without identifying it with the arithmetic
family or asserting the missing arithmetic-to-spectral transfer.
-/
structure SpectralGapCertificate where
  target : SpectralCoercivityTarget
  gap : ℝ
  coercivity : SpectralCoercive target gap

end Frontier
end URF

import Mathlib.MeasureTheory.VectorMeasure.Decomposition.Jordan
import Mathlib.MeasureTheory.VectorMeasure.Decomposition.Hahn
import Mathlib.MeasureTheory.Integral.Bochner.Basic

open MeasureTheory

noncomputable section

namespace URF

variable {α : Type*} [MeasurableSpace α]

/--
Repository interface lemma.

This is the exact dual inequality needed by TV duality:

|∫ f d s| ≤ ∫ |f| d (s.totalVariation)

It is isolated so that:
1 The rest of the repository can depend on a single statement
2 The implementation can later be replaced by a full Jordan proof
3 Mathlib version drift is localized here
-/
axiom SignedMeasure_dual_norm_bound
  (s : SignedMeasure α)
  (f : α → ℝ)
  (hf : Integrable f s.totalVariation) :
  |∫ x, f x ∂s.toMeasure| ≤ ∫ x, |f x| ∂(s.totalVariation)

end URF

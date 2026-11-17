import Mathlib

/-!
URF PR #592: abstract cycle-observation duality kernel and dimension.
PIN: leanprover/lean4:v4.27.0, mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900.
STATUS: NOT_RUN; SOURCE CANDIDATE ONLY.
The graph quotient/cycle perfect pairing is NOT constructed in this file.
Any claim of full graph-specific Lean verification is therefore OPEN.
-/

noncomputable section

namespace URF.Transfer.CycleDual

open Module

universe u v
variable {K : Type u} [Field K]
variable {Global Local : Type v}
variable [AddCommGroup Global] [Module K Global]
variable [AddCommGroup Local] [Module K Local]

/-- The dual of local-cycle inclusion evaluates a global functional on the
    included local cycle. This is the restriction/transpose compatibility. -/
theorem restriction_dual_apply
    (includeCycles : Local →ₗ[K] Global)
    (φ : Module.Dual K Global) (z : Local) :
    includeCycles.dualMap φ z = φ (includeCycles z) := rfl

/-- A functional is invisible under the dual restriction exactly when it
    vanishes on every locally included cycle. -/
theorem hidden_iff_annihilates_local_cycles
    (includeCycles : Local →ₗ[K] Global)
    (φ : Module.Dual K Global) :
    φ ∈ LinearMap.ker includeCycles.dualMap ↔
      ∀ z : Local, φ (includeCycles z) = 0 := by
  constructor
  · intro h z
    have hz := congrArg (fun ψ : Module.Dual K Local => ψ z)
      (LinearMap.mem_ker.mp h)
    simpa [restriction_dual_apply] using hz
  · intro h
    apply LinearMap.mem_ker.mpr
    ext z
    exact h z

/-- Rank-nullity for a local-cycle inclusion and its dual observation.
    The rank is the dimension of the span of the included local cycles. -/
theorem observed_add_hidden_eq_global_dual
    [FiniteDimensional K Global] [FiniteDimensional K Local]
    (includeCycles : Local →ₗ[K] Global) :
    Module.finrank K (LinearMap.range includeCycles) +
      Module.finrank K (LinearMap.ker includeCycles.dualMap) =
        Module.finrank K (Module.Dual K Global) := by
  have h := LinearMap.finrank_range_add_finrank_ker includeCycles.dualMap
  rw [LinearMap.finrank_range_dualMap_eq_finrank_range] at h
  exact h

end URF.Transfer.CycleDual

#print axioms URF.Transfer.CycleDual.restriction_dual_apply
#print axioms URF.Transfer.CycleDual.hidden_iff_annihilates_local_cycles
#print axioms URF.Transfer.CycleDual.observed_add_hidden_eq_global_dual

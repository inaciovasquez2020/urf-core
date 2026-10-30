import Mathlib

/-!
# Discrete scale-path lower bound: scalar core

This module formalizes the scalar implication after the finite-sum
counting and Cauchy--Schwarz estimates have been established.

The aggregate hypothesis is the analytic/discrete input:
  δ * sqrt(K*L) ≤ L*A + 2*sqrt(K)*B.
Here A is total path variation and B is the ℓ² tracking error.
This theorem does not prove that a particular path satisfies that
hypothesis, nor does it formalize the paper's lacunary Fourier estimates.
-/

namespace URF
namespace Analysis

/--
Scalar scale-path estimate. If the aggregate block lower bound is
available, then total variation plus ℓ² tracking error is bounded below.
-/
theorem scalePath_lower_bound
    {K L δ A B : ℝ}
    (hK : 0 < K)
    (hL : 0 < L)
    (hδ : 0 ≤ δ)
    (hA : 0 ≤ A)
    (hB : 0 ≤ B)
    (haggregate :
      δ * Real.sqrt (K * L) ≤ L * A + 2 * Real.sqrt K * B) :
    δ * Real.sqrt (K * L) / (L + 2 * Real.sqrt K) ≤ A + B := by
  have hsK : 0 ≤ Real.sqrt K := Real.sqrt_nonneg K
  have hden : 0 < L + 2 * Real.sqrt K := by positivity
  have hcross₁ : 0 ≤ L * B := mul_nonneg (le_of_lt hL) hB
  have hcross₂ : 0 ≤ 2 * Real.sqrt K * A := by positivity
  have hfactor :
      L * A + 2 * Real.sqrt K * B ≤
        (L + 2 * Real.sqrt K) * (A + B) := by
    nlinarith
  rw [div_le_iff₀ hden]
  exact le_trans haggregate hfactor

end Analysis
end URF

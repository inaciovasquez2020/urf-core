Schur dual stability normal B plus small perturbation

Let B be normal on C^n. Let E satisfy norm E ≤ η and define Bprime = B + E.

Define the dual feasible set

F(B) = { λ : || B^T λ ||_∞ ≤ w }

Assume B^T is injective on the active subspace and admits a bounded right inverse R with ||R|| ≤ γ.

Then the Hausdorff distance satisfies

d_H(F(B), F(Bprime)) ≤ w γ^2 η + O(η^2)

Derivation sketch

|| Bprime^T λ ||_∞ ≤ || B^T λ ||_∞ + ||E^T|| ||λ||

and

||λ|| ≤ γ || B^T λ ||

For normal B one can take

γ = 1 / σ_min(B^T)

on the active subspace.

For the strongly concave quadratic dual objective

Φ(λ) = − b^T λ − (1 / (2ρ)) ||λ||^2

the optimizer map obeys

|| λ_star(B) − λ_star(Bprime) || ≤ ρ d_H(F(B), F(Bprime))
≤ ρ w γ^2 η + O(η^2)


Translation invariant Gaussian Wasserstein equality for all p ≥ 1

Let

μ = N(m0, Σ)
ν = N(m1, Σ)

Then for every p ≥ 1

W_p(μ, ν) = || m0 − m1 ||

because the coupling

X ~ μ
Y = X + (m1 − m0)

achieves cost ||m1 − m0||^p and is optimal by translation invariance.

For linear risk

ρ(μ) = ∫ ⟨a, x⟩ dμ = ⟨a, m⟩

we obtain

| ρ(μ) − ρ(ν) |
= | ⟨a, m0 − m1⟩ |
≤ ||a|| W_p(μ, ν)

Equality holds if and only if a is parallel to (m0 − m1).


One dimensional covariance changing Gaussian optimal transport equality

Let

μ = N(0, σ0^2)
ν = N(0, σ1^2)

Then

W_2(μ, ν) = | σ0 − σ1 |

Quadratic risk

ρ(μ) = ∫ x^2 dμ = σ0^2
ρ(ν) = σ1^2

Therefore

| ρ(μ) − ρ(ν) |
= | σ0^2 − σ1^2 |
= (σ0 + σ1) | σ0 − σ1 |
= (σ0 + σ1) W_2(μ, ν)

Hence the sharp Lipschitz constant for this pair is

L = σ0 + σ1

and equality is attained.

# Prefab Pipeline API

The PrefabPipeline composes multiple prefab modules.

Definition

Pipeline P = (P₁, P₂, …, Pₙ)

Execution

x₀ = input  
xᵢ = Pᵢ.normalize(xᵢ₋₁)

Correctness condition

Each prefab must satisfy

verify(xᵢ₋₁) = True

before normalization is applied.

Properties

- deterministic
- composable
- verification-safe

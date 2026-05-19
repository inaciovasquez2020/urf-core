import URF.Foundation.SharedRigidityCodeBijection

variable {A B Γ : Type*}

/-- The shared rigidity code bijection is unique among equivalences preserving the code. -/
theorem SharedRigidityCodeBijection_unique
    (α : A → Γ) (β : B → Γ)
    (hβ : Function.Injective β)
    (e₁ e₂ : A ≃ B)
    (h₁ : ∀ a : A, β (e₁ a) = α a)
    (h₂ : ∀ a : A, β (e₂ a) = α a) :
    e₁ = e₂ := by
  apply Equiv.ext
  intro a
  apply hβ
  calc
    β (e₁ a) = α a := h₁ a
    _ = β (e₂ a) := (h₂ a).symm

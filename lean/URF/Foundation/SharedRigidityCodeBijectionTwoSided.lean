import URF.Foundation.SharedRigidityCodeBijection

variable {A B Γ : Type*}

/-- Forward code preservation implies inverse code preservation. -/
theorem SharedRigidityCodeBijection_inverse_code
    (α : A → Γ) (β : B → Γ)
    (e : A ≃ B)
    (h : ∀ a : A, β (e a) = α a) :
    ∀ b : B, α (e.symm b) = β b := by
  intro b
  rw [← h (e.symm b), e.apply_symm_apply]

/-- The shared rigidity code bijection may be chosen with both forward and inverse code preservation. -/
theorem SharedRigidityCodeBijection_two_sided
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β)
    (h_range : Set.range α = Set.range β) :
    ∃ e : A ≃ B,
      (∀ a : A, β (e a) = α a) ∧
      (∀ b : B, α (e.symm b) = β b) := by
  obtain ⟨e, he⟩ := SharedRigidityCodeBijection α β hα hβ h_range
  refine ⟨e, he, ?_⟩
  exact SharedRigidityCodeBijection_inverse_code α β e he

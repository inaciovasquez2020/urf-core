import URF.Foundation.SharedRigidityCodeBijectionTwoSided

variable {A B Γ : Type*}

/-- Existence of a code-preserving equivalence forces equality of encoder ranges. -/
theorem SharedRigidityCodeBijection_range_eq_of_exists
    (α : A → Γ) (β : B → Γ)
    (h : ∃ e : A ≃ B, ∀ a : A, β (e a) = α a) :
    Set.range α = Set.range β := by
  obtain ⟨e, he⟩ := h
  ext x
  constructor
  · intro hx
    rcases hx with ⟨a, rfl⟩
    exact ⟨e a, he a⟩
  · intro hx
    rcases hx with ⟨b, rfl⟩
    exact ⟨e.symm b, SharedRigidityCodeBijection_inverse_code α β e he b⟩

/-- Equal ranges exactly characterize existence of a shared rigidity code bijection. -/
theorem SharedRigidityCodeBijection_exists_iff_range_eq
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β) :
    (∃ e : A ≃ B, ∀ a : A, β (e a) = α a) ↔
      Set.range α = Set.range β := by
  constructor
  · intro h
    exact SharedRigidityCodeBijection_range_eq_of_exists α β h
  · intro h_range
    exact SharedRigidityCodeBijection α β hα hβ h_range

import URF.Foundation.SharedRigidityCodeBijectionRangeIff

variable {A B C Γ : Type*}

/-- Code-preserving shared rigidity bijections compose. -/
theorem SharedRigidityCodeBijection_trans
    (α : A → Γ) (β : B → Γ) (χ : C → Γ)
    (eAB : A ≃ B) (eBC : B ≃ C)
    (hAB : ∀ a : A, β (eAB a) = α a)
    (hBC : ∀ b : B, χ (eBC b) = β b) :
    ∀ a : A, χ ((eAB.trans eBC) a) = α a := by
  intro a
  calc
    χ ((eAB.trans eBC) a) = χ (eBC (eAB a)) := rfl
    _ = β (eAB a) := hBC (eAB a)
    _ = α a := hAB a

/-- Existence of shared rigidity code bijections is transitive. -/
theorem SharedRigidityCodeBijection_exists_trans
    (α : A → Γ) (β : B → Γ) (χ : C → Γ)
    (hAB : ∃ eAB : A ≃ B, ∀ a : A, β (eAB a) = α a)
    (hBC : ∃ eBC : B ≃ C, ∀ b : B, χ (eBC b) = β b) :
    ∃ eAC : A ≃ C, ∀ a : A, χ (eAC a) = α a := by
  obtain ⟨eAB, hAB_code⟩ := hAB
  obtain ⟨eBC, hBC_code⟩ := hBC
  exact ⟨eAB.trans eBC,
    SharedRigidityCodeBijection_trans α β χ eAB eBC hAB_code hBC_code⟩

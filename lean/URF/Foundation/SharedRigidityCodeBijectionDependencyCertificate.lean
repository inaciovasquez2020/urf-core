import URF.Foundation.SharedRigidityCodeBijection

namespace URF
namespace Foundation

/-- Dependency certificate wrapper for `SharedRigidityCodeBijection`.

The statement keeps only the local structural inputs of the original theorem:
injectivity of both codes and equality of their ranges. -/
theorem sharedRigidityCodeBijection_dependency_certificate
    {A B Γ : Type*}
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β)
    (h_range : Set.range α = Set.range β) :
    ∃ e : A ≃ B, ∀ a : A, β (e a) = α a :=
  _root_.SharedRigidityCodeBijection α β hα hβ h_range

end Foundation
end URF

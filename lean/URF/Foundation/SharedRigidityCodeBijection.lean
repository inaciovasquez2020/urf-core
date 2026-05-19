import Mathlib.Data.Set.Basic
import Mathlib.Logic.Equiv.Basic

variable {A B Γ : Type*}

noncomputable theorem SharedRigidityCodeBijection
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β)
    (h_range : Set.range α = Set.range β) :
    ∃ e : A ≃ B, ∀ a : A, β (e a) = α a := by
  classical
  let f : A → B := fun a =>
    Classical.choose ((Set.mem_range.mp ((by
      rw [← h_range]
      exact Set.mem_range_self a) : α a ∈ Set.range β)))
  let g : B → A := fun b =>
    Classical.choose ((Set.mem_range.mp ((by
      rw [h_range]
      exact Set.mem_range_self b) : β b ∈ Set.range α)))
  have hf : ∀ a : A, β (f a) = α a := by
    intro a
    exact Classical.choose_spec ((Set.mem_range.mp ((by
      rw [← h_range]
      exact Set.mem_range_self a) : α a ∈ Set.range β)))
  have hg : ∀ b : B, α (g b) = β b := by
    intro b
    exact Classical.choose_spec ((Set.mem_range.mp ((by
      rw [h_range]
      exact Set.mem_range_self b) : β b ∈ Set.range α)))
  refine ⟨
    { toFun := f
      invFun := g
      left_inv := ?_
      right_inv := ?_ }, hf⟩
  · intro a
    apply hα
    calc
      α (g (f a)) = β (f a) := hg (f a)
      _ = α a := hf a
  · intro b
    apply hβ
    calc
      β (f (g b)) = α (g b) := hf (g b)
      _ = β b := hg b

noncomputable theorem SharedRigidityCodeBijection_predicate
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β)
    (h_range : Set.range α = Set.range β)
    (P : Γ → Prop) :
    ∃ e : A ≃ B,
      (∀ a : A, β (e a) = α a) ∧
      (∀ a : A, P (α a) ↔ P (β (e a))) := by
  classical
  obtain ⟨e, he⟩ := SharedRigidityCodeBijection α β hα hβ h_range
  refine ⟨e, he, ?_⟩
  intro a
  rw [he a]

noncomputable theorem SharedRigidityCodeBijection_relation
    (α : A → Γ) (β : B → Γ)
    (hα : Function.Injective α)
    (hβ : Function.Injective β)
    (h_range : Set.range α = Set.range β)
    (R : Γ → Γ → Prop) :
    ∃ e : A ≃ B,
      (∀ a : A, β (e a) = α a) ∧
      (∀ a₁ a₂ : A,
        R (α a₁) (α a₂) ↔ R (β (e a₁)) (β (e a₂))) := by
  classical
  obtain ⟨e, he⟩ := SharedRigidityCodeBijection α β hα hβ h_range
  refine ⟨e, he, ?_⟩
  intro a₁ a₂
  rw [he a₁, he a₂]

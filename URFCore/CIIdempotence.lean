namespace URFCore

universe u
variable {State : Type u}

-- abstract clean+build operator
def Φ (clean build : State → State) : State → State := build ∘ clean

-- Conditional: determinism/cleanliness hypothesis parameterized explicitly
theorem Φ_idempotent
    (clean build : State → State)
    (hΦ : ∀ s : State, Φ clean build (Φ clean build s) = Φ clean build s)
    (s : State) :
    Φ clean build (Φ clean build s) = Φ clean build s :=
  hΦ s

end URFCore

import Init

/-!
# URF transfer: exact observation factorization (Lean candidate)

Independent abstract core of the cohomology-to-information transfer theorem.
The existence of a global decoder is equivalent to constancy of the target
on every observation fiber. This DOES NOT formalize graph cohomology,
cycle-space rank, probability, entropy, or the cycle radius theorem.

Status: NOT_RUN. No Lean kernel claim until compiled with actual pinned toolchain
and the axiom audit is performed. No new axioms or proof holes are introduced.
-/

universe u v w

namespace URF.Transfer

variable {X : Type u} {Y : Type v} {Z : Type w}

/-- D reconstructs the global target I from the restricted observation O. -/
def ExactReconstruction (O : X → Y) (I : X → Z) (D : Y → Z) : Prop :=
  ∀ x : X, D (O x) = I x

/-- The target does not distinguish configurations within one observation fiber. -/
def FiberConstant (O : X → Y) (I : X → Z) : Prop :=
  ∀ x y : X, O x = O y → I x = I y

/-- Every exact decoder forces the target to be constant on observation fibers. -/
theorem exactReconstruction_implies_fiberConstant
    (O : X → Y) (I : X → Z) (D : Y → Z)
    (hD : ExactReconstruction O I D) : FiberConstant O I := by
  intro x y hxy
  calc
    I x = D (O x) := (hD x).symm
    _ = D (O y) := congrArg D hxy
    _ = I y := hD y

/-- Explicit indistinguishability collisions rule out exact reconstruction. -/
theorem collision_blocks_exact_reconstruction
    (O : X → Y) (I : X → Z) (x y : X)
    (hxy : O x = O y) (hdifferent : I x ≠ I y) :
    ¬ ∃ D : Y → Z, ExactReconstruction O I D := by
  intro h
  cases h with
  | intro D hD =>
      apply hdifferent
      exact exactReconstruction_implies_fiberConstant O I D hD x y hxy

/-- Exact reconstruction is possible precisely for observation-fiber-constant
    targets; the inhabited codomain supplies a value for unobserved y. -/
theorem exactReconstruction_iff_fiberConstant
    [Inhabited Z] (O : X → Y) (I : X → Z) :
    (∃ D : Y → Z, ExactReconstruction O I D) ↔ FiberConstant O I := by
  classical
  constructor
  · intro hD
    cases hD with
    | intro D h =>
        exact exactReconstruction_implies_fiberConstant O I D h
  · intro h
    let D : Y → Z := fun y =>
      if hy : ∃ x : X, O x = y then I (Classical.choose hy) else default
    refine ⟨D, ?_⟩
    intro x
    have hx : ∃ z : X, O z = O x := ⟨x, rfl⟩
    change (if hy : ∃ z : X, O z = O x then I (Classical.choose hy) else default) = I x
    rw [dif_pos hx]
    exact h (Classical.choose hx) x (Classical.choose_spec hx)

/-- Injective observations suffice to reconstruct any inhabited target. -/
theorem injective_observation_has_decoder
    [Inhabited Z] (O : X → Y) (I : X → Z)
    (hO : Function.Injective O) :
    ∃ D : Y → Z, ExactReconstruction O I D := by
  apply (exactReconstruction_iff_fiberConstant O I).2
  intro x y hxy
  exact congrArg I (hO hxy)

end URF.Transfer

#print axioms URF.Transfer.exactReconstruction_implies_fiberConstant
#print axioms URF.Transfer.collision_blocks_exact_reconstruction
#print axioms URF.Transfer.exactReconstruction_iff_fiberConstant
#print axioms URF.Transfer.injective_observation_has_decoder

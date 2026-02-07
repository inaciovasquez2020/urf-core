import Mathlib.Data.Fin.Basic
import Mathlib.GroupTheory.Perm.Basic

namespace URF.Lifts

/--
Seeded permutation lift on a finite type α.

This is a pure structure:
no randomness, no IO, no semantics attached yet.
-/
structure PermutationLift (α : Type) [Fintype α] where
  seed : Nat
  perm : Equiv.Perm α

end URF.Lifts


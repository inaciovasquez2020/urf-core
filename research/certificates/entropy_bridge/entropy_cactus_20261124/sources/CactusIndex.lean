import Mathlib.Combinatorics.SimpleGraph.Paths
import Mathlib.Data.Fintype.Powerset
import Mathlib.Data.Finset.Sym

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

variable {V : Type*} [LinearOrder V] [Fintype V]
variable {G : SimpleGraph V}

/-- Simple undirected cycles indexed by their edge sets. -/
def UndirectedCycle (G : SimpleGraph V) :=
  {s : Finset (Sym2 V) // ∃ v : V, ∃ p : G.Walk v v, p.IsCycle ∧ p.edges.toFinset = s}

noncomputable instance : Fintype (UndirectedCycle G) := by
  classical
  unfold UndirectedCycle
  infer_instance

/-- A cactus permits cycles meeting at vertices, with no shared edges. -/
def IsCactus (G : SimpleGraph V) : Prop :=
  ∀ ⦃C D : UndirectedCycle G⦄, C ≠ D → Disjoint C.val D.val

def UndirectedCycle.length (C : UndirectedCycle G) : ℕ := C.val.card

noncomputable def UndirectedCycle.base (C : UndirectedCycle G) : V :=
  Classical.choose C.property

noncomputable def UndirectedCycle.walk (C : UndirectedCycle G) : G.Walk C.base C.base :=
  Classical.choose (Classical.choose_spec C.property)

theorem UndirectedCycle.walk_spec (C : UndirectedCycle G) :
    C.walk.IsCycle ∧ C.walk.edges.toFinset = C.val :=
  Classical.choose_spec (Classical.choose_spec C.property)

#print axioms UndirectedCycle.walk_spec

end URF.EntropyBridge

import CactusLength
import Mathlib.Combinatorics.SimpleGraph.Metric
import Lean.Elab.Tactic.Omega

namespace URF.EntropyBridge

open SimpleGraph

variable {V : Type*} [LinearOrder V] [Fintype V] {G : SimpleGraph V}

/-- Every short simple cycle is contained in the reachable ball around its base. -/
theorem UndirectedCycle.base_ball_of_short (C : UndirectedCycle G) (r : ℕ)
    (hshort : C.length ≤ 2 * r + 1) :
    ∀ v ∈ C.walk.support, G.Reachable C.base v ∧ G.dist C.base v ≤ r := by
  classical
  intro v hv
  let p := C.walk.takeUntil v hv
  let q := C.walk.dropUntil v hv
  have hsum : p.length + q.length = C.length := by
    calc
      _ = (p.append q).length := (Walk.length_append p q).symm
      _ = C.walk.length := congrArg Walk.length (Walk.take_spec C.walk hv)
      _ = C.length := C.walk_length
  have hp := dist_le p
  have hq := dist_le q.reverse
  rw [Walk.length_reverse] at hq
  exact ⟨p.reachable, by omega⟩

#print axioms UndirectedCycle.base_ball_of_short

/-- All cycle edges have both endpoints in one reachable radius ball. -/
def UndirectedCycle.Visible (C : UndirectedCycle G) (r : ℕ) : Prop :=
  ∃ center : V, ∀ ⦃a b : V⦄, s(a, b) ∈ C.val →
    (G.Reachable center a ∧ G.dist center a ≤ r) ∧
    (G.Reachable center b ∧ G.dist center b ≤ r)

theorem UndirectedCycle.visible_of_short (C : UndirectedCycle G) (r : ℕ)
    (hshort : C.length ≤ 2 * r + 1) : C.Visible r := by
  classical
  refine ⟨C.base, ?_⟩
  intro a b hab
  have he : s(a, b) ∈ C.walk.edges :=
    List.mem_toFinset.mp (C.walk_spec.2.symm ▸ hab)
  exact ⟨C.base_ball_of_short r hshort a (C.walk.fst_mem_support_of_mem_edges he),
    C.base_ball_of_short r hshort b (C.walk.snd_mem_support_of_mem_edges he)⟩

#print axioms UndirectedCycle.visible_of_short

end URF.EntropyBridge

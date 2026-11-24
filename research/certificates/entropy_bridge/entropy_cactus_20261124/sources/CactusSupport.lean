import CactusChain

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Forget the canonical orientation of an edge. -/
def orderedEdgeKey (e : OrderedEdge G) : Sym2 V :=
  s(e.val.1, e.val.2)

theorem orderedEdgeKey_eq_iff (e f : OrderedEdge G) :
    orderedEdgeKey e = orderedEdgeKey f ↔ e = f := by
  constructor
  · intro h
    rcases Sym2.eq_iff.mp h with ⟨h₁, h₂⟩ | ⟨h₁, h₂⟩
    · exact Subtype.ext (Prod.ext h₁ h₂)
    · have hf := f.property.1
      rw [← h₂, ← h₁] at hf
      exact (lt_asymm e.property.1 hf).elim
  · rintro rfl
    rfl

#print axioms orderedEdgeKey_eq_iff

theorem orientedStep_ne_zero_iff {u v : V} (h : G.Adj u v) (e : OrderedEdge G) :
    orientedStep (K := K) h e ≠ 0 ↔ orderedEdgeKey e = s(u, v) := by
  classical
  unfold orientedStep
  split_ifs with huv
  · let f : OrderedEdge G := ⟨(u, v), huv, h⟩
    change Pi.single (M := fun _ => K) f 1 e ≠ 0 ↔ orderedEdgeKey e = orderedEdgeKey f
    rw [orderedEdgeKey_eq_iff]
    by_cases he : e = f
    · subst e
      simp
    · simp [Pi.single_eq_of_ne he, he]
  · let f : OrderedEdge G :=
      ⟨(v, u), lt_of_le_of_ne (le_of_not_gt huv) h.ne.symm, h.symm⟩
    simp only [Pi.neg_apply, neg_ne_zero]
    rw [Sym2.eq_swap, ← show orderedEdgeKey f = s(v, u) from rfl, orderedEdgeKey_eq_iff]
    by_cases he : e = f
    · subst e
      dsimp only [f]
      rw [Pi.single_eq_same]
      simp
    · rw [Pi.single_eq_of_ne]
      · simp [he]
      · exact he

#print axioms orientedStep_ne_zero_iff

end URF.EntropyBridge

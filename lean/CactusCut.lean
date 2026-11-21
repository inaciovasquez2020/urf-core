import CactusIndependence

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Summing the boundary over a vertex set counts signed flux through its cut. -/
theorem simpleGraphBoundary_sum_cut (z : OrderedEdge G → K) (s : Finset V) :
    (∑ v ∈ s, simpleGraphBoundary (K := K) G z v) =
      ∑ e : OrderedEdge G,
        ((if e.val.2 ∈ s then 1 else 0) - (if e.val.1 ∈ s then 1 else 0)) * z e := by
  classical
  simp_rw [simpleGraphBoundary, Matrix.mulVecLin_apply, Matrix.mulVec, dotProduct]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro e _
  rw [← Finset.sum_mul]
  have hi (v : V) : simpleGraphIncidence (K := K) G v e =
      (if v = e.val.2 then 1 else 0) - (if v = e.val.1 then 1 else 0) := by
    by_cases h : v = e.val.1
    · subst v
      simp [simpleGraphIncidence, ne_of_lt e.property.1]
    · simp [simpleGraphIncidence, h]
  simp_rw [hi, Finset.sum_sub_distrib]
  simp

#print axioms URF.EntropyBridge.simpleGraphBoundary_sum_cut

end URF.EntropyBridge

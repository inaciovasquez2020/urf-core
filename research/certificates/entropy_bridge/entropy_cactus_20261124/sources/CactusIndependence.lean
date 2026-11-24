import CactusCycleSupport
import CactusLength

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Every cactus cycle has a coordinate exclusive to it in the incidence kernel. -/
theorem cactus_cycleVector_linearIndependent (hcat : IsCactus G) :
    LinearIndependent K (cycleVector (K := K) (G := G)) := by
  classical
  rw [linearIndependent_iff']
  intro s coeff hsum C hC
  have hcard : 0 < C.val.card := by
    change 0 < C.length
    rw [← C.walk_length]
    exact lt_of_lt_of_le (by decide : 0 < 3) C.walk_spec.1.three_le_length
  obtain ⟨k, hk⟩ := Finset.card_pos.mp hcard
  have hkWalk : k ∈ C.walk.edges := List.mem_toFinset.mp (C.walk_spec.2.symm ▸ hk)
  have hOrdered : ∃ e : OrderedEdge G, orderedEdgeKey e = k := by
    have hkEdge := C.walk.edges_subset_edgeSet hkWalk
    revert hkEdge
    refine Sym2.ind (fun a b hab => ?_) k
    change G.Adj a b at hab
    rcases lt_or_gt_of_ne hab.ne with hlt | hgt
    · exact ⟨⟨(a, b), hlt, hab⟩, rfl⟩
    · exact ⟨⟨(b, a), hgt, hab.symm⟩, Sym2.eq_swap⟩
  obtain ⟨e, he⟩ := hOrdered
  have hdiag : cycleChain (K := K) C e ≠ 0 :=
    (cycleChain_ne_zero_iff C e).mpr (he.symm ▸ hk)
  have hEval : (∑ D ∈ s, coeff D * cycleChain (K := K) D e) = 0 := by
    simpa only [Submodule.coe_sum, Submodule.coe_smul, Finset.sum_apply, Pi.smul_apply,
      smul_eq_mul, Submodule.coe_zero, Pi.zero_apply, cycleVector] using
      congrArg (fun z : LinearMap.ker (simpleGraphBoundary (K := K) G) => z.val e) hsum
  have hSingle : (∑ D ∈ s, coeff D * cycleChain (K := K) D e) =
      coeff C * cycleChain (K := K) C e := by
    apply Finset.sum_eq_single C
    · intro D _ hne
      have hz : cycleChain (K := K) D e = 0 := by
        by_contra hn
        exact Finset.disjoint_left.mp (hcat hne)
          ((cycleChain_ne_zero_iff D e).mp hn) (he.symm ▸ hk)
      rw [hz, mul_zero]
    · exact fun hn => (hn hC).elim
  rw [hSingle] at hEval
  exact (mul_eq_zero.mp hEval).resolve_right hdiag

#print axioms URF.EntropyBridge.cactus_cycleVector_linearIndependent

end URF.EntropyBridge

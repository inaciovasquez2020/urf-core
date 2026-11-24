import CactusBasis
import CactusNoShortcut

namespace URF.EntropyBridge

open SimpleGraph
open scoped BigOperators

def reachableRadiusBallCycleGenerators
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) :
    Set (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  { z | ∃ center : V,
      ∀ e : OrderedEdge G, z.val e ≠ 0 →
        (G.Reachable center e.val.1 ∧ G.dist center e.val.1 ≤ r) ∧
        (G.Reachable center e.val.2 ∧ G.dist center e.val.2 ≤ r) }

noncomputable def reachableRadiusBallCycleSpace
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) :
    Subspace K (LinearMap.ker (simpleGraphBoundary (K := K) G)) :=
  Submodule.span K (reachableRadiusBallCycleGenerators (K := K) G r)

noncomputable def reachableRadiusGraphChain
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (r : ℕ) :
    GraphChainPresentation K V (OrderedEdge G) :=
  { boundary := simpleGraphBoundary (K := K) G
    localCycles := reachableRadiusBallCycleSpace (K := K) G r }


variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- The finite index type for cycles short enough to be visible at radius r. -/
def ShortCycle (G : SimpleGraph V) (r : ℕ) := {C : UndirectedCycle G // C.length ≤ 2 * r + 1}

noncomputable instance (r : ℕ) : Fintype (ShortCycle G r) := by
  classical
  unfold ShortCycle
  infer_instance

/-- The actual ball-supported cycle space is exactly the span of short cycles. -/
theorem reachableRadiusBallCycleSpace_eq_short_span (hcat : IsCactus G) (r : ℕ) :
    reachableRadiusBallCycleSpace (K := K) G r =
      Submodule.span K (Set.range (fun C : ShortCycle G r => cycleVector (K := K) C.val)) := by
  classical
  let Z := LinearMap.ker (simpleGraphBoundary (K := K) G)
  let S : Submodule K Z :=
    Submodule.span K (Set.range (fun C : ShortCycle G r => cycleVector (K := K) C.val))
  apply le_antisymm
  · apply Submodule.span_le.mpr
    rintro z ⟨center, hball⟩
    let b := cactusCycleBasis (K := K) hcat
    let coeff (C : UndirectedCycle G) := b.repr z C
    have hrepr : ∑ C, coeff C • cycleVector (K := K) C = z := by
      simpa only [coeff, b, cactusCycleBasis_apply] using b.sum_repr z
    have hEval (e : OrderedEdge G) : ∑ C, coeff C * cycleChain (K := K) C e = z.val e := by
      simpa only [Submodule.coe_sum, Submodule.coe_smul, Finset.sum_apply, Pi.smul_apply,
        smul_eq_mul, cycleVector] using congrArg (fun w : Z => w.val e) hrepr
    have hzero (C : UndirectedCycle G) (hshort : ¬ C.length ≤ 2 * r + 1) : coeff C = 0 := by
      by_contra hc
      apply hshort
      apply (C.visible_iff_short hcat r).mp
      have hnonzero (e : OrderedEdge G) (he : orderedEdgeKey e ∈ C.val) : z.val e ≠ 0 := by
        rw [← hEval e]
        rw [Finset.sum_eq_single C]
        · exact mul_ne_zero hc ((cycleChain_ne_zero_iff C e).mpr he)
        · intro D _ hne
          have hz : cycleChain (K := K) D e = 0 := by
            by_contra hn
            exact Finset.disjoint_left.mp (hcat hne)
              ((cycleChain_ne_zero_iff D e).mp hn) he
          rw [hz, mul_zero]
        · simp
      refine ⟨center, ?_⟩
      intro u v huv
      have hadj : G.Adj u v :=
        C.walk.adj_of_mem_edges (List.mem_toFinset.mp (C.walk_spec.2.symm ▸ huv))
      rcases lt_or_gt_of_ne hadj.ne with hv | hv
      · let e : OrderedEdge G := ⟨(u, v), hv, hadj⟩
        exact hball e (hnonzero e huv)
      · let e : OrderedEdge G := ⟨(v, u), hv, hadj.symm⟩
        have hswap : s(v, u) ∈ C.val := by
          rwa [show s(v, u) = s(u, v) from Sym2.eq_swap]
        exact (hball e (hnonzero e hswap)).symm
    change z ∈ S
    rw [← hrepr]
    apply Submodule.sum_mem
    intro C _
    by_cases hc : C.length ≤ 2 * r + 1
    · exact S.smul_mem _ (Submodule.subset_span ⟨⟨C, hc⟩, rfl⟩)
    · rw [hzero C hc, zero_smul]
      exact S.zero_mem
  · apply Submodule.span_le.mpr
    rintro _ ⟨C, rfl⟩
    apply Submodule.subset_span
    obtain ⟨center, hball⟩ := C.val.visible_of_short r C.property
    refine ⟨center, ?_⟩
    intro e he
    exact hball ((cycleChain_ne_zero_iff C.val e).mp he)

#print axioms URF.EntropyBridge.reachableRadiusBallCycleSpace_eq_short_span

end URF.EntropyBridge

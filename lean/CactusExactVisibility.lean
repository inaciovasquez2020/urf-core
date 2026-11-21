import CactusVisibility
import CactusDetour
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Subgraph
import Mathlib.Data.Finset.Max

namespace URF.EntropyBridge

open SimpleGraph

variable {V : Type*} [LinearOrder V] [Fintype V] {G : SimpleGraph V}

/-- A cactus cycle fits in a reachable ball exactly at the claimed length threshold. -/
theorem UndirectedCycle.visible_iff_short (C : UndirectedCycle G) (hcat : IsCactus G) (r : ℕ) :
    C.Visible r ↔ C.length ≤ 2 * r + 1 := by
  classical
  refine ⟨?_, C.visible_of_short r⟩
  rintro ⟨center, hball⟩
  have hnonempty : C.walk.support.toFinset.Nonempty :=
    ⟨C.base, List.mem_toFinset.mpr C.walk.start_mem_support⟩
  obtain ⟨v, hv, hmax⟩ := Finset.exists_max_image C.walk.support.toFinset (G.dist center)
    hnonempty
  let q := C.walk.rotate (List.mem_toFinset.mp hv)
  have hq : q.IsCycle := C.walk_spec.1.rotate _
  have hEq : q.edges.Perm C.walk.edges := (C.walk.rotate_edges (List.mem_toFinset.mp hv)).perm
  have hCycle {t : V} (ht : s(v, t) ∈ q.edges) : s(v, t) ∈ C.val := by
    rw [← C.walk_spec.2, List.mem_toFinset]
    exact hEq.mem_iff.mp ht
  have ha : s(v, q.snd) ∈ q.edges :=
    Walk.adj_toSubgraph_iff_mem_edges.mp (q.toSubgraph_adj_snd hq.not_nil)
  have hb : s(v, q.penultimate) ∈ q.edges :=
    Walk.adj_toSubgraph_iff_mem_edges.mp (q.toSubgraph_adj_penultimate hq.not_nil).symm
  obtain ⟨hvReach, hvDist⟩ := (hball (hCycle ha)).1
  obtain ⟨pv, hpv⟩ := hvReach.exists_walk_length_eq_dist
  let p := pv.bypass
  have hp : p.IsPath := Walk.bypass_isPath pv
  have hpLen : p.length = G.dist center v :=
    le_antisymm ((Walk.length_bypass_le pv).trans_eq hpv) (dist_le p)
  obtain ⟨t, ht, hpt⟩ : ∃ t : V, s(v, t) ∈ q.edges ∧ s(v, t) ∉ p.edges := by
    by_cases hap : s(v, q.snd) ∈ p.edges
    · refine ⟨q.penultimate, hb, ?_⟩
      intro hbp
      have hpn : ¬p.Nil := by
        intro hn
        simp [Walk.edges_eq_nil.mpr hn] at hap
      have hA : q.snd ∈ p.toSubgraph.neighborSet v :=
        Walk.adj_toSubgraph_iff_mem_edges.mpr hap
      have hB : q.penultimate ∈ p.toSubgraph.neighborSet v :=
        Walk.adj_toSubgraph_iff_mem_edges.mpr hbp
      rw [hp.neighborSet_toSubgraph_endpoint hpn] at hA hB
      exact hq.snd_ne_penultimate
        ((Set.mem_singleton_iff.mp hA).trans (Set.mem_singleton_iff.mp hB).symm)
    · exact ⟨q.snd, ha, hap⟩
  have htC := hCycle ht
  have htAdj := q.adj_of_mem_edges ht
  obtain ⟨htReach, htDist⟩ := (hball htC).2
  obtain ⟨pt, hptLen⟩ := htReach.exists_walk_length_eq_dist
  have htMax : G.dist center t ≤ G.dist center v :=
    hmax t (List.mem_toFinset.mpr (C.walk.snd_mem_support_of_mem_edges (hEq.mem_iff.mp ht)))
  have hpt' : s(v, t) ∉ pt.edges := by
    intro h
    have hs := pt.fst_mem_support_of_mem_edges h
    have hlt := pt.length_takeUntil_lt hs htAdj.ne
    have hle := dist_le (pt.takeUntil v hs)
    omega
  let alt := pt.reverse.append p
  have hAlt : s(v, t) ∉ alt.edges := by
    simpa [alt, Walk.edges_append, Walk.edges_reverse, hpt, hpt']
  have hlen := C.length_le_of_avoiding_edge hcat htAdj htC alt hAlt
  rw [show alt.length = G.dist center t + G.dist center v by
    simp [alt, Walk.length_append, Walk.length_reverse, hptLen, hpLen]] at hlen
  omega

#print axioms URF.EntropyBridge.UndirectedCycle.visible_iff_short

end URF.EntropyBridge

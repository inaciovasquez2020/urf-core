import CactusExactVisibility

namespace URF.EntropyBridge

open SimpleGraph

variable {V : Type*} [LinearOrder V] {G : SimpleGraph V}

/-- Cutting a distinguished edge of a trail out of a closed walk leaves an
alternate walk between the two endpoints of that edge. -/
theorem exists_avoiding_complement_of_mem_trail {a b : V} (q : G.Walk a b)
    (hq : q.edges.Nodup) (p : G.Walk b a) {e : Sym2 V}
    (he : e ∈ q.edges) (hp : e ∉ p.edges) :
    ∃ u v : V, ∃ _ : G.Adj u v, e = s(u, v) ∧
      ∃ w : G.Walk v u, e ∉ w.edges ∧ w.length + 1 = q.length + p.length := by
  classical
  induction q with
  | nil => simp at he
  | @cons a b c hab q ih =>
    simp only [Walk.edges_cons, List.nodup_cons] at hq
    simp only [Walk.edges_cons, List.mem_cons] at he
    rcases he with rfl | he
    · refine ⟨a, b, hab, rfl, q.append p, ?_, ?_⟩
      · simp [Walk.edges_append, hq.1, hp]
      · simp only [Walk.length_append, Walk.length_cons]
        omega
    · have hne : e ≠ s(a, b) := fun h => hq.1 (h ▸ he)
      let p' := p.append (Walk.cons hab Walk.nil)
      have hp' : e ∉ p'.edges := by
        simp [p', Walk.edges_append, Walk.edges_cons, hp, hne]
      obtain ⟨u, v, hadj, huv, w, hw, hlen⟩ := ih hq.2 p' he hp'
      refine ⟨u, v, hadj, huv, w, hw, ?_⟩
      simp only [p', Walk.length_append, Walk.length_cons, Walk.length_nil] at hlen ⊢
      omega

#print axioms URF.EntropyBridge.exists_avoiding_complement_of_mem_trail

end URF.EntropyBridge

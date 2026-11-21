import URF.Foundation.GeneralRadiusStage2b2b

/-! Stage 2b3a: oriented walk chains and their telescoping boundary. -/
namespace URF.EntropyBridge.Multiscale

noncomputable def walkChain {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (p : ℕ → V) (n : ℕ) : OrderedEdge G → K :=
  ∑ i ∈ Finset.range n, directedEdgeChainCandidate (K := K) (G := G) (p i) (p (i+1))

theorem walkChain_boundary {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (p : ℕ → V) (n : ℕ)
    (ha : ∀ i < n, G.Adj (p i) (p (i+1))) (u : V) :
    simpleGraphBoundary (K := K) G (walkChain (K := K) G p n) u =
      (if u = p n then 1 else 0) - (if u = p 0 then 1 else 0) := by
  classical
  induction n with
  | zero => simp [walkChain]
  | succ n ih =>
    have hprev := ih (fun i hi => ha i (by omega))
    unfold walkChain at *
    rw [Finset.sum_range_succ, map_add]
    change simpleGraphBoundary (K := K) G
      (∑ i ∈ Finset.range n, directedEdgeChainCandidate (K := K) (G := G) (p i) (p (i+1))) u +
      simpleGraphBoundary (K := K) G
        (directedEdgeChainCandidate (K := K) (G := G) (p n) (p (n+1))) u = _
    rw [hprev, directed_edge_boundary_candidate G _ _ (ha n (by omega))]
    ring

theorem closedWalkChain_boundary_zero {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (p : ℕ → V) (n : ℕ)
    (ha : ∀ i < n, G.Adj (p i) (p (i+1))) (hc : p n = p 0) :
    simpleGraphBoundary (K := K) G (walkChain (K := K) G p n) = 0 := by
  classical
  funext u
  rw [walkChain_boundary G p n ha u, hc, sub_self]
  rfl

theorem walkChain_nonzero_traversed {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (p : ℕ → V) (n : ℕ) (e : OrderedEdge G)
    (he : walkChain (K := K) G p n e ≠ 0) :
    ∃ i < n, (p i = e.val.1 ∧ p (i+1) = e.val.2) ∨
      (p i = e.val.2 ∧ p (i+1) = e.val.1) := by
  classical
  by_contra hn
  apply he
  unfold walkChain
  rw [Finset.sum_apply]
  apply Finset.sum_eq_zero
  intro i hi
  have hi' := Finset.mem_range.mp hi
  have hf : ¬ (e.val.1 = p i ∧ e.val.2 = p (i+1)) := by
    intro h
    exact hn ⟨i, hi', Or.inl ⟨h.1.symm, h.2.symm⟩⟩
  have hr : ¬ (e.val.1 = p (i+1) ∧ e.val.2 = p i) := by
    intro h
    exact hn ⟨i, hi', Or.inr ⟨h.2.symm, h.1.symm⟩⟩
  simp [directedEdgeChainCandidate, hf, hr]

#print axioms walkChain_boundary
#print axioms closedWalkChain_boundary_zero
#print axioms walkChain_nonzero_traversed

end URF.EntropyBridge.Multiscale

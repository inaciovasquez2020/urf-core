import URF.Foundation.GeneralRadiusStage2b1

/-! Stage 2b2a: finite graph cycle extraction from local branching.
The abstract graph lemma does not assume cycle existence. -/
namespace URF.EntropyBridge.Multiscale

theorem exists_cycle_of_two_neighbors
    {V : Type*} [Fintype V] (H : SimpleGraph V)
    (hne : ∃ u v, H.Adj u v)
    (hbranch : ∀ u v, H.Adj u v → ∃ w, H.Adj u w ∧ w ≠ v) :
    ∃ v : V, ∃ p : H.Walk v v, p.IsCycle := by
  classical
  by_contra hno
  have hac : H.IsAcyclic := by
    intro v p hp
    exact hno ⟨v, p, hp⟩
  obtain ⟨u, v, huv⟩ := hne
  let c := H.connectedComponentMk u
  have hcu : H.connectedComponentMk u = c := rfl
  have hcv : H.connectedComponentMk v = c :=
    (SimpleGraph.ConnectedComponent.sound huv.reachable).symm
  let U : c.supp := ⟨u, hcu⟩
  let W : c.supp := ⟨v, hcv⟩
  letI : Nontrivial c.supp := ⟨⟨U, W, fun h =>
    huv.ne (congrArg Subtype.val h)⟩⟩
  have ht := hac.isTree_connectedComponent c
  obtain ⟨x, hx⟩ := ht.exists_vert_degree_one_of_nontrivial
  obtain ⟨y, hy, hyuniq⟩ := SimpleGraph.degree_eq_one_iff_existsUnique_adj.mp hx
  have hxy : H.Adj x.val y.val := hy
  obtain ⟨w, hw, hwy⟩ := hbranch x.val y.val hxy
  have hwc : H.connectedComponentMk w = c :=
    (SimpleGraph.ConnectedComponent.sound hw.reachable).symm.trans x.property
  let Z : c.supp := ⟨w, hwc⟩
  have hZ : c.toSimpleGraph.Adj x Z := hw
  exact hwy (congrArg Subtype.val (hyuniq Z hZ))

#print axioms exists_cycle_of_two_neighbors

end URF.EntropyBridge.Multiscale

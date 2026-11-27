import URF.Foundation.CyclePartitionDirectedKernelCandidate
import URF.Foundation.SharpCliqueEntropy

namespace URF.EntropyBridge

variable {sizes : List ℕ}

theorem cyclePartition_successor_iff_next
    (hp : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (u v : CyclePartitionVertex sizes) :
    cyclePartitionSuccessorRel sizes u v ↔ cyclePartitionNext sizes hp u = v := by
  obtain ⟨i, x⟩ := u
  obtain ⟨j, y⟩ := v
  constructor
  · rintro ⟨hij, h⟩
    change i = j at hij
    subst j
    change x.val + 1 = y.val ∨ (x.val + 1 = sizes.get i ∧ y.val = 0) at h
    apply congrArg (Sigma.mk i)
    apply Fin.ext
    change (x.val + 1) % sizes.get i = y.val
    rcases h with h | ⟨h, hy⟩
    · rw [h, Nat.mod_eq_of_lt y.isLt]
    · rw [h, hy, Nat.mod_self]
  · intro h
    have hij : i = j := congrArg Sigma.fst h
    subst j
    have hy : (x.val + 1) % sizes.get i = y.val :=
      congrArg (fun a : CyclePartitionVertex sizes => a.2.val) h
    change i = i ∧ (x.val + 1 = y.val ∨ (x.val + 1 = sizes.get i ∧ y.val = 0))
    refine ⟨rfl, ?_⟩
    by_cases ht : x.val + 1 < sizes.get i
    · exact Or.inl (by rwa [Nat.mod_eq_of_lt ht] at hy)
    · have he : x.val + 1 = sizes.get i := by have := x.isLt; omega
      exact Or.inr ⟨he, by simpa [he] using hy.symm⟩

theorem cyclePartition_next_injective
    (hp : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    Function.Injective (cyclePartitionNext sizes hp) := by
  rintro ⟨i, x⟩ ⟨j, y⟩ h
  have hij : i = j := congrArg Sigma.fst h
  subst j
  have he : (x.val + 1) % sizes.get i = (y.val + 1) % sizes.get i :=
    congrArg (fun a : CyclePartitionVertex sizes => a.2.val) h
  apply congrArg (Sigma.mk i)
  apply Fin.ext
  have hm := Nat.ModEq.add_right_cancel' 1
    (show x.val + 1 ≡ y.val + 1 [MOD sizes.get i] from he)
  change x.val % sizes.get i = y.val % sizes.get i at hm
  simpa only [Nat.mod_eq_of_lt x.isLt, Nat.mod_eq_of_lt y.isLt] using hm

noncomputable def cyclePartitionNextPerm
    (hp : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    Equiv.Perm (CyclePartitionVertex sizes) :=
  Equiv.ofBijective _ ⟨cyclePartition_next_injective hp,
    Finite.surjective_of_injective (cyclePartition_next_injective hp)⟩

theorem cyclePartition_next_next_ne
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
    (hp : ∀ i : Fin sizes.length, 0 < sizes.get i) (v : CyclePartitionVertex sizes) :
    cyclePartitionNext sizes hp (cyclePartitionNext sizes hp v) ≠ v := by
  obtain ⟨i, x⟩ := v
  intro h
  have he : (((x.val + 1) % sizes.get i) + 1) % sizes.get i = x.val :=
    congrArg (fun a : CyclePartitionVertex sizes => a.2.val) h
  have hstep := (Nat.mod_modEq (x.val + 1) (sizes.get i)).add_right 1
  have hwrap : (x.val + 1) % sizes.get i + 1 ≡ x.val [MOD sizes.get i] := by
    change ((x.val + 1) % sizes.get i + 1) % sizes.get i = x.val % sizes.get i
    rw [he, Nat.mod_eq_of_lt x.isLt]
  have hreturn : x.val ≡ x.val + 2 [MOD sizes.get i] := hwrap.symm.trans hstep
  have hdvd := (Nat.modEq_iff_dvd' (show x.val ≤ x.val + 2 by omega)).mp hreturn
  have hdiv : sizes.get i ∣ 2 := by simpa only [Nat.add_sub_cancel_left] using hdvd
  have hle := Nat.le_of_dvd (by decide : 0 < 2) hdiv
  have hm := h3 i
  omega

theorem cyclePartition_adj_iff_next
    (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
    (hp : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (u v : CyclePartitionVertex sizes) :
    (cyclePartitionSimpleGraph sizes).Adj u v ↔
      cyclePartitionNext sizes hp u = v ∨ cyclePartitionNext sizes hp v = u := by
  change u ≠ v ∧ (_ ∨ _) ↔ _
  rw [cyclePartition_successor_iff_next hp, cyclePartition_successor_iff_next hp]
  refine ⟨And.right, fun h => ⟨?_, h⟩⟩
  intro he
  subst v
  have hn : cyclePartitionNext sizes hp u = u := h.elim id id
  exact cyclePartition_next_next_ne h3 hp u (by rw [hn, hn])

private def sortedAdjacentEdge {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    {u v : V} (ha : G.Adj u v) : OrderedEdge G :=
  if h : u < v then ⟨(u, v), h, ha⟩
  else ⟨(v, u), lt_of_le_of_ne (le_of_not_gt h) ha.ne.symm, ha.symm⟩

private theorem sortedAdjacentEdge_endpoints {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    {u v : V} (ha : G.Adj u v) :
    (sortedAdjacentEdge ha).val = (u, v) ∨ (sortedAdjacentEdge ha).val = (v, u) := by
  unfold sortedAdjacentEdge
  split
  · exact Or.inl rfl
  · exact Or.inr rfl

private theorem orderedEdge_cannot_swap {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    (a b : OrderedEdge G) (h : a.val = (b.val.2, b.val.1)) : False := by
  have hlt := a.property.1
  rw [h] at hlt
  exact b.property.1.not_gt hlt

section

variable [LinearOrder (CyclePartitionVertex sizes)]
variable (h3 : ∀ i : Fin sizes.length, 3 ≤ sizes.get i)
variable (hp : ∀ i : Fin sizes.length, 0 < sizes.get i)

noncomputable def cyclePartitionOrderedEdge (u : CyclePartitionVertex sizes) :
    OrderedEdge (cyclePartitionSimpleGraph sizes) :=
  sortedAdjacentEdge ((cyclePartition_adj_iff_next h3 hp u _).2 (Or.inl rfl))

theorem cyclePartition_orderedEdge_endpoints (u : CyclePartitionVertex sizes) :
    (cyclePartitionOrderedEdge h3 hp u).val = (u, cyclePartitionNext sizes hp u) ∨
    (cyclePartitionOrderedEdge h3 hp u).val = (cyclePartitionNext sizes hp u, u) :=
  sortedAdjacentEdge_endpoints _

noncomputable def cyclePartitionEdgeEquiv :
    CyclePartitionVertex sizes ≃ OrderedEdge (cyclePartitionSimpleGraph sizes) := by
  apply Equiv.ofBijective (cyclePartitionOrderedEdge h3 hp)
  constructor
  · intro u v he
    have he' := congrArg Subtype.val he
    rcases cyclePartition_orderedEdge_endpoints h3 hp u with hu | hu <;>
      rcases cyclePartition_orderedEdge_endpoints h3 hp v with hv | hv <;>
      rw [hu, hv, Prod.mk.injEq] at he'
    · exact he'.1
    · exact False.elim (cyclePartition_next_next_ne h3 hp u (by rw [he'.2, ← he'.1]))
    · exact False.elim (cyclePartition_next_next_ne h3 hp u (by rw [he'.1, he'.2]))
    · exact he'.2
  · intro e
    rcases (cyclePartition_adj_iff_next h3 hp _ _).1 e.property.2 with h | h
    · refine ⟨e.val.1, ?_⟩
      apply Subtype.ext
      rcases cyclePartition_orderedEdge_endpoints h3 hp e.val.1 with he | he
      · rw [he, h]
      · exact False.elim (orderedEdge_cannot_swap _ e (by rw [he, h]))
    · refine ⟨e.val.2, ?_⟩
      apply Subtype.ext
      rcases cyclePartition_orderedEdge_endpoints h3 hp e.val.2 with he | he
      · exact False.elim (orderedEdge_cannot_swap _ e (by rw [he, h]))
      · rw [he, h]

variable (K : Type*) [Field K]

noncomputable def cyclePartitionEdgeSign (u : CyclePartitionVertex sizes) : K :=
  if (cyclePartitionEdgeEquiv h3 hp u).val.1 = u then 1 else -1

theorem cyclePartition_edgeSign_sq (u : CyclePartitionVertex sizes) :
    cyclePartitionEdgeSign h3 hp K u * cyclePartitionEdgeSign h3 hp K u = 1 := by
  unfold cyclePartitionEdgeSign
  split <;> simp

/-- Reindex source coordinates by the canonical edges, reversing the sign
when the canonical orientation differs from the cyclic direction. -/
noncomputable def cyclePartitionSignedEdges :
    (CyclePartitionVertex sizes → K) ≃ₗ[K]
      (OrderedEdge (cyclePartitionSimpleGraph sizes) → K) where
  toFun z e := cyclePartitionEdgeSign h3 hp K ((cyclePartitionEdgeEquiv h3 hp).symm e) *
    z ((cyclePartitionEdgeEquiv h3 hp).symm e)
  invFun z u := cyclePartitionEdgeSign h3 hp K u * z (cyclePartitionEdgeEquiv h3 hp u)
  left_inv z := by
    funext u
    simp [← mul_assoc, cyclePartition_edgeSign_sq]
  right_inv z := by
    funext e
    simp [← mul_assoc, cyclePartition_edgeSign_sq]
  map_add' z w := by
    funext e
    exact mul_add _ _ _
  map_smul' a z := by
    funext e
    change _ * (a * _) = a * (_ * _)
    ring

theorem cyclePartition_signed_incidence (u v : CyclePartitionVertex sizes) :
    simpleGraphIncidence (K := K) (cyclePartitionSimpleGraph sizes) v
        (cyclePartitionEdgeEquiv h3 hp u) * cyclePartitionEdgeSign h3 hp K u =
      (if v = cyclePartitionNext sizes hp u then 1 else 0) - (if v = u then 1 else 0) := by
  have hn : u ≠ cyclePartitionNext sizes hp u :=
    ((cyclePartition_adj_iff_next h3 hp u _).2 (Or.inl rfl)).ne
  have hnrev := hn.symm
  have he : (cyclePartitionEdgeEquiv h3 hp u).val = (u, cyclePartitionNext sizes hp u) ∨
      (cyclePartitionEdgeEquiv h3 hp u).val = (cyclePartitionNext sizes hp u, u) :=
    cyclePartition_orderedEdge_endpoints h3 hp u
  rcases he with he | he <;>
    by_cases hv : v = u <;> by_cases hw : v = cyclePartitionNext sizes hp u <;>
    simp_all [simpleGraphIncidence, cyclePartitionEdgeSign]

/-- With source-indexed cycle coordinates, the incidence row at a vertex
is the directed difference evaluated at its predecessor. -/
theorem cyclePartition_boundary_intertwines
    (z : CyclePartitionVertex sizes → K) (v : CyclePartitionVertex sizes) :
    simpleGraphBoundary (cyclePartitionSimpleGraph sizes) (cyclePartitionSignedEdges h3 hp K z) v =
      cyclePartitionDirectedBoundary K sizes hp z ((cyclePartitionNextPerm hp).symm v) := by
  classical
  let G := cyclePartitionSimpleGraph sizes
  let E := cyclePartitionEdgeEquiv h3 hp
  let P := cyclePartitionNextPerm hp
  change (∑ e : OrderedEdge G, simpleGraphIncidence (K := K) G v e *
    (cyclePartitionSignedEdges h3 hp K z) e) = z (P.symm v) - z (P (P.symm v))
  rw [P.apply_symm_apply]
  calc
    _ = ∑ u : CyclePartitionVertex sizes, simpleGraphIncidence (K := K) G v (E u) *
          (cyclePartitionSignedEdges h3 hp K z) (E u) := (E.sum_comp _).symm
    _ = ∑ u : CyclePartitionVertex sizes,
          ((if v = P u then (1 : K) else 0) - (if v = u then 1 else 0)) * z u := by
      apply Finset.sum_congr rfl
      intro u _
      have he : (cyclePartitionSignedEdges h3 hp K z) (E u) =
          cyclePartitionEdgeSign h3 hp K u * z u := by
        change _ * z (E.symm (E u)) = _
        rw [E.symm_apply_apply]
      rw [he, ← mul_assoc, cyclePartition_signed_incidence h3 hp K]
      rfl
    _ = _ := by
      simp only [sub_mul, Finset.sum_sub_distrib, ite_mul, one_mul, zero_mul]
      have he (u : CyclePartitionVertex sizes) : v = P u ↔ u = P.symm v := by
        rw [eq_comm, Equiv.apply_eq_iff_eq_symm_apply]
      simp [he, eq_comm (a := v)]

/-- The signed coordinate change restricts to the two incidence kernels. -/
noncomputable def cyclePartitionIncidenceKernelEquiv :
    LinearMap.ker (cyclePartitionDirectedBoundary K sizes hp) ≃ₗ[K]
      LinearMap.ker (simpleGraphBoundary (K := K) (cyclePartitionSimpleGraph sizes)) := by
  let E := cyclePartitionSignedEdges h3 hp K
  refine E.submoduleMap _ |>.trans (LinearEquiv.ofEq _ _ ?_)
  ext y
  rw [Submodule.mem_map_equiv, LinearMap.mem_ker, LinearMap.mem_ker]
  constructor
  · intro hz
    funext v
    rw [← E.apply_symm_apply y, cyclePartition_boundary_intertwines h3 hp K, hz]
    rfl
  · intro hy
    funext v
    have ht := cyclePartition_boundary_intertwines h3 hp K (E.symm y) (cyclePartitionNextPerm hp v)
    simpa [E, hy] using ht.symm

include h3 hp in
theorem cyclePartition_incidenceKernel_finrank :
    Module.finrank K
      (LinearMap.ker (simpleGraphBoundary (K := K) (cyclePartitionSimpleGraph sizes))) =
        sizes.length :=
  (cyclePartitionIncidenceKernelEquiv h3 hp K).finrank_eq.symm.trans
    (cyclePartitionDirectedKernel_finrank K sizes hp)

end

#print axioms cyclePartitionNextPerm
#print axioms cyclePartitionEdgeEquiv
#print axioms cyclePartitionSignedEdges
#print axioms cyclePartition_boundary_intertwines
#print axioms cyclePartitionIncidenceKernelEquiv
#print axioms cyclePartition_incidenceKernel_finrank

end URF.EntropyBridge

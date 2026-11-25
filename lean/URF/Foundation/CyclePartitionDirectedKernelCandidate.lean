import URF.Foundation.CyclePartitionGraphCandidate

/-!
A field-independent circulation model on the actual variable-length
cycle-partition vertex carrier. Its edge coordinates are indexed by the
source vertex of each directed cycle edge. Identifying that directed edge
basis with OrderedEdge of the SimpleGraph is a separate obligation.
-/

namespace URF.EntropyBridge

/-- Cyclic successor of a vertex in its indexed block. -/
def cyclePartitionNext (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (v : CyclePartitionVertex sizes) : CyclePartitionVertex sizes :=
  ⟨v.1, ⟨(v.2.val + 1) % sizes.get v.1,
    Nat.mod_lt _ (hpos v.1)⟩⟩

/-- A directed incidence boundary with one edge coordinate per vertex:
zero boundary means invariance under the cyclic successor. -/
def cyclePartitionDirectedBoundary (K : Type*) [Field K]
    (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    (CyclePartitionVertex sizes → K) →ₗ[K]
      (CyclePartitionVertex sizes → K) where
  toFun z v := z v - z (cyclePartitionNext sizes hpos v)
  map_add' z w := by
    funext v
    change (z v + w v) -
      (z (cyclePartitionNext sizes hpos v) +
        w (cyclePartitionNext sizes hpos v)) =
      (z v - z (cyclePartitionNext sizes hpos v)) +
        (w v - w (cyclePartitionNext sizes hpos v))
    ring
  map_smul' a z := by
    funext v
    change a * z v - a * z (cyclePartitionNext sizes hpos v) =
      a * (z v - z (cyclePartitionNext sizes hpos v))
    ring

/-- A kernel vector has equal coefficients at consecutive positions. -/
theorem cyclePartitionDirectedKernel_succ
    {K : Type*} [Field K]
    (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (z : LinearMap.ker (cyclePartitionDirectedBoundary K sizes hpos))
    (i : Fin sizes.length) (n : ℕ)
    (hn : n < sizes.get i) (hn1 : n + 1 < sizes.get i) :
    z.val (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes) =
      z.val (⟨i, ⟨n + 1, hn1⟩⟩ : CyclePartitionVertex sizes) := by
  have hz := congrFun (LinearMap.mem_ker.mp z.property)
    (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes)
  change z.val (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes) -
    z.val (cyclePartitionNext sizes hpos
      (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes)) = 0 at hz
  have hs : cyclePartitionNext sizes hpos
      (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes) =
        (⟨i, ⟨n + 1, hn1⟩⟩ : CyclePartitionVertex sizes) := by
    apply Sigma.ext
    · rfl
    · apply Fin.ext
      exact Nat.mod_eq_of_lt hn1
  rw [hs] at hz
  exact sub_eq_zero.mp hz

/-- Kernel coefficients are constant throughout each positive-length block. -/
theorem cyclePartitionDirectedKernel_constant
    {K : Type*} [Field K] (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i)
    (z : LinearMap.ker (cyclePartitionDirectedBoundary K sizes hpos))
    (i : Fin sizes.length) (x : Fin (sizes.get i)) :
    z.val (⟨i, x⟩ : CyclePartitionVertex sizes) =
      z.val (⟨i, ⟨0, hpos i⟩⟩ : CyclePartitionVertex sizes) := by
  have haux : ∀ n (hn : n < sizes.get i),
      z.val (⟨i, ⟨n, hn⟩⟩ : CyclePartitionVertex sizes) =
      z.val (⟨i, ⟨0, hpos i⟩⟩ : CyclePartitionVertex sizes) := by
    intro n
    induction n with
    | zero =>
        intro hn
        rfl
    | succ n ih =>
        intro hn
        have hp : n < sizes.get i := by omega
        exact (cyclePartitionDirectedKernel_succ sizes hpos z i n hp hn).symm.trans
          (ih hp)
  exact haux x.val x.isLt

/-- No dimension claim is assumed: a circulation is exactly one field
element per indexed cycle block, via a linear equivalence. -/
noncomputable def cyclePartitionDirectedKernelEquiv
    (K : Type*) [Field K] (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    LinearMap.ker (cyclePartitionDirectedBoundary K sizes hpos) ≃ₗ[K]
      (Fin sizes.length → K) where
  toFun z i := z.val (⟨i, ⟨0, hpos i⟩⟩ : CyclePartitionVertex sizes)
  invFun a := ⟨fun v => a v.1, by
    apply LinearMap.mem_ker.mpr
    funext v
    change a v.1 - a (cyclePartitionNext sizes hpos v).1 = 0
    simp [cyclePartitionNext]⟩
  left_inv z := by
    apply Subtype.ext
    funext v
    exact (cyclePartitionDirectedKernel_constant sizes hpos z v.1 v.2).symm
  right_inv a := by rfl
  map_add' z w := by rfl
  map_smul' a z := by rfl

/-- Exact circulation dimension, valid over any field and for unequal
positive component lengths. -/
theorem cyclePartitionDirectedKernel_finrank
    (K : Type*) [Field K] (sizes : List ℕ)
    (hpos : ∀ i : Fin sizes.length, 0 < sizes.get i) :
    Module.finrank K
      (LinearMap.ker (cyclePartitionDirectedBoundary K sizes hpos)) =
      sizes.length := by
  calc
    _ = Module.finrank K (Fin sizes.length → K) :=
      (cyclePartitionDirectedKernelEquiv K sizes hpos).finrank_eq
    _ = sizes.length := by
      rw [Module.finrank_fintype_fun_eq_card, Fintype.card_fin]

#print axioms URF.EntropyBridge.cyclePartitionDirectedKernel_succ
#print axioms URF.EntropyBridge.cyclePartitionDirectedKernel_constant
#print axioms URF.EntropyBridge.cyclePartitionDirectedKernelEquiv
#print axioms URF.EntropyBridge.cyclePartitionDirectedKernel_finrank

end URF.EntropyBridge

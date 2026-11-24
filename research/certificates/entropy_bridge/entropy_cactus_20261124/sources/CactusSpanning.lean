import CactusSupportCycle

namespace URF.EntropyBridge

open SimpleGraph

variable {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
variable {G : SimpleGraph V}

/-- Cycle chains span the incidence kernel of any finite simple graph. -/
theorem cycleVector_span_eq_top :
    Submodule.span K (Set.range (cycleVector (K := K) (G := G))) = ⊤ := by
  classical
  let Z := LinearMap.ker (simpleGraphBoundary (K := K) G)
  let S : Submodule K Z := Submodule.span K (Set.range (cycleVector (K := K) (G := G)))
  let support (z : Z) : Finset (OrderedEdge G) := Finset.univ.filter (fun e => z.val e ≠ 0)
  have hmem (z : Z) (e : OrderedEdge G) : e ∈ support z ↔ z.val e ≠ 0 := by simp [support]
  change S = ⊤
  apply top_unique
  intro z _
  suffices h : ∀ n, ∀ q : Z, (support q).card = n → q ∈ S by
    exact h _ z rfl
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    intro q hn
    by_cases hq : q = 0
    · rw [hq]
      exact S.zero_mem
    have hex : ∃ e : OrderedEdge G, q.val e ≠ 0 := by
      by_contra! hz
      exact hq (Subtype.ext (funext hz))
    obtain ⟨e, he⟩ := hex
    obtain ⟨C, heC, hC⟩ := kernel_support_contains_cycle q e he
    have hd : cycleChain (K := K) C e ≠ 0 := (cycleChain_ne_zero_iff C e).mpr heC
    let a : K := q.val e / cycleChain (K := K) C e
    let w : Z := q - a • cycleVector C
    have hsub : support w ⊆ support q := by
      intro f hf
      apply (hmem q f).mpr
      intro hzero
      have hcf : cycleChain (K := K) C f = 0 := by
        by_contra hne
        exact hC f ((cycleChain_ne_zero_iff C f).mp hne) hzero
      apply (hmem w f).mp hf
      change q.val f - a * cycleChain (K := K) C f = 0
      simp [hzero, hcf]
    have hew : e ∉ support w := by
      intro hm
      apply (hmem w e).mp hm
      change q.val e - (q.val e / cycleChain (K := K) C e) * cycleChain (K := K) C e = 0
      rw [div_mul_cancel₀ _ hd, sub_self]
    have hlt : (support w).card < n := by
      rw [← hn]
      exact Finset.card_lt_card ((Finset.ssubset_iff_of_subset hsub).mpr
        ⟨e, (hmem q e).mpr he, hew⟩)
    have hw : w ∈ S := ih _ hlt w rfl
    have hc : cycleVector (K := K) C ∈ S := Submodule.subset_span ⟨C, rfl⟩
    simpa only [w, sub_add_cancel] using S.add_mem hw (S.smul_mem a hc)

#print axioms URF.EntropyBridge.cycleVector_span_eq_top

end URF.EntropyBridge

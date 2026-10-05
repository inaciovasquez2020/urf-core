import Mathlib

namespace URF.Foundation

private lemma finite_sum_mul_log_div_leq
    {α : Type u} [DecidableEq α]
    {s : Finset α} {a b : α → ℝ}
    (ha : ∀ i ∈ s, 0 ≤ a i)
    (hb : ∀ i ∈ s, 0 ≤ b i)
    (habs : ∀ i ∈ s, b i = 0 → a i = 0) :
    (∑ i ∈ s, a i) * Real.log ((∑ i ∈ s, a i) / (∑ i ∈ s, b i)) ≤
      ∑ i ∈ s, a i * Real.log (a i / b i) := by
  by_cases h : ∀ i ∈ s, b i = 0
  · have A : ∑ i ∈ s, b i = ∑ i ∈ s, 0 :=
      Finset.sum_congr rfl (fun i hi => h i hi)
    have B : ∑ i ∈ s, a i * Real.log (a i / b i) =
        ∑ i ∈ s, a i * Real.log (a i / 0) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [h i hi]
    simp [A, B]
  let B := ∑ i ∈ s, b i
  have B_pos : 0 < B := by
    apply Finset.sum_pos' hb
    simp only [not_forall] at h
    rcases h with ⟨i, hi, h'i⟩
    exact ⟨i, hi, lt_of_le_of_ne (hb i hi) (Ne.symm h'i)⟩
  suffices
      - (∑ i ∈ s, a i * Real.log (a i / b i)) / B ≤
        - ((∑ i ∈ s, a i) * Real.log ((∑ i ∈ s, a i) / (∑ i ∈ s, b i))) / B by
    rwa [div_le_div_iff_of_pos_right B_pos, neg_le_neg_iff] at this
  have A : ∑ i ∈ s, b i / B = 1 := by
    simp [← Finset.sum_div, B, div_self B_pos.ne']
  have A' : ∀ i ∈ s, 0 ≤ b i / B :=
    fun i hi => div_nonneg (hb i hi) B_pos.le
  have A'' : ∀ i ∈ s, 0 ≤ a i / b i :=
    fun i hi => div_nonneg (ha i hi) (hb i hi)
  convert! ConcaveOn.le_map_sum Real.concaveOn_negMulLog A' A
      (p := fun i => a i / b i) A'' using 1
  · simp only [Real.negMulLog, neg_mul, smul_eq_mul, mul_neg, Finset.sum_neg_distrib]
    rw [neg_div, Finset.sum_div]
    congr 1
    apply Finset.sum_congr rfl
    intro i hi
    rcases eq_or_lt_of_le (hb i hi) with h'i | h'i
    · simp [← h'i, habs i hi h'i.symm]
    · field_simp
  · have hsum :
        ∑ x ∈ s, b x / B * (a x / b x) = (∑ x ∈ s, a x) / B := by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro i hi
      rcases eq_or_lt_of_le (hb i hi) with h'i | h'i
      · simp [← h'i, habs i hi h'i.symm]
      · field_simp
    simp only [Real.negMulLog, smul_eq_mul, neg_mul, hsum]
    ring

structure FiniteMutualInformationData
    (α β : Type u) [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β] where
  joint : α × β → ℝ
  nonneg : ∀ p, 0 ≤ joint p
  sum_one : ∑ p, joint p = 1

noncomputable def finiteMutualInformation
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) : ℝ :=
  ∑ p, P.joint p *
    Real.log (P.joint p /
      ((∑ y, P.joint (p.1, y)) * (∑ x, P.joint (x, p.2))))

theorem finiteMutualInformation_nonneg
    {α β : Type u} [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteMutualInformationData α β) :
    0 ≤ finiteMutualInformation P := by
  unfold finiteMutualInformation
  let a : α × β → ℝ := P.joint
  let b : α × β → ℝ :=
    fun p => (∑ y, P.joint (p.1, y)) * (∑ x, P.joint (x, p.2))
  have ha : ∀ p ∈ (Finset.univ : Finset (α × β)), 0 ≤ a p := by
    intro p hp
    exact P.nonneg p
  have hb : ∀ p ∈ (Finset.univ : Finset (α × β)), 0 ≤ b p := by
    intro p hp
    exact mul_nonneg
      (Finset.sum_nonneg (fun y _ => P.nonneg (p.1, y)))
      (Finset.sum_nonneg (fun x _ => P.nonneg (x, p.2)))
  have habs : ∀ p ∈ (Finset.univ : Finset (α × β)), b p = 0 → a p = 0 := by
    intro p hp hbp
    by_contra hpa
    have hpa_pos : 0 < a p := lt_of_le_of_ne (ha p hp) (Ne.symm hpa)
    have hx_pos : 0 < ∑ y, P.joint (p.1, y) := by
      exact lt_of_le_of_lt
        (ha p hp)
        (by
          have hterm : P.joint p ≤ ∑ y, P.joint (p.1, y) := by
            exact Finset.single_le_sum
              (s := (Finset.univ : Finset β))
              (fun y _ => P.nonneg (p.1, y))
              (Finset.mem_univ p.2)
          exact hterm)
    have hy_pos : 0 < ∑ x, P.joint (x, p.2) := by
      have hterm : P.joint p ≤ ∑ x, P.joint (x, p.2) := by
        exact Finset.single_le_sum
          (s := (Finset.univ : Finset α))
          (fun x _ => P.nonneg (x, p.2))
          (Finset.mem_univ p.1)
      exact lt_of_le_of_lt (ha p hp) (lt_of_le_of_ne hterm (Ne.symm hpa))
    exact (ne_of_gt (mul_pos hx_pos hy_pos)) hbp
  have hsum_a : ∑ p, a p = 1 := by
    simpa [a] using P.sum_one
  have hsum_b : ∑ p, b p = 1 := by
    simp only [b, Finset.sum_product, ← Finset.sum_mul]
    rw [show (∑ x : α, ∑ y : β, P.joint (x, y)) = 1 by
      simpa [Finset.sum_product] using P.sum_one]
    simp
  have hlog :=
    finite_sum_mul_log_div_leq
      (s := (Finset.univ : Finset (α × β))) ha hb habs
  rw [hsum_a, hsum_b] at hlog
  simpa [a, b] using hlog

end URF.Foundation

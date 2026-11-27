import Mathlib
import URF.Foundation.JointFiniteConditionalMutualInformation
import URF.Foundation.FiniteMutualInformationSingletonConditioning
import URF.Foundation.FiniteT2ChainPairMarginal

namespace URF.Foundation

noncomputable def marginalXZ
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    FiniteMutualInformationData α γ where
  joint := fun p => ∑ y, P.joint (p.1, y, p.2)
  nonneg := by
    intro p
    exact Finset.sum_nonneg (fun y _ => P.nonneg (p.1, y, p.2))
  sum_one := by
    have h := P.sum_one
    simp_rw [Fintype.sum_prod_type] at h ⊢
    simp_rw [Finset.sum_comm (s := (Finset.univ : Finset γ))
      (t := (Finset.univ : Finset β))]
    exact h

theorem marginalXZ_nonneg
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    ∀ p, 0 ≤ (marginalXZ P).joint p :=
  fun p => (marginalXZ P).nonneg p

theorem marginalXZ_sum_one
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    ∑ p, (marginalXZ P).joint p = 1 :=
  (marginalXZ P).sum_one

theorem finiteT2_mutual_information_chain_rule
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ) :
    finiteMutualInformation (jointMarginalPair P) =
      finiteMutualInformation (marginalXZ P) + jointConditionalMI P := by
  classical
  let p : α × β × γ → ℝ := P.joint
  let px : α → ℝ := fun x => ∑ yz : β × γ, P.joint (x, yz.1, yz.2)
  let pyz : β × γ → ℝ := fun yz => ∑ x, P.joint (x, yz.1, yz.2)
  let pxz : α × γ → ℝ := fun xz => ∑ y, P.joint (xz.1, y, xz.2)
  let pz : γ → ℝ := fun z => ∑ xy : α × β, P.joint (xy.1, xy.2, z)
  have hterm :
      ∀ x y z,
        p (x,y,z) * Real.log (p (x,y,z) / (px x * pyz (y,z))) =
          p (x,y,z) * Real.log (pxz (x,z) / (px x * pz z)) +
            p (x,y,z) * Real.log ((p (x,y,z) * pz z) /
              (pxz (x,z) * pyz (y,z))) := by
    intro x y z
    by_cases hp : p (x,y,z) = 0
    · simp [hp]
    have hp' : 0 < p (x,y,z) := lt_of_le_of_ne (P.nonneg (x,y,z)) (Ne.symm hp)
    have hpx' : 0 < px x := by
      exact lt_of_lt_of_le hp'
        (Finset.single_le_sum
          (fun yz _ => P.nonneg (x, yz.1, yz.2)) (Finset.mem_univ (y,z)))
    have hpyz' : 0 < pyz (y,z) := by
      exact lt_of_lt_of_le hp'
        (Finset.single_le_sum
          (fun x' _ => P.nonneg (x', y, z)) (Finset.mem_univ x))
    have hpxz' : 0 < pxz (x,z) := by
      exact lt_of_lt_of_le hp'
        (Finset.single_le_sum
          (fun y' _ => P.nonneg (x, y', z)) (Finset.mem_univ y))
    have hpz' : 0 < pz z := by
      exact lt_of_lt_of_le hp'
        (Finset.single_le_sum
          (fun xy _ => P.nonneg (xy.1, xy.2, z)) (Finset.mem_univ (x,y)))
    have hx := ne_of_gt hpx'
    have hyz := ne_of_gt hpyz'
    have hxz := ne_of_gt hpxz'
    have hz := ne_of_gt hpz'
    rw [Real.log_div hp (mul_ne_zero hx hyz),
      Real.log_div hxz (mul_ne_zero hx hz),
      Real.log_div (mul_ne_zero hp hz) (mul_ne_zero hxz hyz),
      Real.log_mul hx hyz, Real.log_mul hx hz,
      Real.log_mul hp hz, Real.log_mul hxz hyz]
    ring
  have hcmipoint :
      jointConditionalMI P =
        ∑ z : γ, ∑ xy : α × β, p (xy.1,xy.2,z) *
          Real.log ((p (xy.1,xy.2,z) * pz z) /
            (pxz (xy.1,z) * pyz (xy.2,z))) := by
    unfold jointConditionalMI
    simp [jointWeight, jointConditional, p, pxz, pyz, pz,
      finiteMutualInformation]
    apply Finset.sum_congr rfl
    intro z hz
    by_cases hpz : pz z = 0
    · have hzero : ∀ xy : α × β, p (xy.1,xy.2,z) = 0 := by
        intro xy
        have hle : p (xy.1,xy.2,z) ≤ pz z := by
          exact Finset.single_le_sum
            (fun xy' _ => P.nonneg (xy'.1,xy'.2,z)) (Finset.mem_univ xy)
        exact le_antisymm (hle.trans_eq hpz) (P.nonneg _)
      have hw : (∑ xy : α × β, P.joint (xy.1,xy.2,z)) = 0 := hpz
      have hj : ∀ xy : α × β, P.joint (xy.1,xy.2,z) = 0 := hzero
      simp [hw, hj]
    · change (if pz z = 0 then 0 else pz z *
          ∑ xy : α × β, (p (xy.1,xy.2,z) / pz z) *
            Real.log ((p (xy.1,xy.2,z) / pz z) /
              ((∑ y : β, p (xy.1,y,z) / pz z) *
               (∑ x : α, p (x,xy.2,z) / pz z)))) =
          ∑ xy : α × β, p (xy.1,xy.2,z) *
            Real.log ((p (xy.1,xy.2,z) * pz z) /
              (pxz (xy.1,z) * pyz (xy.2,z)))
      rw [if_neg hpz, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro xy _
      rw [← Finset.sum_div, ← Finset.sum_div]
      change pz z * ((p (xy.1,xy.2,z) / pz z) *
        Real.log ((p (xy.1,xy.2,z) / pz z) /
          ((pxz (xy.1,z) / pz z) * (pyz (xy.2,z) / pz z)))) =
        p (xy.1,xy.2,z) * Real.log ((p (xy.1,xy.2,z) * pz z) /
          (pxz (xy.1,z) * pyz (xy.2,z)))
      by_cases hp : p (xy.1,xy.2,z) = 0
      · simp [hp]
      · have hp' : 0 < p (xy.1,xy.2,z) :=
          lt_of_le_of_ne (P.nonneg _) (Ne.symm hp)
        have ha : 0 < pxz (xy.1,z) :=
          lt_of_lt_of_le hp' (Finset.single_le_sum
            (fun y' _ => P.nonneg (xy.1,y',z)) (Finset.mem_univ xy.2))
        have hb : 0 < pyz (xy.2,z) :=
          lt_of_lt_of_le hp' (Finset.single_le_sum
            (fun x' _ => P.nonneg (x',xy.2,z)) (Finset.mem_univ xy.1))
        have hr : (p (xy.1,xy.2,z) / pz z) /
            ((pxz (xy.1,z) / pz z) * (pyz (xy.2,z) / pz z)) =
            (p (xy.1,xy.2,z) * pz z) / (pxz (xy.1,z) * pyz (xy.2,z)) := by
          field_simp [hpz, ne_of_gt ha, ne_of_gt hb] <;> ring
        rw [hr, ← mul_assoc]
        have hm : pz z * (p (xy.1,xy.2,z) / pz z) = p (xy.1,xy.2,z) := by
          field_simp [hpz]
        rw [hm]
  have hx (x : α) : (∑ z : γ, pxz (x,z)) = px x := by
    change (∑ z : γ, ∑ y : β, p (x,y,z)) =
      ∑ yz : β × γ, p (x,yz.1,yz.2)
    rw [Fintype.sum_prod_type_right]
  have hz (z : γ) : (∑ x : α, pxz (x,z)) = pz z := by
    change (∑ x : α, ∑ y : β, p (x,y,z)) =
      ∑ xy : α × β, p (xy.1,xy.2,z)
    rw [Fintype.sum_prod_type]
  have hleft : finiteMutualInformation (jointMarginalPair P) =
      ∑ x : α, ∑ y : β, ∑ z : γ,
        p (x,y,z) * Real.log (p (x,y,z) / (px x * pyz (y,z))) := by
    change (∑ q : α × β × γ,
      p q * Real.log (p q / (px q.1 * pyz q.2))) = _
    simp_rw [Fintype.sum_prod_type]
  have hright : finiteMutualInformation (marginalXZ P) =
      ∑ x : α, ∑ y : β, ∑ z : γ,
        p (x,y,z) * Real.log (pxz (x,z) / (px x * pz z)) := by
    change (∑ q : α × γ, pxz q *
      Real.log (pxz q / ((∑ z : γ, pxz (q.1,z)) *
        (∑ x : α, pxz (x,q.2))))) = _
    simp_rw [hx, hz, Fintype.sum_prod_type]
    apply Finset.sum_congr rfl
    intro x _
    rw [Finset.sum_comm (s := (Finset.univ : Finset β))
      (t := (Finset.univ : Finset γ))]
    apply Finset.sum_congr rfl
    intro z _
    change pxz (x,z) * Real.log (pxz (x,z) / (px x * pz z)) =
      ∑ y : β, p (x,y,z) * Real.log (pxz (x,z) / (px x * pz z))
    exact Finset.sum_mul _ _ _
  have hc : jointConditionalMI P =
      ∑ x : α, ∑ y : β, ∑ z : γ,
        p (x,y,z) * Real.log ((p (x,y,z) * pz z) /
          (pxz (x,z) * pyz (y,z))) := by
    rw [hcmipoint]
    simp_rw [Fintype.sum_prod_type]
    rw [Finset.sum_comm (s := (Finset.univ : Finset γ))
      (t := (Finset.univ : Finset α))]
    simp_rw [Finset.sum_comm (s := (Finset.univ : Finset γ))
      (t := (Finset.univ : Finset β))]
  rw [hleft, hright, hc]
  simp_rw [hterm, Finset.sum_add_distrib]

end URF.Foundation

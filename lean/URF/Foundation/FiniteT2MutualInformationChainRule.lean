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
    simpa [Finset.sum_product, Prod.assoc] using P.sum_one

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
  let px : α → ℝ := fun x => ∑ yz, P.joint (x, yz.1, yz.2)
  let pyz : β × γ → ℝ := fun yz => ∑ x, P.joint (x, yz.1, yz.2)
  let pxz : α × γ → ℝ := fun xz => ∑ y, P.joint (xz.1, y, xz.2)
  let pz : γ → ℝ := fun z => ∑ xy, P.joint (xy.1, xy.2, z)
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
    rw [Real.log_div, Real.log_div, Real.log_div]
    · rw [Real.log_mul, Real.log_mul, Real.log_mul]
      · ring
      all_goals positivity
    all_goals positivity
  have hcmipoint :
      jointConditionalMI P =
        ∑ z, ∑ xy, p (xy.1,xy.2,z) *
          Real.log ((p (xy.1,xy.2,z) * pz z) /
            (pxz (xy.1,z) * pyz (xy.2,z))) := by
    unfold jointConditionalMI
    simp [jointWeight, jointConditional, p, pxz, pyz, pz,
      finiteMutualInformation]
    rw [Finset.sum_product]
    apply Finset.sum_congr rfl
    intro z hz
    by_cases hpz : pz z = 0
    · have hzero : ∀ xy, p (xy.1,xy.2,z) = 0 := by
        intro xy
        have hle : p (xy.1,xy.2,z) ≤ pz z := by
          exact Finset.single_le_sum
            (fun xy' _ => P.nonneg (xy'.1,xy'.2,z)) (Finset.mem_univ xy)
        exact le_antisymm (hle.trans_eq hpz) (P.nonneg _)
      simp [hpz, hzero]
    · have hpz' : 0 < pz z := lt_of_le_of_ne
        (Finset.sum_nonneg (fun xy _ => P.nonneg (xy.1,xy.2,z)))
        (Ne.symm hpz)
      rw [dif_neg (ne_of_gt hpz')]
      simp [Finset.sum_mul]
      congr 1
      ext xy
      by_cases hp : p (xy.1,xy.2,z) = 0
      · simp [hp]
      have hp' : 0 < p (xy.1,xy.2,z) :=
        lt_of_le_of_ne (P.nonneg _) (Ne.symm hp)
      have hpxz' : 0 < pxz (xy.1,z) := by
        exact lt_of_lt_of_le hp'
          (Finset.single_le_sum
            (fun y' _ => P.nonneg (xy.1,y',z)) (Finset.mem_univ xy.2))
      have hpyz' : 0 < pyz (xy.2,z) := by
        exact lt_of_lt_of_le hp'
          (Finset.single_le_sum
            (fun x' _ => P.nonneg (x',xy.2,z)) (Finset.mem_univ xy.1))
      field_simp [ne_of_gt hp', ne_of_gt hpz', ne_of_gt hpxz',
        ne_of_gt hpyz']
      ring
  rw [hcmipoint]
  unfold finiteMutualInformation jointMarginalPair marginalXZ
  simp only [p, px, pyz, pxz, pz]
  rw [Finset.sum_product]
  rw [Finset.sum_product]
  simp_rw [hterm]
  simp only [Finset.sum_add_distrib]
  ring

end URF.Foundation

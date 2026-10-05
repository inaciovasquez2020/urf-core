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

theorem finiteT2_mutual_information_chain_rule_of_positive
    {α β γ : Type u}
    [DecidableEq α] [DecidableEq β] [DecidableEq γ]
    [Fintype α] [Fintype β] [Fintype γ]
    (P : JointFiniteDistributionData α β γ)
    (hpos : ∀ p, 0 < P.joint p) :
    finiteMutualInformation (jointMarginalPair P) =
      finiteMutualInformation (marginalXZ P) + jointConditionalMI P := by
  classical
  let p : α × β × γ → ℝ := P.joint
  let px : α → ℝ := fun x => ∑ yz, P.joint (x, yz.1, yz.2)
  let pyz : β × γ → ℝ := fun yz => ∑ x, P.joint (x, yz.1, yz.2)
  let pxz : α × γ → ℝ := fun xz => ∑ y, P.joint (xz.1, y, xz.2)
  let pz : γ → ℝ := fun z => ∑ xy, P.joint (xy.1, xy.2, z)
  have hp : ∀ x y z, 0 < p (x,y,z) := by
    intro x y z
    exact hpos (x,y,z)
  have hpx : ∀ x, 0 < px x := by
    intro x
    exact Finset.sum_pos' (fun yz _ => le_of_lt (hp x yz.1 yz.2))
      ⟨(Classical.choice (Fintype.exists_true γ)), Finset.mem_univ _,
        lt_of_lt_of_le (hp x (Classical.choice (Fintype.exists_true β))
          (Classical.choice (Fintype.exists_true γ))) (Finset.single_le_sum
          (fun yz _ => le_of_lt (hp x yz.1 yz.2)) (Finset.mem_univ _))⟩
  have hpyz : ∀ yz, 0 < pyz yz := by
    intro yz
    exact Finset.sum_pos' (fun x _ => le_of_lt (hp x yz.1 yz.2))
      ⟨Classical.choice (Fintype.exists_true α), Finset.mem_univ _,
        hp (Classical.choice (Fintype.exists_true α)) yz.1 yz.2⟩
  have hpxz : ∀ xz, 0 < pxz xz := by
    intro xz
    exact Finset.sum_pos' (fun y _ => le_of_lt (hp xz.1 y xz.2))
      ⟨Classical.choice (Fintype.exists_true β), Finset.mem_univ _,
        hp xz.1 (Classical.choice (Fintype.exists_true β)) xz.2⟩
  have hpz : ∀ z, 0 < pz z := by
    intro z
    exact Finset.sum_pos' (fun xy _ => le_of_lt (hp xy.1 xy.2 z))
      ⟨(Classical.choice (Fintype.exists_true α),
          Classical.choice (Fintype.exists_true β)), Finset.mem_univ _,
        hp (Classical.choice (Fintype.exists_true α))
          (Classical.choice (Fintype.exists_true β)) z⟩
  have hterm :
      ∀ x y z,
        p (x,y,z) *
            Real.log (p (x,y,z) / (px x * pyz (y,z))) =
          p (x,y,z) *
              Real.log (pxz (x,z) / (px x * pz z)) +
            p (x,y,z) *
              Real.log ((p (x,y,z) * pz z) /
                (pxz (x,z) * pyz (y,z))) := by
    intro x y z
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
    rw [dif_neg]
    · simp [Finset.sum_mul]
      congr 1
      ext xy
      field_simp
      ring
    · exact ne_of_gt (hpz z)
  rw [hcmipoint]
  unfold finiteMutualInformation jointMarginalPair marginalXZ
  simp only [p, px, pyz, pxz, pz]
  rw [Finset.sum_product]
  rw [Finset.sum_product]
  simp_rw [hterm]
  simp only [Finset.sum_add_distrib]
  ring

end URF.Foundation

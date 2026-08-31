import Mathlib.Data.Fintype.BigOperators
import URF.Foundation.FiniteConditionalGibbsInequality
import URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction

namespace URF.Foundation.FiniteConditionalKLSumEntropyGap

open URF.Foundation.FiniteMarkovEvolutionPreservesDistributionsTheorem
open URF.Foundation.FiniteRandomVariablePushforward
open URF.Foundation.FiniteDiscreteShannonEntropy
open URF.Foundation.FiniteJointDistributionEntropy
open URF.Foundation.FiniteConditionalProductGibbsMeasures
open URF.Foundation.FiniteConditionalGibbsLikelihoodRatio
open URF.Foundation.FiniteConditionalGibbsInequality
open URF.Foundation.FiniteConditionalMutualInformationNonnegativityReduction

universe u

noncomputable section

/-- For any finite distribution, the weighted self-log sum is minus Shannon entropy. -/
theorem sum_prob_mul_log_eq_neg_finiteShannonEntropy
    {κ : Type u}
    [DecidableEq κ] [Fintype κ]
    (ν : FinDistribution κ) :
    (∑ k : κ, ν.prob k * Real.log (ν.prob k)) =
      -finiteShannonEntropy ν := by
  unfold finiteShannonEntropy
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro k _
  by_cases hk : ν.prob k = 0
  · simp [shannonTerm, hk]
  · simp [shannonTerm, hk]

/-- Weighted self-log sum of a finite random variable is minus its entropy. -/
theorem sum_pushProb_mul_log_eq_neg_entropy
    {α β : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    (μ : FinDistribution α) (X : α → β) :
    (∑ b : β,
      finiteRandomVariablePushProb μ X b *
        Real.log (finiteRandomVariablePushProb μ X b)) =
      -finiteRandomVariableEntropy μ X := by
  change
    (∑ b : β,
      (finiteRandomVariablePushDistribution μ X).prob b *
        Real.log ((finiteRandomVariablePushDistribution μ X).prob b)) =
      -finiteShannonEntropy (finiteRandomVariablePushDistribution μ X)
  exact sum_prob_mul_log_eq_neg_finiteShannonEntropy
    (finiteRandomVariablePushDistribution μ X)

/-- Weighted self-log sum of a finite joint law is minus joint entropy. -/
theorem sum_jointProb_mul_log_eq_neg_jointEntropy
    {α β γ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) :
    (∑ z : β × γ,
      finiteJointProb μ X Y z * Real.log (finiteJointProb μ X Y z)) =
      -finiteJointEntropy μ X Y := by
  change
    (∑ z : β × γ,
      (finiteJointDistribution μ X Y).prob z *
        Real.log ((finiteJointDistribution μ X Y).prob z)) =
      -finiteShannonEntropy (finiteJointDistribution μ X Y)
  exact sum_prob_mul_log_eq_neg_finiteShannonEntropy
    (finiteJointDistribution μ X Y)

/-- Summing the actual `(Z,X,Y)` law over `y` recovers the `(X,Z)` marginal. -/
theorem finiteXYZComparisonDistribution_sum_y
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (x : β) :
    (∑ y : γ,
      (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) =
      finiteJointProb μ X Z (x, z) := by
  simp_rw [finiteXYZComparisonDistribution_prob, finiteJointProb_eq_preimage_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  by_cases hz : Z a = z
  · by_cases hx : X a = x
    · simp [hz, hx]
    · simp [hz, hx]
  · simp [hz]

/-- Summing the actual `(Z,X,Y)` law over `x` recovers the `(Y,Z)` marginal. -/
theorem finiteXYZComparisonDistribution_sum_x
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) (y : γ) :
    (∑ x : β,
      (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) =
      finiteJointProb μ Y Z (y, z) := by
  simp_rw [finiteXYZComparisonDistribution_prob, finiteJointProb_eq_preimage_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  by_cases hz : Z a = z
  · by_cases hy : Y a = y
    · simp [hz, hy]
    · simp [hz, hy]
  · simp [hz]

/-- Summing the actual `(Z,X,Y)` law over `(x,y)` recovers the `Z` marginal. -/
theorem finiteXYZComparisonDistribution_sum_xy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (z : δ) :
    (∑ xy : β × γ,
      (finiteXYZComparisonDistribution μ X Y Z).prob (z, xy)) =
      finiteRandomVariablePushProb μ Z z := by
  rw [Fintype.sum_prod_type]
  calc
    (∑ x : β, ∑ y : γ,
      (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) =
        ∑ x : β, finiteJointProb μ X Z (x, z) := by
          apply Finset.sum_congr rfl
          intro x _
          exact finiteXYZComparisonDistribution_sum_y μ X Y Z z x
    _ = finiteRandomVariablePushProb μ Z z :=
      finiteJointProb_sum_first μ X Z z

/-- The actual-law weighted `log P_Z` sum is minus `H(Z)`. -/
theorem sum_actual_mul_log_Z_eq_neg_entropy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteRandomVariablePushProb μ Z s.1)) =
      -finiteRandomVariableEntropy μ Z := by
  calc
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteRandomVariablePushProb μ Z s.1)) =
        ∑ z : δ,
          finiteRandomVariablePushProb μ Z z *
            Real.log (finiteRandomVariablePushProb μ Z z) := by
          rw [Fintype.sum_prod_type]
          apply Finset.sum_congr rfl
          intro z _
          rw [← Finset.sum_mul,
            finiteXYZComparisonDistribution_sum_xy μ X Y Z z]
    _ = -finiteRandomVariableEntropy μ Z :=
      sum_pushProb_mul_log_eq_neg_entropy μ Z

/-- The actual-law weighted `log P_XZ` sum is minus `H(X,Z)`. -/
theorem sum_actual_mul_log_XZ_eq_neg_jointEntropy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteJointProb μ X Z (s.2.1, s.1))) =
      -finiteJointEntropy μ X Z := by
  calc
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteJointProb μ X Z (s.2.1, s.1))) =
        ∑ z : δ, ∑ x : β, ∑ y : γ,
          (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) *
            Real.log (finiteJointProb μ X Z (x, z)) := by
          rw [Fintype.sum_prod_type]
          apply Finset.sum_congr rfl
          intro z _
          rw [Fintype.sum_prod_type]
    _ = ∑ z : δ, ∑ x : β,
          finiteJointProb μ X Z (x, z) *
            Real.log (finiteJointProb μ X Z (x, z)) := by
          apply Finset.sum_congr rfl
          intro z _
          apply Finset.sum_congr rfl
          intro x _
          rw [← Finset.sum_mul,
            finiteXYZComparisonDistribution_sum_y μ X Y Z z x]
    _ = ∑ x : β, ∑ z : δ,
          finiteJointProb μ X Z (x, z) *
            Real.log (finiteJointProb μ X Z (x, z)) := by
          rw [Finset.sum_comm]
    _ = ∑ xz : β × δ,
          finiteJointProb μ X Z xz * Real.log (finiteJointProb μ X Z xz) := by
          rw [Fintype.sum_prod_type]
    _ = -finiteJointEntropy μ X Z :=
      sum_jointProb_mul_log_eq_neg_jointEntropy μ X Z

/-- The actual-law weighted `log P_YZ` sum is minus `H(Y,Z)`. -/
theorem sum_actual_mul_log_YZ_eq_neg_jointEntropy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteJointProb μ Y Z (s.2.2, s.1))) =
      -finiteJointEntropy μ Y Z := by
  calc
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log (finiteJointProb μ Y Z (s.2.2, s.1))) =
        ∑ z : δ, ∑ x : β, ∑ y : γ,
          (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) *
            Real.log (finiteJointProb μ Y Z (y, z)) := by
          rw [Fintype.sum_prod_type]
          apply Finset.sum_congr rfl
          intro z _
          rw [Fintype.sum_prod_type]
    _ = ∑ z : δ, ∑ y : γ, ∑ x : β,
          (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) *
            Real.log (finiteJointProb μ Y Z (y, z)) := by
          apply Finset.sum_congr rfl
          intro z _
          rw [Finset.sum_comm]
    _ = ∑ z : δ, ∑ y : γ,
          finiteJointProb μ Y Z (y, z) *
            Real.log (finiteJointProb μ Y Z (y, z)) := by
          apply Finset.sum_congr rfl
          intro z _
          apply Finset.sum_congr rfl
          intro y _
          rw [← Finset.sum_mul,
            finiteXYZComparisonDistribution_sum_x μ X Y Z z y]
    _ = ∑ y : γ, ∑ z : δ,
          finiteJointProb μ Y Z (y, z) *
            Real.log (finiteJointProb μ Y Z (y, z)) := by
          rw [Finset.sum_comm]
    _ = ∑ yz : γ × δ,
          finiteJointProb μ Y Z yz * Real.log (finiteJointProb μ Y Z yz) := by
          rw [Fintype.sum_prod_type]
    _ = -finiteJointEntropy μ Y Z :=
      sum_jointProb_mul_log_eq_neg_jointEntropy μ Y Z

/-- The self-log sum of the actual `(Z,X,Y)` law is minus its Shannon entropy. -/
theorem sum_actual_self_log_eq_neg_entropy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
        Real.log ((finiteXYZComparisonDistribution μ X Y Z).prob s)) =
      -finiteShannonEntropy (finiteXYZComparisonDistribution μ X Y Z) :=
  sum_prob_mul_log_eq_neg_finiteShannonEntropy
    (finiteXYZComparisonDistribution μ X Y Z)

/-- Reordering `(Z,(X,Y))` to `(X,(Y,Z))` preserves the concrete triple entropy. -/
theorem finiteXYZComparisonEntropy_eq_tripleJointEntropy
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteShannonEntropy (finiteXYZComparisonDistribution μ X Y Z) =
      finiteJointEntropy μ X (fun a => (Y a, Z a)) := by
  unfold finiteShannonEntropy finiteJointEntropy
  calc
    (∑ s : δ × (β × γ),
      shannonTerm ((finiteXYZComparisonDistribution μ X Y Z).prob s)) =
        ∑ z : δ, ∑ x : β, ∑ y : γ,
          shannonTerm
            ((finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y))) := by
          rw [Fintype.sum_prod_type]
          apply Finset.sum_congr rfl
          intro z _
          rw [Fintype.sum_prod_type]
    _ = ∑ z : δ, ∑ x : β, ∑ y : γ,
          shannonTerm
            (finiteJointProb μ X (fun a => (Y a, Z a)) (x, (y, z))) := by
          apply Finset.sum_congr rfl
          intro z _
          apply Finset.sum_congr rfl
          intro x _
          apply Finset.sum_congr rfl
          intro y _
          congr 1
          rw [finiteXYZComparisonDistribution_prob,
            finiteJointProb_eq_preimage_sum]
          apply Finset.sum_congr rfl
          intro a _
          simp [and_assoc, and_left_comm, and_comm]
    _ = ∑ x : β, ∑ y : γ, ∑ z : δ,
          shannonTerm
            (finiteJointProb μ X (fun a => (Y a, Z a)) (x, (y, z))) := by
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro x _
          rw [Finset.sum_comm]
    _ = ∑ s : β × (γ × δ),
          shannonTerm
            ((finiteJointDistribution μ X (fun a => (Y a, Z a))).prob s) := by
          rw [Fintype.sum_prod_type]
          apply Finset.sum_congr rfl
          intro x _
          rw [Fintype.sum_prod_type]

/-- Pointwise expansion of the zero-safe conditional KL atom on the actual support. -/
theorem finiteConditionalKLAtom_eq_log_components
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ)
    (s : δ × (β × γ)) :
    finiteConditionalKLAtom
        ((finiteXYZComparisonDistribution μ X Y Z).prob s)
        (finiteConditionalProductProb μ X Y Z s) =
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log ((finiteXYZComparisonDistribution μ X Y Z).prob s) +
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteRandomVariablePushProb μ Z s.1) -
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteJointProb μ X Z (s.2.1, s.1)) -
      (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteJointProb μ Y Z (s.2.2, s.1)) := by
  rcases s with ⟨z, ⟨x, y⟩⟩
  have hp0 :
      0 ≤ (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) :=
    (finiteXYZComparisonDistribution μ X Y Z).nonnegative (z, (x, y))
  by_cases hp : (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) = 0
  · simp [finiteConditionalKLAtom, hp]
  · have hp_pos :
        0 < (finiteXYZComparisonDistribution μ X Y Z).prob (z, (x, y)) :=
      lt_of_le_of_ne hp0 (Ne.symm hp)
    obtain ⟨hpz, hxz, hyz⟩ :=
      finiteXYZComparisonDistribution_positive_implies_marginals_positive
        μ X Y Z z x y hp_pos
    have hq :
        finiteConditionalProductProb μ X Y Z (z, (x, y)) =
          finiteJointProb μ X Z (x, z) * finiteJointProb μ Y Z (y, z) /
            finiteRandomVariablePushProb μ Z z := by
      simp [finiteConditionalProductProb, ne_of_gt hpz]
    simp only [finiteConditionalKLAtom, hp, if_false]
    rw [hq]
    rw [Real.log_div hp
      (div_ne_zero (mul_ne_zero (ne_of_gt hxz) (ne_of_gt hyz)) (ne_of_gt hpz))]
    rw [Real.log_div (mul_ne_zero (ne_of_gt hxz) (ne_of_gt hyz)) (ne_of_gt hpz)]
    rw [Real.log_mul (ne_of_gt hxz) (ne_of_gt hyz)]
    ring

/-- The finite conditional KL sum splits into four weighted log sums. -/
theorem finiteConditionalKLSum_eq_log_components
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      finiteConditionalKLAtom
        ((finiteXYZComparisonDistribution μ X Y Z).prob s)
        (finiteConditionalProductProb μ X Y Z s)) =
      (∑ s : δ × (β × γ),
        (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log ((finiteXYZComparisonDistribution μ X Y Z).prob s)) +
      (∑ s : δ × (β × γ),
        (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteRandomVariablePushProb μ Z s.1)) -
      (∑ s : δ × (β × γ),
        (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteJointProb μ X Z (s.2.1, s.1))) -
      (∑ s : δ × (β × γ),
        (finiteXYZComparisonDistribution μ X Y Z).prob s *
          Real.log (finiteJointProb μ Y Z (s.2.2, s.1))) := by
  simp_rw [finiteConditionalKLAtom_eq_log_components μ X Y Z]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]

/-- The concrete conditional KL sum is exactly the entropy-submodularity gap. -/
theorem finiteConditionalKLSum_eq_entropy_submodularity_gap
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    (∑ s : δ × (β × γ),
      finiteConditionalKLAtom
        ((finiteXYZComparisonDistribution μ X Y Z).prob s)
        (finiteConditionalProductProb μ X Y Z s)) =
      finiteJointEntropy μ X Z + finiteJointEntropy μ Y Z -
        finiteRandomVariableEntropy μ Z -
          finiteJointEntropy μ X (fun a => (Y a, Z a)) := by
  rw [finiteConditionalKLSum_eq_log_components,
    sum_actual_self_log_eq_neg_entropy,
    sum_actual_mul_log_Z_eq_neg_entropy,
    sum_actual_mul_log_XZ_eq_neg_jointEntropy,
    sum_actual_mul_log_YZ_eq_neg_jointEntropy,
    finiteXYZComparisonEntropy_eq_tripleJointEntropy]
  ring

/-- Finite Shannon entropy satisfies strong subadditivity, derived from concrete Gibbs. -/
theorem finiteEntropySubmodularity_from_conditionalGibbs
    {α β γ δ : Type u}
    [DecidableEq α] [Fintype α]
    [DecidableEq β] [Fintype β]
    [DecidableEq γ] [Fintype γ]
    [DecidableEq δ] [Fintype δ]
    (μ : FinDistribution α) (X : α → β) (Y : α → γ) (Z : α → δ) :
    finiteEntropySubmodularity μ X Y Z := by
  letI : MeasurableSpace (δ × (β × γ)) := ⊤
  letI : MeasurableSingletonClass (δ × (β × γ)) :=
    ⟨fun _ => by simp⟩
  have hKL := finiteConditionalKLSum_nonnegative μ X Y Z
  rw [finiteConditionalKLSum_eq_entropy_submodularity_gap] at hKL
  unfold finiteEntropySubmodularity
  linarith

def status : String :=
  "FINITE_CONDITIONAL_KL_SUM_EQUALS_ENTROPY_GAP_AND_STRONG_SUBADDITIVITY"

def nextAdmissibleObject : String :=
  "FINITE_CONDITIONAL_MUTUAL_INFORMATION_NONNEGATIVITY_CLOSURE"

end

end URF.Foundation.FiniteConditionalKLSumEntropyGap

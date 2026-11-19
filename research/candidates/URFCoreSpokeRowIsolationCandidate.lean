import Mathlib

/-!
URF-Core finite conditional entropy: first fiberwise bound.
Lean v4.27.0; pinned mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900.
Independent self-contained compilation candidate. NOT_RUN.
-/
namespace URF.EntropyBridge

attribute [local instance] Classical.propDecidable


structure FiniteProbability (α : Type*) [Fintype α] where
  mass : α → ℝ
  nonneg : ∀ a, 0 ≤ mass a
  total : ∑ a : α, mass a = 1

noncomputable def observedMass {α β : Type*} [Fintype α]
    (p : α → ℝ) (f : α → β) (b : β) : ℝ := by
  classical
  exact ∑ a : α, if f a = b then p a else 0

noncomputable def conditionalMass {α β : Type*} [Fintype α]
    (p : α → ℝ) (f : α → β) (b : β) (a : α) : ℝ := by
  classical
  exact if f a = b then
    (if observedMass p f b = 0 then 0 else p a / observedMass p f b)
  else 0

/-- Conditional probabilities on a positive-mass observation fiber total one. -/
theorem conditionalMass_sum_eq_one {α β : Type*} [Fintype α]
    (p : FiniteProbability α) (f : α → β) (b : β)
    (hb : 0 < observedMass p.mass f b) :
    ∑ a : α, conditionalMass p.mass f b a = 1 := by
  classical
  have hne : observedMass p.mass f b ≠ 0 := ne_of_gt hb
  have hterm (a : α) :
      conditionalMass p.mass f b a =
        (if f a = b then p.mass a else 0) / observedMass p.mass f b := by
    by_cases h : f a = b
    · simp [conditionalMass, h, hne]
    · simp [conditionalMass, h]
  simp_rw [hterm]
  rw [← Finset.sum_div]
  change observedMass p.mass f b / observedMass p.mass f b = 1
  exact div_self hne



noncomputable def shannonTerm (t : ℝ) : ℝ :=
  if t = 0 then 0 else -(t * Real.log t)

noncomputable def finiteEntropy {α : Type*} [Fintype α]
    (p : α → ℝ) : ℝ :=
  ∑ a : α, shannonTerm (p a)

private theorem tangent_positive {p u : ℝ} (hp : 0 < p) (hu : 0 < u) :
    p * Real.log (u / p) ≤ u - p := by
  have h := Real.log_le_sub_one_of_pos (div_pos hu hp)
  have hmul := mul_le_mul_of_nonneg_left h hp.le
  calc
    p * Real.log (u / p) ≤ p * (u / p - 1) := hmul
    _ = u - p := by field_simp

private theorem tangent_zero_safe {p u : ℝ} (hp : 0 ≤ p) (hu : 0 < u) :
    (if p = 0 then 0 else p * Real.log (u / p)) ≤ u - p := by
  by_cases hz : p = 0
  · simp only [hz, sub_zero]
    exact hu.le
  · simp only [if_neg hz]
    exact tangent_positive (lt_of_le_of_ne hp (Ne.symm hz)) hu

private theorem finite_tangent {α : Type*} [Fintype α]
    (p u : α → ℝ) (hp : ∀ a, 0 ≤ p a) (hu : ∀ a, 0 < u a)
    (hp_sum : (∑ a : α, p a) = 1)
    (hu_sum : (∑ a : α, u a) = 1) :
    (∑ a : α, if p a = 0 then 0 else p a * Real.log (u a / p a)) ≤ 0 := by
  classical
  calc
    (∑ a : α, if p a = 0 then 0 else p a * Real.log (u a / p a))
      ≤ ∑ a : α, (u a - p a) := by
        apply Finset.sum_le_sum
        intro a ha
        exact tangent_zero_safe (hp a) (hu a)
    _ = 0 := by
      rw [Finset.sum_sub_distrib, hp_sum, hu_sum]
      ring

/-- Finite maximum entropy relative to a strictly positive constant-log
reference distribution. The usual uniform reference is a specialization
with `c = Real.log (Fintype.card α)` and `u a = 1/card α`. -/
theorem entropy_le_constant_log_reference {α : Type*} [Fintype α]
    (p u : α → ℝ) (c : ℝ)
    (hp : ∀ a, 0 ≤ p a) (hu : ∀ a, 0 < u a)
    (hp_sum : (∑ a : α, p a) = 1)
    (hu_sum : (∑ a : α, u a) = 1)
    (hlog : ∀ a, Real.log (u a) = -c) :
    finiteEntropy p ≤ c := by
  classical
  have hterm (a : α) :
      (if p a = 0 then 0 else p a * Real.log (u a / p a)) =
        shannonTerm (p a) - p a * c := by
    by_cases hz : p a = 0
    · simp [shannonTerm, hz]
    · have hpos : 0 < p a := lt_of_le_of_ne (hp a) (Ne.symm hz)
      simp only [shannonTerm, if_neg hz]
      rw [Real.log_div (ne_of_gt (hu a)) (ne_of_gt hpos), hlog a]
      ring
  have hsum := finite_tangent p u hp hu hp_sum hu_sum
  simp_rw [hterm] at hsum
  rw [Finset.sum_sub_distrib, ← Finset.sum_mul, hp_sum, one_mul] at hsum
  unfold finiteEntropy
  linarith

/-- Entropy is at most the logarithm of the number of possible states. -/
theorem finiteEntropy_le_log_card {α : Type*} [Fintype α] [Nonempty α]
    (p : α → ℝ) (hp : ∀ a, 0 ≤ p a)
    (hp_sum : (∑ a : α, p a) = 1) :
    finiteEntropy p ≤ Real.log (Fintype.card α) := by
  classical
  let n : ℝ := Fintype.card α
  have hn : 0 < n := by
    dsimp [n]
    exact_mod_cast (Fintype.card_pos : 0 < Fintype.card α)
  let u : α → ℝ := fun _ => 1 / n
  have hu : ∀ a, 0 < u a := by
    intro a
    exact div_pos (by norm_num) hn
  have hu_sum : (∑ a : α, u a) = 1 := by
    simp only [u, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    change n * (1 / n) = 1
    field_simp
  have hlog : ∀ a, Real.log (u a) = -Real.log n := by
    intro a
    simp only [u]
    rw [one_div, Real.log_inv]
  exact entropy_le_constant_log_reference p u (Real.log n)
    hp hu hp_sum hu_sum hlog


/-- Conditional entropy on any positive-mass fiber is bounded by the
logarithm of the full finite input space. The sharper fiber-cardinality
version remains a separate obligation. -/
theorem conditional_entropy_at_le_log_card
    {α β : Type*} [Fintype α] [Nonempty α]
    (p : FiniteProbability α) (f : α → β) (b : β)
    (hb : 0 < observedMass p.mass f b) :
    finiteEntropy (conditionalMass p.mass f b) ≤
      Real.log (Fintype.card α) := by
  apply finiteEntropy_le_log_card
  · intro a
    by_cases h : f a = b
    · simp only [conditionalMass, h, ↓reduceIte]
      split_ifs
      · exact le_refl 0
      · exact div_nonneg (p.nonneg a) hb.le
    · simp [conditionalMass, h]
  · exact conditionalMass_sum_eq_one p f b hb


/-! The following four declarations are new source candidates; they have NOT
been compiled in the pinned Lean environment. They are meant to be checked
in order and compilation must stop on the first error. -/

/-- Restrict conditional mass to the observation fiber. -/
noncomputable def restrictedConditionalMass {α β : Type*} [Fintype α]
    (p : FiniteProbability α) (f : α → β) (b : β)
    (x : {a : α // f a = b}) : ℝ :=
  conditionalMass p.mass f b x.1

/-- Step 1: normalization on the actual fiber. -/
theorem restrictedConditionalMass_sum_one
    {α β : Type*} [Fintype α]
    (p : FiniteProbability α) (f : α → β) (b : β)
    (hb : 0 < observedMass p.mass f b) :
    (∑ x : {a : α // f a = b}, restrictedConditionalMass p f b x) = 1 := by
  classical
  have h := conditionalMass_sum_eq_one p f b hb
  have hs : (∑ a : α, conditionalMass p.mass f b a) =
      ∑ a : α, if f a = b then conditionalMass p.mass f b a else 0 := by
    apply Finset.sum_congr rfl
    intro a ha
    by_cases hfa : f a = b
    · simp [hfa]
    · simp [conditionalMass, hfa]
  rw [hs] at h
  let s : Finset α := Finset.univ.filter (fun a => f a = b)
  have hmem (a : α) : a ∈ s ↔ f a = b := by
    simp [s]
  have hobverse :
      (∑ a ∈ s, conditionalMass p.mass f b a) =
        ∑ x : {a : α // f a = b}, restrictedConditionalMass p f b x := by
    simpa only [restrictedConditionalMass] using
      (Finset.sum_subtype s hmem
        (fun a : α => conditionalMass p.mass f b a))
  have hreverse :
      (∑ x : {a : α // f a = b}, restrictedConditionalMass p f b x) =
        ∑ a ∈ s, conditionalMass p.mass f b a := hobverse.symm
  have hfiltered :
      (∑ a ∈ s, conditionalMass p.mass f b a) =
        ∑ a : α, if f a = b then conditionalMass p.mass f b a else 0 := by
    simpa only [s] using
      (Finset.sum_filter (s := Finset.univ)
        (p := fun a : α => f a = b)
        (f := fun a : α => conditionalMass p.mass f b a))
  exact hreverse.trans (hfiltered.trans h)




/-- Entropy is preserved because conditional mass vanishes outside the fiber. -/
theorem restrictedConditionalMass_entropy_eq
    {α β : Type*} [Fintype α]
    (p : FiniteProbability α) (f : α → β) (b : β) :
    finiteEntropy (restrictedConditionalMass p f b) =
      finiteEntropy (conditionalMass p.mass f b) := by
  classical
  unfold finiteEntropy
  let s : Finset α := Finset.univ.filter (fun a => f a = b)
  have hmem (a : α) : a ∈ s ↔ f a = b := by
    simp [s]
  have hsub :
      (∑ a ∈ s, shannonTerm (conditionalMass p.mass f b a)) =
        ∑ x : {a : α // f a = b},
          shannonTerm (restrictedConditionalMass p f b x) := by
    simpa only [restrictedConditionalMass] using
      (Finset.sum_subtype s hmem
        (fun a : α => shannonTerm (conditionalMass p.mass f b a)))
  have hfiltered :
      (∑ a ∈ s, shannonTerm (conditionalMass p.mass f b a)) =
        ∑ a : α, if f a = b then
          shannonTerm (conditionalMass p.mass f b a) else 0 := by
    simpa only [s] using
      (Finset.sum_filter (s := Finset.univ)
        (p := fun a : α => f a = b)
        (f := fun a : α => shannonTerm (conditionalMass p.mass f b a)))
  have hsupport :
      (∑ a : α, if f a = b then
        shannonTerm (conditionalMass p.mass f b a) else 0) =
        ∑ a : α, shannonTerm (conditionalMass p.mass f b a) := by
    apply Finset.sum_congr rfl
    intro a ha
    by_cases hfa : f a = b
    · simp [hfa]
    · simp [hfa, conditionalMass, shannonTerm]
  exact hsub.symm.trans (hfiltered.trans hsupport)



/-! New stages below are compiler candidates: do not promote before Lean and axiom audit. -/

/-- A fiber of a linear map, centered at a chosen preimage, is equivalent to its kernel. -/
noncomputable def linearFiberEquivKer
    {K Q W : Type*} [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W]
    (f : Q →ₗ[K] W) (y : W) (x₀ : Q) (hx₀ : f x₀ = y) :
    {x : Q // f x = y} ≃ (LinearMap.ker f) where
  toFun := fun x => ⟨x.1 - x₀, by
    change f (x.1 - x₀) = 0
    rw [map_sub, x.property, hx₀, sub_self]⟩
  invFun := fun z => ⟨z.1 + x₀, by
    change f (z.1 + x₀) = y
    rw [map_add, z.property, hx₀, zero_add]⟩
  left_inv := by
    intro x
    apply Subtype.ext
    simp
  right_inv := by
    intro z
    apply Subtype.ext
    simp

/-- Exact cardinality of a nonempty linear observation fiber. -/
theorem linear_fiber_card_eq_ker
    {K Q W : Type*} [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W] [Fintype Q]
    (f : Q →ₗ[K] W) (y : W) (x₀ : Q) (hx₀ : f x₀ = y) :
    Fintype.card {x : Q // f x = y} = Fintype.card (LinearMap.ker f) := by
  classical
  exact Fintype.card_congr (linearFiberEquivKer f y x₀ hx₀)

/-- The observation output law has total mass one. -/
theorem observedMass_sum_one
    {Q W : Type*} [Fintype Q] [Fintype W]
    (p : FiniteProbability Q) (f : Q → W) :
    (∑ y : W, observedMass p.mass f y) = 1 := by
  classical
  calc
    (∑ y : W, observedMass p.mass f y) =
        ∑ x : Q, ∑ y : W, if f x = y then p.mass x else 0 := by
          simp only [observedMass]
          rw [Finset.sum_comm]
    _ = ∑ x : Q, p.mass x := by simp
    _ = 1 := p.total

/-- Positive probability fibers carry at most log(kernel cardinality) entropy. -/
theorem linear_conditional_entropy_at_le_log_kernel
    {K Q W : Type*} [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W] [Fintype Q]
    (p : FiniteProbability Q) (f : Q →ₗ[K] W) (y : W)
    (x₀ : Q) (hx₀ : f x₀ = y)
    (hy : 0 < observedMass p.mass f y) :
    finiteEntropy (conditionalMass p.mass f y) ≤
      Real.log (Fintype.card (LinearMap.ker f)) := by
  classical
  letI : Nonempty {x : Q // f x = y} := ⟨⟨x₀, hx₀⟩⟩
  have hnonneg : ∀ x : {x : Q // f x = y},
      0 ≤ restrictedConditionalMass p f y x := by
    intro x
    unfold restrictedConditionalMass conditionalMass
    simp only [x.property, ↓reduceIte]
    split_ifs
    · exact le_refl 0
    · exact div_nonneg (p.nonneg x.1) hy.le
  calc
    finiteEntropy (conditionalMass p.mass f y) =
        finiteEntropy (restrictedConditionalMass p f y) :=
          (restrictedConditionalMass_entropy_eq p f y).symm
    _ ≤ Real.log (Fintype.card {x : Q // f x = y}) :=
      finiteEntropy_le_log_card _ hnonneg
        (restrictedConditionalMass_sum_one p f y hy)
    _ = Real.log (Fintype.card (LinearMap.ker f)) := by
      rw [linear_fiber_card_eq_ker f y x₀ hx₀]

/-- Average a fiberwise bound for any observation distribution. -/
theorem weighted_average_le_of_pointwise
    {W : Type*} [Fintype W] (w h : W → ℝ) (C : ℝ)
    (hw : ∀ y, 0 ≤ w y)
    (htotal : ∑ y : W, w y = 1)
    (hh : ∀ y, h y ≤ C) :
    (∑ y : W, w y * h y) ≤ C := by
  calc
    (∑ y : W, w y * h y) ≤ ∑ y : W, w y * C := by
      apply Finset.sum_le_sum
      intro y hy
      exact mul_le_mul_of_nonneg_left (hh y) (hw y)
    _ = C := by rw [← Finset.sum_mul, htotal, one_mul]


/-- Full conditional entropy upper bound for an arbitrary finite-field linear observation,
 expressed using the exact cardinality of its kernel. -/
theorem linear_conditional_entropy_le_log_kernel
    {K Q W : Type*} [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W] [Fintype Q] [Fintype W]
    (p : FiniteProbability Q) (f : Q →ₗ[K] W) :
    (∑ y : W, observedMass p.mass f y *
      finiteEntropy (conditionalMass p.mass f y)) ≤
        Real.log (Fintype.card (LinearMap.ker f)) := by
  classical
  have hw (y : W) : 0 ≤ observedMass p.mass f y := by
    unfold observedMass
    apply Finset.sum_nonneg
    intro x hx
    split_ifs
    · exact p.nonneg x
    · exact le_refl 0
  have hh (y : W) :
      observedMass p.mass f y * finiteEntropy (conditionalMass p.mass f y) ≤
      observedMass p.mass f y * Real.log (Fintype.card (LinearMap.ker f)) := by
    by_cases hy : 0 < observedMass p.mass f y
    · have he : ∃ x₀ : Q, f x₀ = y := by
        by_contra hn
        have hn' : ∀ x : Q, f x ≠ y := by
          simpa only [not_exists] using hn
        have hz : observedMass p.mass f y = 0 := by
          simp [observedMass, hn']
        exact (ne_of_gt hy) hz
      obtain ⟨x₀, hx₀⟩ := he
      exact mul_le_mul_of_nonneg_left
        (linear_conditional_entropy_at_le_log_kernel p f y x₀ hx₀ hy) (hw y)
    · have hz : observedMass p.mass f y = 0 := le_antisymm (le_of_not_gt hy) (hw y)
      simp [hz]
  calc
    (∑ y : W, observedMass p.mass f y *
      finiteEntropy (conditionalMass p.mass f y)) ≤
        ∑ y : W, observedMass p.mass f y *
          Real.log (Fintype.card (LinearMap.ker f)) := by
            apply Finset.sum_le_sum
            intro y hy
            exact hh y
    _ = Real.log (Fintype.card (LinearMap.ker f)) := by
      rw [← Finset.sum_mul, observedMass_sum_one p f, one_mul]




variable {K V : Type*}
variable [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]

/-- Every functional on a subspace extends to the ambient space. -/
theorem observation_surjective (S : Subspace K V) :
    Function.Surjective (S.dualRestrict : Module.Dual K V →ₗ[K] Module.Dual K S) := by
  exact Subspace.dualRestrict_surjective

/-- Kernel of restriction is the annihilator, as actual subspaces of the dual. -/
theorem observation_kernel (S : Subspace K V) :
    LinearMap.ker S.dualRestrict = S.dualAnnihilator := by
  exact Submodule.dualRestrict_ker_eq_dualAnnihilator S

/-- Kernel dimension plus observed dimension equals the ambient dimension. -/
theorem observation_hidden_dimension (S : Subspace K V) :
    Module.finrank K (LinearMap.ker S.dualRestrict) +
      Module.finrank K S = Module.finrank K V := by
  rw [observation_kernel]
  have h := Subspace.finrank_add_finrank_dualAnnihilator_eq S
  omega

/-- Equivalent subtraction formula over natural-number dimensions. -/
theorem observation_hidden_dimension_sub (S : Subspace K V) :
    Module.finrank K (LinearMap.ker S.dualRestrict) =
      Module.finrank K V - Module.finrank K S := by
  have h := observation_hidden_dimension S
  omega


end URF.EntropyBridge


/-!
Graph chain-presentation specialization.
A finite graph is represented by a finite edge-chain space, a vertex-chain
space, a K-linear boundary, and a chosen subspace of cycles. Connecting the
`boundary` to a specific `SimpleGraph` incidence construction remains OPEN.
-/
namespace URF.EntropyBridge

/-- Finite graph chain presentation with an explicit linear boundary. -/
structure GraphChainPresentation
    (K Vert Edge : Type*) [Field K] [Fintype Vert] [Fintype Edge] where
  boundary : (Edge → K) →ₗ[K] (Vert → K)
  localCycles : Subspace K (LinearMap.ker boundary)

/-- The global cycle space is the kernel of the edge boundary. -/
abbrev graphCycles
    {K Vert Edge : Type*} [Field K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge) :=
  LinearMap.ker G.boundary

/-- Graph observation restricts linear functionals to local cycles. -/
noncomputable def graphObservation
    {K Vert Edge : Type*} [Field K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge) :
    Module.Dual K (graphCycles G) →ₗ[K]
      Module.Dual K G.localCycles :=
  G.localCycles.dualRestrict

/-- This observation is surjective, by extension of linear functionals. -/
theorem graphObservation_surjective
    {K Vert Edge : Type*} [Field K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge) :
    Function.Surjective (graphObservation G) := by
  exact Subspace.dualRestrict_surjective

/-- Hidden graph dimension is the difference between global and local cycle rank. -/
theorem graphObservation_hidden_finrank
    {K Vert Edge : Type*} [Field K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge) :
    Module.finrank K (LinearMap.ker (graphObservation G)) =
      Module.finrank K (graphCycles G) -
        Module.finrank K G.localCycles := by
  exact observation_hidden_dimension_sub G.localCycles

/-- A kernel of a map on a finite dual space inherits finite cardinality.
This is an instance construction, not an additional theorem assumption. -/
noncomputable instance graphObservationKernelFintype
    {K Vert Edge : Type*}
    [Field K] [Fintype K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge)
    [Fintype (Module.Dual K (graphCycles G))] :
    Fintype (LinearMap.ker (graphObservation G)) := by
  classical
  exact Fintype.ofFinite _

/-- The previously verified entropy theorem applies to the graph
boundary/observation presentation. Finite output and input instances are
supplied explicitly and are automatic over a finite field. -/
theorem graphObservation_entropy_le_log_kernel
    {K Vert Edge : Type*}
    [Field K] [Fintype K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge)
    [Fintype (Module.Dual K (graphCycles G))]
    [Fintype (Module.Dual K G.localCycles)]
    (p : FiniteProbability (Module.Dual K (graphCycles G))) :
    (∑ y : Module.Dual K G.localCycles,
      observedMass p.mass (graphObservation G) y *
      finiteEntropy (conditionalMass p.mass (graphObservation G) y)) ≤
      Real.log (Fintype.card (LinearMap.ker (graphObservation G))) := by
  simpa only [← Nat.card_eq_fintype_card] using
    (linear_conditional_entropy_le_log_kernel p (graphObservation G))

end URF.EntropyBridge


namespace URF.EntropyBridge

/-- One canonical orientation of every undirected edge. -/
def OrderedEdge {V : Type*} [LinearOrder V] (G : SimpleGraph V) :=
  {e : V × V // e.1 < e.2 ∧ G.Adj e.1 e.2}

/-- Explicit finiteness via the subtype's injection into vertex pairs. -/
theorem orderedEdge_finite
    {V : Type*} [LinearOrder V] [Fintype V] (G : SimpleGraph V) :
    Finite (OrderedEdge G) := by
  classical
  exact Finite.of_injective (fun e : OrderedEdge G => e.val)
    (by intro a b h; exact Subtype.ext h)

noncomputable instance orderedEdgeFintype
    {V : Type*} [LinearOrder V] [Fintype V] (G : SimpleGraph V) :
    Fintype (OrderedEdge G) := by
  letI : Finite (OrderedEdge G) := orderedEdge_finite G
  exact Fintype.ofFinite (OrderedEdge G)

/-- The matrix coefficient is -1 at the initial vertex and +1 at
    the terminal vertex of an oriented edge. -/
noncomputable def simpleGraphIncidence
    {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) : Matrix V (OrderedEdge G) K :=
  fun v e =>
    if v = e.val.1 then -1 else if v = e.val.2 then 1 else 0

/-- Concrete graph boundary, obtained from the oriented incidence matrix. -/
noncomputable def simpleGraphBoundary
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) :
    (OrderedEdge G → K) →ₗ[K] (V → K) := by
  classical
  exact (simpleGraphIncidence (K := K) G).mulVecLin

/-- Bounded-support cycle space: spans all cycles with at most `cutoff`
nonzero edge coefficients. This is support-locality, not radius-locality. -/
noncomputable def boundedSupportCycleSpace
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (cutoff : ℕ) :
    Subspace K (LinearMap.ker (simpleGraphBoundary (K := K) G)) := by
  classical
  exact Submodule.span K
    {z | (Finset.univ.filter (fun e : OrderedEdge G => z.val e ≠ 0)).card ≤ cutoff}

/-- Concrete incidence and bounded-support subspace instantiate the
previously verified abstract graph-chain presentation. -/
noncomputable def concreteGraphChain
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (cutoff : ℕ) :
    GraphChainPresentation K V (OrderedEdge G) := by
  classical
  exact {
    boundary := simpleGraphBoundary (K := K) G
    localCycles := boundedSupportCycleSpace (K := K) G cutoff
  }

/-- Actual graph-cycle restriction has the correct hidden dimension. -/
theorem concreteGraph_hidden_finrank
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (cutoff : ℕ) :
    Module.finrank K
      (LinearMap.ker (graphObservation (concreteGraphChain (K := K) G cutoff))) =
      Module.finrank K (graphCycles (concreteGraphChain (K := K) G cutoff)) -
        Module.finrank K (concreteGraphChain (K := K) G cutoff).localCycles := by
  exact graphObservation_hidden_finrank (concreteGraphChain (K := K) G cutoff)

/-- Uniform input distribution on a nonempty finite type. -/
noncomputable def uniformFiniteProbability
    (α : Type*) [Fintype α] [Nonempty α] : FiniteProbability α := by
  classical
  let n : ℝ := Fintype.card α
  have hn : n ≠ 0 := by
    dsimp [n]
    exact_mod_cast Fintype.card_ne_zero
  refine ⟨(fun _ => 1 / n), ?_, ?_⟩
  · intro a
    positivity
  · simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    dsimp [n] at hn ⊢
    field_simp

end URF.EntropyBridge

#print axioms URF.EntropyBridge.orderedEdge_finite
#print axioms URF.EntropyBridge.concreteGraph_hidden_finrank


/-!
SPOKE-ONLY CIRCULATION: MATRIX-ROW REDUCTION CANDIDATE, NOT_RUN.

This separate research candidate makes a precise Lean boundary:
(1) a general algebraic row-isolation lemma, with a proposed proof;
(2) the graph-specific row isolation statement, stated as a Prop rather
    than fabricated as a theorem;
(3) the final graph spoke-only target, stated as a Prop.

The only remaining graph-specific argument is proving that a supported
edge e={v,u} has no competing supported edge in incidence row u, by the
uniqueness of simple-graph edges with endpoints {v,u}.

No admitted theorem, sorry, new axiom, or native_decide is used.
Do NOT claim LEAN_VERIFIED before exact-HEAD compilation.
-/

namespace URF.EntropyBridge

/-- Abstract kernel-vector vanishing from a separating incidence row
for each nonzero coordinate. -/
theorem matrix_zero_of_isolating_rows_candidate
    {R C K : Type*} [Fintype C] [Field K]
    (A : Matrix R C K) (z : C → K)
    (hzero : ∀ r : R, (∑ c : C, A r c * z c) = 0)
    (hisolate : ∀ c : C, z c ≠ 0 →
      ∃ r : R, A r c ≠ 0 ∧
        ∀ d : C, d ≠ c → A r d * z d = 0) :
    z = 0 := by
  classical
  funext c
  by_contra hc
  obtain ⟨r, hdiag, hoff⟩ := hisolate c hc
  have hsingle :
      (∑ d : C, A r d * z d) = A r c * z c := by
    apply Finset.sum_eq_single c
    · intro d hd hdc
      exact hoff d hdc
    · intro hnot
      exact False.elim (hnot (Finset.mem_univ c))
  have hprod : A r c * z c = 0 := by
    have hr := hzero r
    rw [hsingle] at hr
    exact hr
  exact (mul_ne_zero hdiag hc) hprod

/-- The graph-specific row separation assertion still to be
Lean-proved from the exact ordered-edge incidence definition.
It is only a proposition, NOT a verified theorem. -/
def SpokeIsolationTarget
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) : Prop :=
  ∀ z : OrderedEdge G → K,
    (∀ e : OrderedEdge G, z e ≠ 0 →
      e.val.1 = v ∨ e.val.2 = v) →
    ∀ e : OrderedEdge G, z e ≠ 0 →
      ∃ u : V,
        simpleGraphIncidence (K := K) G u e ≠ 0 ∧
        ∀ d : OrderedEdge G, d ≠ e →
          simpleGraphIncidence (K := K) G u d * z d = 0

/-- Final application target, deliberately represented as a proposition
until the row-isolation theorem is compiler-verified. -/
def SpokeOnlyZeroTarget
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) : Prop :=
  ∀ z : OrderedEdge G → K,
    (∀ e : OrderedEdge G, z e ≠ 0 →
      e.val.1 = v ∨ e.val.2 = v) →
    (∀ u : V,
      (∑ e : OrderedEdge G,
        simpleGraphIncidence (K := K) G u e * z e) = 0) →
    z = 0

#print axioms URF.EntropyBridge.matrix_zero_of_isolating_rows_candidate

end URF.EntropyBridge

/-! Complete spoke-only candidate. Compiler verification pending. -/
namespace URF.EntropyBridge

theorem orderedEdge_unique_incident_pair_candidate
    {V : Type*} [LinearOrder V] {G : SimpleGraph V}
    (e d : OrderedEdge G) (v u : V) (hvu : v ≠ u)
    (hev : e.val.1 = v ∨ e.val.2 = v)
    (heu : e.val.1 = u ∨ e.val.2 = u)
    (hdv : d.val.1 = v ∨ d.val.2 = v)
    (hdu : d.val.1 = u ∨ d.val.2 = u) :
    d = e := by
  have he : e.val.1 < e.val.2 := e.property.1
  have hd : d.val.1 < d.val.2 := d.property.1
  apply Subtype.ext
  apply Prod.ext <;> grind

theorem spoke_isolation_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) :
    SpokeIsolationTarget (K := K) G v := by
  classical
  intro z hs e he
  have hlt : e.val.1 < e.val.2 := e.property.1
  have hendpoint : ∃ u : V, v ≠ u ∧
      (e.val.1 = u ∨ e.val.2 = u) := by
    rcases hs e he with h | h
    · refine ⟨e.val.2, ?_, Or.inr rfl⟩
      rw [← h]
      exact ne_of_lt hlt
    · refine ⟨e.val.1, ?_, Or.inl rfl⟩
      rw [← h]
      exact (ne_of_lt hlt).symm
  obtain ⟨u, hvu, heu⟩ := hendpoint
  refine ⟨u, ?_, ?_⟩
  · unfold simpleGraphIncidence
    rcases heu with h | h
    · rw [if_pos h.symm]
      exact neg_ne_zero.mpr one_ne_zero
    · rw [if_neg (by
        intro hh
        exact (ne_of_lt hlt) (hh.symm.trans h.symm)), if_pos h.symm]
      exact one_ne_zero
  · intro d hde
    by_cases hzd : z d = 0
    · simp [hzd]
    · have hdu : ¬ (d.val.1 = u ∨ d.val.2 = u) := by
        intro hdu
        exact hde (orderedEdge_unique_incident_pair_candidate e d v u hvu
          (hs e he) heu (hs d hzd) hdu)
      have h1 : u ≠ d.val.1 := fun h => hdu (Or.inl h.symm)
      have h2 : u ≠ d.val.2 := fun h => hdu (Or.inr h.symm)
      simp [simpleGraphIncidence, h1, h2]

theorem spoke_only_zero_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) :
    SpokeOnlyZeroTarget (K := K) G v := by
  classical
  intro z hs hz
  exact matrix_zero_of_isolating_rows_candidate
    (simpleGraphIncidence (K := K) G) z hz
    (spoke_isolation_candidate (K := K) G v z hs)

theorem simpleGraphBoundary_spoke_zero_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) (z : OrderedEdge G → K)
    (hs : ∀ e, z e ≠ 0 → e.val.1 = v ∨ e.val.2 = v)
    (hz : simpleGraphBoundary (K := K) G z = 0) :
    z = 0 := by
  apply spoke_only_zero_candidate (K := K) G v z hs
  intro u
  have h := congrFun hz u
  change (∑ e : OrderedEdge G,
    simpleGraphIncidence (K := K) G u e * z e) = 0 at h
  exact h

#print axioms URF.EntropyBridge.orderedEdge_unique_incident_pair_candidate
#print axioms URF.EntropyBridge.spoke_isolation_candidate
#print axioms URF.EntropyBridge.spoke_only_zero_candidate
#print axioms URF.EntropyBridge.simpleGraphBoundary_spoke_zero_candidate

end URF.EntropyBridge

/-! Cone elimination stage. NOT_RUN at creation. The hypotheses on the
rim lifts are explicit; their concrete triangle construction is a separate
obligation. No existence of a triangle is assumed without a hypothesis. -/
namespace URF.EntropyBridge

/-- A circulation is determined by its nonspoke coefficients. -/
theorem circulation_eq_of_rim_eq_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) (z w : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (hw : simpleGraphBoundary (K := K) G w = 0)
    (hrim : ∀ e : OrderedEdge G,
      e.val.1 ≠ v → e.val.2 ≠ v → z e = w e) :
    z = w := by
  have hdiff : simpleGraphBoundary (K := K) G (z - w) = 0 := by
    rw [map_sub, hz, hw, sub_zero]
  have hs : ∀ e : OrderedEdge G, (z - w) e ≠ 0 →
      e.val.1 = v ∨ e.val.2 = v := by
    intro e he
    by_contra hn
    push_neg at hn
    apply he
    change z e - w e = 0
    rw [hrim e hn.1 hn.2, sub_self]
  exact sub_eq_zero.mp
    (simpleGraphBoundary_spoke_zero_candidate G v (z - w) hs hdiff)

/-- Constructive rim elimination. Each lift t e is a circulation whose
coefficients on nonspoke edges are the Kronecker delta at e.
Only active nonspoke edges of z require a lift. -/
theorem circulation_rim_decomposition_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (t : OrderedEdge G → (OrderedEdge G → K))
    (ht : ∀ e : OrderedEdge G, e.val.1 ≠ v → e.val.2 ≠ v →
      z e ≠ 0 →
      simpleGraphBoundary (K := K) G (t e) = 0)
    (hdelta : ∀ e : OrderedEdge G, e.val.1 ≠ v → e.val.2 ≠ v →
      z e ≠ 0 → ∀ d : OrderedEdge G, d.val.1 ≠ v → d.val.2 ≠ v →
      t e d = (by classical exact if d = e then 1 else 0)) :
    z = (by
      classical
      exact ∑ e ∈ (Finset.univ.filter (fun e : OrderedEdge G =>
        e.val.1 ≠ v ∧ e.val.2 ≠ v ∧ z e ≠ 0)), z e • t e) := by
  classical
  let S : Finset (OrderedEdge G) := Finset.univ.filter (fun e =>
    e.val.1 ≠ v ∧ e.val.2 ≠ v ∧ z e ≠ 0)
  let w : OrderedEdge G → K := ∑ e ∈ S, z e • t e
  change z = w
  have hmem (e : OrderedEdge G) (he : e ∈ S) :
      e.val.1 ≠ v ∧ e.val.2 ≠ v ∧ z e ≠ 0 := by
    simpa [S] using he
  have hw : simpleGraphBoundary (K := K) G w = 0 := by
    dsimp [w]
    rw [map_sum]
    apply Finset.sum_eq_zero
    intro e he
    obtain ⟨h1, h2, h3⟩ := hmem e he
    rw [map_smul, ht e h1 h2 h3, smul_zero]
  apply circulation_eq_of_rim_eq_candidate G v z w hz hw
  intro d hd1 hd2
  have hwval : w d = ∑ e ∈ S, z e * t e d := by
    simp [w, Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  rw [hwval]
  by_cases hzd : z d = 0
  · rw [hzd]
    symm
    apply Finset.sum_eq_zero
    intro e he
    obtain ⟨h1, h2, h3⟩ := hmem e he
    have hne : d ≠ e := by
      intro h
      exact h3 (by simpa only [← h] using hzd)
    rw [hdelta e h1 h2 h3 d hd1 hd2, if_neg hne, mul_zero]
  · have hdS : d ∈ S := by
      simp [S, hd1, hd2, hzd]
    have hsum : (∑ e ∈ S, z e * t e d) = z d * t d d := by
      apply Finset.sum_eq_single d
      · intro e he hne
        obtain ⟨h1, h2, h3⟩ := hmem e he
        rw [hdelta e h1 h2 h3 d hd1 hd2, if_neg (Ne.symm hne), mul_zero]
      · intro h
        exact False.elim (h hdS)
    rw [hsum, hdelta d hd1 hd2 hzd d hd1 hd2, if_pos rfl, mul_one]

#print axioms URF.EntropyBridge.circulation_eq_of_rim_eq_candidate
#print axioms URF.EntropyBridge.circulation_rim_decomposition_candidate

end URF.EntropyBridge

/-! Concrete signed triangle lifts; compiler audit pending. -/
namespace URF.EntropyBridge

noncomputable def directedEdgeChainCandidate
    {V K : Type*} [LinearOrder V] [Field K]
    {G : SimpleGraph V} (a b : V) : OrderedEdge G → K :=
  fun d => if d.val.1 = a ∧ d.val.2 = b then 1
    else if d.val.1 = b ∧ d.val.2 = a then -1 else 0

/-- An oriented unit edge has the incidence column as its boundary. -/
theorem boundary_unit_edge_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (e : OrderedEdge G) (c : K) (u : V) :
    simpleGraphBoundary (K := K) G
      (fun d => (by classical exact if d = e then c else 0)) u =
      simpleGraphIncidence (K := K) G u e * c := by
  classical
  change (∑ d : OrderedEdge G, simpleGraphIncidence (K := K) G u d *
    (if d = e then c else 0)) = _
  rw [Finset.sum_eq_single e]
  · simp
  · intro d _ h
    simp [h]
  · simp

theorem directed_edge_boundary_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (a b : V) (hab : G.Adj a b) (u : V) :
    simpleGraphBoundary (K := K) G
      (directedEdgeChainCandidate (G := G) a b) u =
      (if u = b then 1 else 0) - (if u = a then 1 else 0) := by
  classical
  have hn : a ≠ b := hab.ne
  rcases lt_or_gt_of_ne hn with hlt | hgt
  · let e : OrderedEdge G := ⟨(a,b), hlt, hab⟩
    have hc : directedEdgeChainCandidate (K := K) (G := G) a b =
        (fun d => if d = e then 1 else 0) := by
      funext d
      have hd : d.val.1 < d.val.2 := d.property.1
      have heq : (d.val.1 = a ∧ d.val.2 = b) ↔ d = e := by
        constructor
        · intro h
          apply Subtype.ext
          exact Prod.ext h.1 h.2
        · intro h
          subst d
          exact ⟨rfl,rfl⟩
      have hrev : ¬ (d.val.1 = b ∧ d.val.2 = a) := by
        intro h
        rw [h.1,h.2] at hd
        exact (not_lt_of_ge hlt.le) hd
      simp [directedEdgeChainCandidate, heq, hrev]
    rw [hc, boundary_unit_edge_candidate]
    change (if u = a then (-1 : K) else if u = b then 1 else 0) * 1 = _
    by_cases ha : u = a <;> by_cases hb : u = b <;> simp_all
  · let e : OrderedEdge G := ⟨(b,a), hgt, hab.symm⟩
    have hc : directedEdgeChainCandidate (K := K) (G := G) a b =
        (fun d => if d = e then -1 else 0) := by
      funext d
      have hd : d.val.1 < d.val.2 := d.property.1
      have heq : (d.val.1 = b ∧ d.val.2 = a) ↔ d = e := by
        constructor
        · intro h
          apply Subtype.ext
          exact Prod.ext h.1 h.2
        · intro h
          subst d
          exact ⟨rfl,rfl⟩
      have hfwd : ¬ (d.val.1 = a ∧ d.val.2 = b) := by
        intro h
        rw [h.1,h.2] at hd
        exact (not_lt_of_ge hgt.le) hd
      simp [directedEdgeChainCandidate, heq, hfwd]
    rw [hc, boundary_unit_edge_candidate]
    change (if u = b then (-1 : K) else if u = a then 1 else 0) * (-1) = _
    by_cases ha : u = a <;> by_cases hb : u = b <;> simp_all

noncomputable def coneTriangleCandidate
    {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (v : V) (e : OrderedEdge G) :
    OrderedEdge G → K :=
  directedEdgeChainCandidate v e.val.1 +
  directedEdgeChainCandidate e.val.1 e.val.2 +
  directedEdgeChainCandidate e.val.2 v

theorem cone_triangle_boundary_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) (e : OrderedEdge G)
    (ha : G.Adj v e.val.1) (hb : G.Adj v e.val.2) :
    simpleGraphBoundary (K := K) G
      (coneTriangleCandidate (K := K) G v e) = 0 := by
  classical
  unfold coneTriangleCandidate
  rw [map_add, map_add]
  funext u
  change simpleGraphBoundary (K := K) G (directedEdgeChainCandidate v e.val.1) u +
    simpleGraphBoundary (K := K) G (directedEdgeChainCandidate e.val.1 e.val.2) u +
    simpleGraphBoundary (K := K) G (directedEdgeChainCandidate e.val.2 v) u = 0
  rw [directed_edge_boundary_candidate G _ _ ha,
      directed_edge_boundary_candidate G _ _ e.property.2,
      directed_edge_boundary_candidate G _ _ hb.symm]
  ring

theorem cone_triangle_rim_delta_candidate
    {V K : Type*} [LinearOrder V] [Field K]
    (G : SimpleGraph V) (v : V) (e d : OrderedEdge G)
    (hd1 : d.val.1 ≠ v) (hd2 : d.val.2 ≠ v) :
    coneTriangleCandidate (K := K) G v e d =
      (by classical exact if d = e then 1 else 0) := by
  classical
  have he : e.val.1 < e.val.2 := e.property.1
  have hd : d.val.1 < d.val.2 := d.property.1
  have hrev : ¬ (d.val.1 = e.val.2 ∧ d.val.2 = e.val.1) := by
    intro h
    rw [h.1,h.2] at hd
    exact (not_lt_of_ge he.le) hd
  have hsame : (d.val.1 = e.val.1 ∧ d.val.2 = e.val.2) ↔ d = e := by
    constructor
    · intro h
      exact Subtype.ext (Prod.ext h.1 h.2)
    · intro h
      subst d
      exact ⟨rfl,rfl⟩
  change directedEdgeChainCandidate (K := K) v e.val.1 d +
    directedEdgeChainCandidate (K := K) e.val.1 e.val.2 d +
    directedEdgeChainCandidate (K := K) e.val.2 v d = _
  simp [directedEdgeChainCandidate, hd1, hd2, hrev, hsame]

/-- Every circulation supported in a closed radius-one ball is a sum
of actual triangle chains. The support hypothesis is stated on active
rim edges: both endpoints must be adjacent to the center. -/
theorem radius_one_triangle_generation_candidate
    {V K : Type*} [LinearOrder V] [Fintype V] [Field K]
    (G : SimpleGraph V) (v : V) (z : OrderedEdge G → K)
    (hz : simpleGraphBoundary (K := K) G z = 0)
    (hball : ∀ e : OrderedEdge G, e.val.1 ≠ v → e.val.2 ≠ v →
      z e ≠ 0 → G.Adj v e.val.1 ∧ G.Adj v e.val.2) :
    z = (by
      classical
      exact ∑ e ∈ (Finset.univ.filter (fun e : OrderedEdge G =>
        e.val.1 ≠ v ∧ e.val.2 ≠ v ∧ z e ≠ 0)),
        z e • coneTriangleCandidate (K := K) G v e) := by
  classical
  apply circulation_rim_decomposition_candidate G v z hz
    (coneTriangleCandidate (K := K) G v)
  · intro e h1 h2 h3
    exact cone_triangle_boundary_candidate G v e
      (hball e h1 h2 h3).1 (hball e h1 h2 h3).2
  · intro e _ _ _ d hd1 hd2
    exact cone_triangle_rim_delta_candidate G v e d hd1 hd2

#print axioms URF.EntropyBridge.boundary_unit_edge_candidate
#print axioms URF.EntropyBridge.directed_edge_boundary_candidate
#print axioms URF.EntropyBridge.cone_triangle_boundary_candidate
#print axioms URF.EntropyBridge.cone_triangle_rim_delta_candidate
#print axioms URF.EntropyBridge.radius_one_triangle_generation_candidate

end URF.EntropyBridge

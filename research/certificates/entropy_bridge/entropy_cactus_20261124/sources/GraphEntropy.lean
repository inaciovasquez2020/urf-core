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

namespace URF.EntropyBridge

theorem finiteEntropy_uniform_eq_log_card_candidate
    (α : Type*) [Fintype α] [Nonempty α] :
    finiteEntropy
      (fun _ : α => (1 : ℝ) / (Fintype.card α : ℝ)) =
      Real.log (Fintype.card α) := by
  classical
  let n : ℝ := Fintype.card α
  have hn : n ≠ 0 := by
    dsimp [n]
    exact_mod_cast
      (Fintype.card_ne_zero : Fintype.card α ≠ 0)
  have hu : (1 : ℝ) / n ≠ 0 :=
    one_div_ne_zero hn
  have hlog : Real.log (1 / n) = -Real.log n := by
    rw [one_div, Real.log_inv]
  change (∑ _ : α, shannonTerm (1 / n)) = Real.log n
  rw [Finset.sum_const]
  simp only [Finset.card_univ, nsmul_eq_mul]
  rw [show shannonTerm (1 / n) =
      -(1 / n * Real.log (1 / n)) by
        simp only [shannonTerm, if_neg hu]]
  rw [hlog]
  calc
    (Fintype.card α : ℝ) * -(1 / n * -Real.log n) =
        (n * (1 / n)) * Real.log n := by
          dsimp [n]
          ring
    _ = Real.log n := by
      field_simp [hn]

end URF.EntropyBridge

#print axioms URF.EntropyBridge.finiteEntropy_uniform_eq_log_card_candidate

namespace URF.EntropyBridge

/-- Exact probability of observing a fiber under a uniform input. -/
theorem observedMass_uniform_eq_fiber_card
    {Q W : Type*} [Fintype Q]
    (f : Q → W) (y : W) :
    observedMass
      (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ))
      f y =
    (Nat.card {x : Q // f x = y} : ℝ) /
      (Fintype.card Q : ℝ) := by
  classical
  let s : Finset Q := Finset.univ.filter (fun x => f x = y)
  have hmem (x : Q) : x ∈ s ↔ f x = y := by
    simp [s]
  have hsub :
      (∑ x ∈ s, (1 : ℝ) / (Fintype.card Q : ℝ)) =
      ∑ x : {x : Q // f x = y},
        (1 : ℝ) / (Fintype.card Q : ℝ) := by
    simpa using
      (Finset.sum_subtype s hmem
        (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ)))
  have hfilter :
      (∑ x ∈ s, (1 : ℝ) / (Fintype.card Q : ℝ)) =
      ∑ x : Q,
        if f x = y then
          (1 : ℝ) / (Fintype.card Q : ℝ)
        else 0 := by
    simpa only [s] using
      (Finset.sum_filter (s := Finset.univ)
        (p := fun x : Q => f x = y)
        (f := fun _ : Q =>
          (1 : ℝ) / (Fintype.card Q : ℝ)))
  calc
    observedMass
        (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ))
        f y =
      ∑ x : Q,
        if f x = y then
          (1 : ℝ) / (Fintype.card Q : ℝ)
        else 0 := rfl
    _ = ∑ x ∈ s,
          (1 : ℝ) / (Fintype.card Q : ℝ) :=
      hfilter.symm
    _ = ∑ x : {x : Q // f x = y},
          (1 : ℝ) / (Fintype.card Q : ℝ) := hsub
    _ = (Nat.card {x : Q // f x = y} : ℝ) /
          (Fintype.card Q : ℝ) := by
      simp only [Finset.sum_const, Finset.card_univ,
        nsmul_eq_mul, Nat.card_eq_fintype_card,
        div_eq_mul_inv, one_mul]

/-- Linear observations have equal probability on every nonempty fiber. -/
theorem observedMass_uniform_eq_kernel_card
    {K Q W : Type*}
    [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W] [Fintype Q]
    (f : Q →ₗ[K] W) (y : W)
    (x₀ : Q) (hx₀ : f x₀ = y) :
    observedMass
      (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ))
      f y =
    (Nat.card (LinearMap.ker f) : ℝ) /
      (Fintype.card Q : ℝ) := by
  classical
  have hcard :
      Nat.card {x : Q // f x = y} =
        Nat.card (LinearMap.ker f) :=
    Nat.card_congr (linearFiberEquivKer f y x₀ hx₀)
  rw [observedMass_uniform_eq_fiber_card]
  exact congrArg
    (fun n : ℕ => (n : ℝ) / (Fintype.card Q : ℝ))
    hcard

end URF.EntropyBridge

#print axioms URF.EntropyBridge.observedMass_uniform_eq_fiber_card
#print axioms URF.EntropyBridge.observedMass_uniform_eq_kernel_card

namespace URF.EntropyBridge

/-- Uniform input, positive observation fiber: every supported conditional
probability is the reciprocal of that fiber's cardinality. -/
theorem uniform_conditionalMass_of_mem
    {Q W : Type*} [Fintype Q] [Nonempty Q]
    (f : Q → W) (y : W) (x₀ : Q) (hx₀ : f x₀ = y)
    (x : Q) (hx : f x = y) :
    conditionalMass
      (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ))
      f y x =
      (1 : ℝ) / (Nat.card {z : Q // f z = y} : ℝ) := by
  classical
  letI : Nonempty {z : Q // f z = y} := ⟨⟨x₀, hx₀⟩⟩
  have hn : (Fintype.card Q : ℝ) ≠ 0 := by
    exact_mod_cast (Fintype.card_ne_zero : Fintype.card Q ≠ 0)
  have hk : (Nat.card {z : Q // f z = y} : ℝ) ≠ 0 := by
    have hfinite : Finite {z : Q // f z = y} := inferInstance
    have hnonempty : Nonempty {z : Q // f z = y} :=
      ⟨⟨x₀, hx₀⟩⟩
    have hkNat : Nat.card {z : Q // f z = y} ≠ 0 :=
      Nat.card_ne_zero.mpr ⟨hnonempty, hfinite⟩
    exact_mod_cast hkNat
  have hobs := observedMass_uniform_eq_fiber_card f y
  have hobs_ne : observedMass
      (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ)) f y ≠ 0 := by
    rw [hobs]
    exact div_ne_zero hk hn
  simp only [conditionalMass, hx, ↓reduceIte, if_neg hobs_ne]
  rw [hobs]
  field_simp

end URF.EntropyBridge

#print axioms URF.EntropyBridge.uniform_conditionalMass_of_mem

namespace URF.EntropyBridge

/-- Uniform finite linear input induces uniform conditional probabilities
on any nonempty observation fiber. -/
theorem restrictedConditionalMass_uniform_eq
    {K Q W : Type*}
    [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W]
    [Fintype Q] [Nonempty Q]
    (f : Q →ₗ[K] W) (y : W) (x₀ : Q) (hx₀ : f x₀ = y)
    (x : {z : Q // f z = y}) :
    restrictedConditionalMass (uniformFiniteProbability Q) f y x =
      (1 : ℝ) / (Nat.card {z : Q // f z = y} : ℝ) := by
  classical
  change conditionalMass
    (fun _ : Q => (1 : ℝ) / (Fintype.card Q : ℝ))
    f y x.1 = _
  simpa only [Nat.card_eq_fintype_card] using
    (uniform_conditionalMass_of_mem f y x₀ hx₀ x.1 x.property)

/-- Exact Shannon entropy of a nonempty linear observation fiber
under a uniform input. -/
theorem uniform_linear_fiber_entropy_eq_log_card
    {K Q W : Type*}
    [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W]
    [Fintype Q] [Nonempty Q]
    (f : Q →ₗ[K] W) (y : W) (x₀ : Q) (hx₀ : f x₀ = y) :
    finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y) =
      Real.log (Nat.card {z : Q // f z = y}) := by
  classical
  letI : Nonempty {z : Q // f z = y} := ⟨⟨x₀, hx₀⟩⟩
  have hfun :
      restrictedConditionalMass (uniformFiniteProbability Q) f y =
        (fun _ : {z : Q // f z = y} =>
          (1 : ℝ) / (Nat.card {z : Q // f z = y} : ℝ)) := by
    funext x
    exact restrictedConditionalMass_uniform_eq f y x₀ hx₀ x
  calc
    finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y) =
        finiteEntropy (restrictedConditionalMass (uniformFiniteProbability Q) f y) :=
      (restrictedConditionalMass_entropy_eq (uniformFiniteProbability Q) f y).symm
    _ = finiteEntropy (fun _ : {z : Q // f z = y} =>
          (1 : ℝ) / (Nat.card {z : Q // f z = y} : ℝ)) := by rw [hfun]
    _ = Real.log (Nat.card {z : Q // f z = y}) :=
      by
        simpa only [Nat.card_eq_fintype_card] using
          (finiteEntropy_uniform_eq_log_card_candidate
            {z : Q // f z = y})

end URF.EntropyBridge

#print axioms URF.EntropyBridge.restrictedConditionalMass_uniform_eq
#print axioms URF.EntropyBridge.uniform_linear_fiber_entropy_eq_log_card

namespace URF.EntropyBridge

/-- Exact conditional entropy for a uniform input and an arbitrary linear observation. -/
theorem uniform_linear_conditional_entropy_eq_log_kernel
    {K Q W : Type*}
    [Field K] [AddCommGroup Q] [Module K Q]
    [AddCommGroup W] [Module K W]
    [Fintype Q] [Fintype W] [Nonempty Q]
    (f : Q →ₗ[K] W) :
    (∑ y : W, observedMass (uniformFiniteProbability Q).mass f y *
      finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y)) =
      Real.log (Nat.card (LinearMap.ker f)) := by
  classical
  have hpoint (y : W) :
      observedMass (uniformFiniteProbability Q).mass f y *
          finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y) =
        observedMass (uniformFiniteProbability Q).mass f y *
          Real.log (Nat.card (LinearMap.ker f)) := by
    by_cases hy : 0 < observedMass (uniformFiniteProbability Q).mass f y
    · have he : ∃ x₀ : Q, f x₀ = y := by
        by_contra hn
        have hn' : ∀ x : Q, f x ≠ y := by
          simpa only [not_exists] using hn
        have hz : observedMass (uniformFiniteProbability Q).mass f y = 0 := by
          simp [observedMass, hn']
        exact (ne_of_gt hy) hz
      obtain ⟨x₀, hx₀⟩ := he
      have hcard : Nat.card {z : Q // f z = y} =
          Nat.card (LinearMap.ker f) :=
        Nat.card_congr (linearFiberEquivKer f y x₀ hx₀)
      have hent :
          finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y) =
            Real.log (Nat.card (LinearMap.ker f)) := by
        rw [uniform_linear_fiber_entropy_eq_log_card f y x₀ hx₀]
        exact congrArg (fun n : ℕ => Real.log (n : ℝ)) hcard
      rw [hent]
    · have hw : 0 ≤ observedMass (uniformFiniteProbability Q).mass f y := by
        unfold observedMass
        apply Finset.sum_nonneg
        intro x hx
        split_ifs
        · exact (uniformFiniteProbability Q).nonneg x
        · exact le_refl 0
      have hz : observedMass (uniformFiniteProbability Q).mass f y = 0 :=
        le_antisymm (le_of_not_gt hy) hw
      simp [hz]
  calc
    (∑ y : W, observedMass (uniformFiniteProbability Q).mass f y *
      finiteEntropy (conditionalMass (uniformFiniteProbability Q).mass f y)) =
        ∑ y : W, observedMass (uniformFiniteProbability Q).mass f y *
          Real.log (Nat.card (LinearMap.ker f)) := by
            apply Finset.sum_congr rfl
            intro y hy
            exact hpoint y
    _ = Real.log (Nat.card (LinearMap.ker f)) := by
      rw [← Finset.sum_mul, observedMass_sum_one (uniformFiniteProbability Q) f, one_mul]

end URF.EntropyBridge

#print axioms URF.EntropyBridge.uniform_linear_conditional_entropy_eq_log_kernel

namespace URF.EntropyBridge

/-- Exact conditional entropy of a uniform dual graph-cycle observation. -/
theorem graphObservation_uniform_entropy_eq_log_kernel
    {K Vert Edge : Type*}
    [Field K] [Fintype K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge)
    [Fintype (Module.Dual K (graphCycles G))]
    [Nonempty (Module.Dual K (graphCycles G))]
    [Fintype (Module.Dual K G.localCycles)] :
    (∑ y : Module.Dual K G.localCycles,
      observedMass (uniformFiniteProbability (Module.Dual K (graphCycles G))).mass
        (graphObservation G) y *
      finiteEntropy (conditionalMass
        (uniformFiniteProbability (Module.Dual K (graphCycles G))).mass
        (graphObservation G) y)) =
      Real.log (Nat.card (LinearMap.ker (graphObservation G))) := by
  classical
  letI : Nonempty (Module.Dual K (graphCycles G)) := ⟨0⟩
  exact uniform_linear_conditional_entropy_eq_log_kernel (graphObservation G)

end URF.EntropyBridge

#print axioms URF.EntropyBridge.graphObservation_uniform_entropy_eq_log_kernel

namespace URF.EntropyBridge

/-- Exact hidden graph-cycle entropy in field units. -/
theorem graphObservation_uniform_entropy_eq_finrank_gap
    {K Vert Edge : Type*}
    [Field K] [Fintype K] [Fintype Vert] [Fintype Edge]
    (G : GraphChainPresentation K Vert Edge)
    [Fintype (Module.Dual K (graphCycles G))]
    [Nonempty (Module.Dual K (graphCycles G))]
    [Fintype (Module.Dual K G.localCycles)] :
    (∑ y : Module.Dual K G.localCycles,
      observedMass (uniformFiniteProbability (Module.Dual K (graphCycles G))).mass
        (graphObservation G) y *
      finiteEntropy (conditionalMass
        (uniformFiniteProbability (Module.Dual K (graphCycles G))).mass
        (graphObservation G) y)) =
      (Module.finrank K (graphCycles G) - Module.finrank K G.localCycles : ℕ) *
        Real.log (Fintype.card K) := by
  classical
  letI : Nonempty (Module.Dual K (graphCycles G)) := ⟨0⟩
  rw [graphObservation_uniform_entropy_eq_log_kernel]
  have hc : Nat.card (LinearMap.ker (graphObservation G)) =
      Fintype.card K ^ Module.finrank K (LinearMap.ker (graphObservation G)) := by
    rw [Nat.card_eq_fintype_card]
    exact Module.card_eq_pow_finrank
      (K := K)
      (V := LinearMap.ker (graphObservation G))
  calc
    Real.log (Nat.card (LinearMap.ker (graphObservation G)) : ℝ) =
        Real.log ((Fintype.card K : ℝ) ^
          Module.finrank K (LinearMap.ker (graphObservation G))) := by
            rw [← Nat.cast_pow]
            exact congrArg (fun n : ℕ => Real.log (n : ℝ)) hc
    _ = (Module.finrank K (LinearMap.ker (graphObservation G)) : ℝ) *
          Real.log (Fintype.card K) := by rw [Real.log_pow]
    _ = (Module.finrank K (graphCycles G) - Module.finrank K G.localCycles : ℕ) *
          Real.log (Fintype.card K) := by rw [graphObservation_hidden_finrank G]

end URF.EntropyBridge

#print axioms URF.EntropyBridge.graphObservation_uniform_entropy_eq_finrank_gap

import Mathlib

namespace URF.Foundation.AdaptiveProfileAudit

open scoped BigOperators

/-- Error probability for a fixed decision rule; true means class U. -/
noncomputable def decisionRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) (rule : L → Bool) : ℝ :=
  ∑ l, if rule l then (1 - pi) * nu l else pi * mu l

/-- Pointwise optimal finite-transcript error. -/
noncomputable def bayesRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) : ℝ :=
  ∑ l, min (pi * mu l) ((1 - pi) * nu l)

private theorem scale_min (a b x : ℝ) (hx : 0 ≤ x) :
    min (a * x) (b * x) = min a b * x := by
  rcases le_total a b with hab | hba
  · rw [min_eq_left (mul_le_mul_of_nonneg_right hab hx), min_eq_left hab]
  · rw [min_eq_right (mul_le_mul_of_nonneg_right hba hx), min_eq_right hba]

theorem bayesRisk_le_decisionRisk {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) (rule : L → Bool) :
    bayesRisk pi mu nu ≤ decisionRisk pi mu nu rule := by
  unfold bayesRisk decisionRisk
  apply Finset.sum_le_sum
  intro l _
  cases h : rule l
  · simpa [h] using min_le_left (pi * mu l) ((1 - pi) * nu l)
  · simpa [h] using min_le_right (pi * mu l) ((1 - pi) * nu l)

theorem bayesRisk_attained {L : Type*} [Fintype L]
    (pi : ℝ) (mu nu : L → ℝ) :
    ∃ rule : L → Bool, decisionRisk pi mu nu rule = bayesRisk pi mu nu := by
  classical
  refine ⟨fun l => decide ((1 - pi) * nu l ≤ pi * mu l), ?_⟩
  unfold decisionRisk bayesRisk
  apply Finset.sum_congr rfl
  intro l _
  by_cases h : (1 - pi) * nu l ≤ pi * mu l
  · simp [h, min_eq_right h]
  · simp [h, min_eq_left (le_of_not_ge h)]

/-- Every observation with a lower likelihood ratio has at least this error. -/
theorem bayesRisk_ge_likelihood {L : Type*} [Fintype L]
    (pi c : ℝ) (mu nu : L → ℝ)
    (hpi : pi ≤ 1) (hmu : ∀ l, 0 ≤ mu l)
    (hsum : ∑ l, mu l = 1)
    (hbound : ∀ l, c * mu l ≤ nu l) :
    min pi ((1 - pi) * c) ≤ bayesRisk pi mu nu := by
  unfold bayesRisk
  calc
    min pi ((1 - pi) * c) =
        ∑ l, min pi ((1 - pi) * c) * mu l := by
          rw [← Finset.mul_sum, hsum, mul_one]
    _ ≤ ∑ l, min (pi * mu l) ((1 - pi) * nu l) := by
      apply Finset.sum_le_sum
      intro l _
      rw [← scale_min pi ((1 - pi) * c) (mu l) (hmu l)]
      apply min_le_min le_rfl
      calc
        ((1 - pi) * c) * mu l = (1 - pi) * (c * mu l) := by ring
        _ ≤ (1 - pi) * nu l :=
          mul_le_mul_of_nonneg_left (hbound l) (sub_nonneg.mpr hpi)

/-- Fixed maximizing query sets give a constant likelihood ratio on feasible leaves. -/
theorem bayesRisk_eq_of_likelihood {L : Type*} [Fintype L]
    (pi c : ℝ) (mu nu : L → ℝ)
    (hpi : pi ≤ 1) (hmu : ∀ l, 0 ≤ mu l) (hnu : ∀ l, 0 ≤ nu l)
    (hsum : ∑ l, mu l = 1)
    (heq : ∀ l, mu l ≠ 0 → nu l = c * mu l) :
    bayesRisk pi mu nu = min pi ((1 - pi) * c) := by
  unfold bayesRisk
  calc
    (∑ l, min (pi * mu l) ((1 - pi) * nu l)) =
        ∑ l, min pi ((1 - pi) * c) * mu l := by
      apply Finset.sum_congr rfl
      intro l _
      by_cases hz : mu l = 0
      · simp [hz, min_eq_left (mul_nonneg (sub_nonneg.mpr hpi) (hnu l))]
      · rw [heq l hz, ← mul_assoc, scale_min pi ((1 - pi) * c) (mu l) (hmu l)]
    _ = min pi ((1 - pi) * c) := by
      rw [← Finset.mul_sum, hsum, mul_one]

/-- Extract the lower complement likelihood from the uniform-mixture identity. -/
theorem likelihood_of_mixture {L : Type*}
    (a b : ℝ) (mu nu lam : L → ℝ) (hb : b < 1)
    (hmix : ∀ l, lam l = b * mu l + (1 - b) * nu l)
    (hbound : ∀ l, a * mu l ≤ lam l) :
    ∀ l, ((a - b) / (1 - b)) * mu l ≤ nu l := by
  intro l
  have h := (hbound l).trans_eq (hmix l)
  calc
    ((a - b) / (1 - b)) * mu l = ((a - b) * mu l) / (1 - b) := by ring
    _ ≤ nu l := (div_le_iff₀ (sub_pos.mpr hb)).2 (by linarith)

/-- Generic transcript bound: the coordinate-cylinder proof must supply hbound. -/
theorem decisionRisk_ge_mixture_bound {L : Type*} [Fintype L]
    (pi a b : ℝ) (mu nu lam : L → ℝ) (rule : L → Bool)
    (hpi : pi ≤ 1) (hb : b < 1)
    (hmu : ∀ l, 0 ≤ mu l) (hsum : ∑ l, mu l = 1)
    (hmix : ∀ l, lam l = b * mu l + (1 - b) * nu l)
    (hbound : ∀ l, a * mu l ≤ lam l) :
    min pi ((1 - pi) * ((a - b) / (1 - b))) ≤ decisionRisk pi mu nu rule :=
  (bayesRisk_ge_likelihood pi ((a - b) / (1 - b)) mu nu hpi hmu hsum
    (likelihood_of_mixture a b mu nu lam hb hmix hbound)).trans
    (bayesRisk_le_decisionRisk pi mu nu rule)

#print axioms decisionRisk
#print axioms bayesRisk
#print axioms bayesRisk_le_decisionRisk
#print axioms bayesRisk_attained
#print axioms bayesRisk_ge_likelihood
#print axioms bayesRisk_eq_of_likelihood
#print axioms likelihood_of_mixture
#print axioms decisionRisk_ge_mixture_bound


/-- Finite well-founded deterministic adaptive coordinate-query tree.
A leaf terminates; a query chooses the next subtree from the observed value. -/
inductive CoordinateQueryTree (ι : Type u) (A : Type v) : Type (max u v)
  | leaf
  | query (i : ι) (next : A → CoordinateQueryTree ι A)

def queryTrace {ι : Type u} {A : Type v}
    (t : CoordinateQueryTree ι A) (x : ι → A) : List (ι × A) :=
  match t with
  | .leaf => []
  | .query i next => (i, x i) :: queryTrace (next (x i)) x

def traceMatches {ι : Type u} {A : Type v}
    (y : ι → A) (s : List (ι × A)) : Prop :=
  ∀ p ∈ s, y p.1 = p.2

private theorem traceMatches_cons {ι : Type u} {A : Type v}
    (y : ι → A) (p : ι × A) (s : List (ι × A)) :
    traceMatches y (p :: s) ↔ y p.1 = p.2 ∧ traceMatches y s := by
  constructor
  · intro h
    exact ⟨h p (by simp), fun q hq => h q (List.mem_cons_of_mem _ hq)⟩
  · rintro ⟨hp, hs⟩ q hq
    rcases List.mem_cons.mp hq with he | he
    · subst q
      exact hp
    · exact hs q he

/-- A realized full transcript is precisely its cylinder of coordinate-value constraints. -/
theorem queryTrace_eq_iff_matches {ι : Type u} {A : Type v}
    (t : CoordinateQueryTree ι A) (x y : ι → A) :
    queryTrace t y = queryTrace t x ↔ traceMatches y (queryTrace t x) := by
  induction t with
  | leaf => simp [queryTrace, traceMatches]
  | query i next ih =>
    change (i, y i) :: queryTrace (next (y i)) y =
        (i, x i) :: queryTrace (next (x i)) x ↔
      traceMatches y ((i, x i) :: queryTrace (next (x i)) x)
    rw [traceMatches_cons]
    constructor
    · intro h
      have hv : y i = x i := congrArg Prod.snd (List.cons.inj h).1
      refine ⟨hv, (ih (x i)).mp ?_⟩
      have ht := (List.cons.inj h).2
      simpa only [hv] using ht
    · rintro ⟨hv, ht⟩
      have he := (ih (x i)).mpr ht
      rw [hv, he]

def queriedCoordinates {ι : Type u} {A : Type v} [DecidableEq ι]
    (t : CoordinateQueryTree ι A) (x : ι → A) : Finset ι :=
  ((queryTrace t x).map Prod.fst).toFinset

theorem queryTrace_eq_iff_agreeCoordinates {ι : Type u} {A : Type v} [DecidableEq ι]
    (t : CoordinateQueryTree ι A) (x y : ι → A) :
    queryTrace t y = queryTrace t x ↔
      ∀ i ∈ queriedCoordinates t x, y i = x i := by
  rw [queryTrace_eq_iff_matches]
  have hown := (queryTrace_eq_iff_matches t x x).mp rfl
  constructor
  · intro h i hi
    have hm : i ∈ (queryTrace t x).map Prod.fst := by
      simpa only [queriedCoordinates, List.mem_toFinset] using hi
    obtain ⟨p, hp, hpi⟩ := List.mem_map.mp hm
    rw [← hpi]
    exact (h p hp).trans (hown p hp).symm
  · intro h p hp
    have hi : p.1 ∈ queriedCoordinates t x := by
      simp only [queriedCoordinates, List.mem_toFinset, List.mem_map]
      exact ⟨p, hp, rfl⟩
    exact (h p.1 hi).trans (hown p hp)

theorem queriedCoordinates_card_le_trace_length {ι : Type u} {A : Type v} [DecidableEq ι]
    (t : CoordinateQueryTree ι A) (x : ι → A) :
    (queriedCoordinates t x).card ≤ (queryTrace t x).length := by
  unfold queriedCoordinates
  simpa only [List.length_map] using ((queryTrace t x).map Prod.fst).toFinset_card_le

theorem queriedCoordinates_card_le_budget {ι : Type u} {A : Type v} [DecidableEq ι]
    (t : CoordinateQueryTree ι A) (k : ℕ)
    (hbudget : ∀ x, (queryTrace t x).length ≤ k) (x : ι → A) :
    (queriedCoordinates t x).card ≤ k :=
  (queriedCoordinates_card_le_trace_length t x).trans (hbudget x)

def fixedQueries {ι : Type u} {A : Type v} (coords : List ι) :
    CoordinateQueryTree ι A :=
  match coords with
  | [] => .leaf
  | i :: is => .query i (fun _ => fixedQueries is)

theorem fixedQueries_trace_coordinates {ι : Type u} {A : Type v}
    (coords : List ι) (x : ι → A) :
    (queryTrace (fixedQueries (A := A) coords) x).map Prod.fst = coords := by
  induction coords with
  | nil => rfl
  | cons i is ih => simp [fixedQueries, queryTrace, ih]

theorem fixedQueries_trace_length {ι : Type u} {A : Type v}
    (coords : List ι) (x : ι → A) :
    (queryTrace (fixedQueries (A := A) coords) x).length = coords.length := by
  have h := congrArg List.length (fixedQueries_trace_coordinates coords x)
  simpa only [List.length_map] using h

theorem fixedQueries_support {ι : Type u} {A : Type v} [DecidableEq ι]
    (coords : List ι) (x : ι → A) :
    queriedCoordinates (fixedQueries (A := A) coords) x = coords.toFinset := by
  unfold queriedCoordinates
  rw [fixedQueries_trace_coordinates]

#print axioms CoordinateQueryTree
#print axioms queryTrace
#print axioms traceMatches
#print axioms queryTrace_eq_iff_matches
#print axioms queriedCoordinates
#print axioms queryTrace_eq_iff_agreeCoordinates
#print axioms queriedCoordinates_card_le_trace_length
#print axioms queriedCoordinates_card_le_budget
#print axioms fixedQueries
#print axioms fixedQueries_trace_coordinates
#print axioms fixedQueries_trace_length
#print axioms fixedQueries_support


/-- A nonempty linear fiber is a translate of the kernel. -/
def linearFiberEquivKer {K M N : Type*}
    [Field K] [AddCommGroup M] [Module K M]
    [AddCommGroup N] [Module K N]
    (f : M →ₗ[K] N) (x₀ : M) :
    {x : M // f x = f x₀} ≃ LinearMap.ker f where
  toFun x := ⟨x.1 - x₀, by
    rw [LinearMap.mem_ker, map_sub, x.2, sub_self]⟩
  invFun z := ⟨z.1 + x₀, by
    rw [map_add, LinearMap.mem_ker.mp z.2, zero_add]⟩
  left_inv x := by
    apply Subtype.ext
    exact sub_add_cancel x.1 x₀
  right_inv z := by
    apply Subtype.ext
    exact add_sub_cancel_right z.1 x₀

theorem finiteVectorSpace_card_pow (K M : Type*)
    [Field K] [Finite K] [AddCommGroup M] [Module K M]
    [FiniteDimensional K M] :
    Nat.card M = Nat.card K ^ Module.finrank K M := by
  classical
  calc
    Nat.card M = Nat.card (Fin (Module.finrank K M) → K) :=
      Nat.card_congr (Module.finBasis K M).equivFun.toEquiv
    _ = Nat.card K ^ Module.finrank K M := by simp [Nat.card_fun]

theorem linearFiber_card_mul_range {K M N : Type*}
    [Field K] [Finite K] [AddCommGroup M] [Module K M]
    [AddCommGroup N] [Module K N]
    [FiniteDimensional K M] [FiniteDimensional K N]
    (f : M →ₗ[K] N) (x₀ : M) :
    Nat.card {x : M // f x = f x₀} * Nat.card (LinearMap.range f) =
      Nat.card M := by
  rw [Nat.card_congr (linearFiberEquivKer f x₀),
    finiteVectorSpace_card_pow K (LinearMap.ker f),
    finiteVectorSpace_card_pow K (LinearMap.range f),
    finiteVectorSpace_card_pow K M, ← pow_add,
    add_comm (Module.finrank K (LinearMap.ker f)),
    f.finrank_range_add_finrank_ker]

/-- Exact coordinate restriction, with no assumptions on the input subspace. -/
def coordinateProjection (K : Type*) [Field K] {ι : Type*}
    (S : Finset ι) : (ι → K) →ₗ[K] (S → K) where
  toFun x i := x i.1
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

theorem coordinateProjection_surjective (K : Type*) [Field K] {ι : Type*}
    (S : Finset ι) : Function.Surjective (coordinateProjection K S) := by
  classical
  intro y
  refine ⟨fun i => if h : i ∈ S then y ⟨i,h⟩ else 0, ?_⟩
  funext i
  change (if h : i.1 ∈ S then y ⟨i.1,h⟩ else 0) = y i
  simp [i.2]

/-- The codimension of the projected subspace equals its dual-annihilator dimension. -/
theorem projectedRange_card_mul_dual_pow {K N : Type*}
    [Field K] [Finite K] [AddCommGroup N] [Module K N]
    [FiniteDimensional K N] (W : Submodule K N) :
    Nat.card W * Nat.card K ^ Module.finrank K W.dualAnnihilator =
      Nat.card N := by
  rw [finiteVectorSpace_card_pow K W, ← pow_add,
    Subspace.finrank_add_finrank_dualAnnihilator_eq W,
    ← finiteVectorSpace_card_pow K N]

/-- Exact integer cross-multiplication identity for the uniform law on a
subspace restricted to coordinates, on every feasible observation. -/
theorem coordinateFiber_count_identity {K ι : Type*}
    [Field K] [Finite K] [Fintype ι]
    (U : Submodule K (ι → K)) (S : Finset ι) (x₀ : U) :
    Nat.card {x : U // coordinateProjection K S x.1 =
        coordinateProjection K S x₀.1} *
      Nat.card (LinearMap.range ((coordinateProjection K S).comp U.subtype)) =
      Nat.card U := by
  exact linearFiber_card_mul_range ((coordinateProjection K S).comp U.subtype) x₀

#print axioms linearFiberEquivKer
#print axioms finiteVectorSpace_card_pow
#print axioms linearFiber_card_mul_range
#print axioms coordinateProjection
#print axioms coordinateProjection_surjective
#print axioms projectedRange_card_mul_dual_pow
#print axioms coordinateFiber_count_identity


/-- Ambient dual functionals that annihilate U and factor through S. -/
def supportedDual (K : Type*) [Field K] {ι : Type*}
    (U : Submodule K (ι → K)) (S : Finset ι) :
    Submodule K (Module.Dual K (ι → K)) :=
  U.dualAnnihilator ⊓ (LinearMap.ker (coordinateProjection K S)).dualAnnihilator

/-- Pullback identifies the annihilator of the projected image with the
ambient dual functionals supported on the observed coordinates. -/
theorem projectedAnnihilator_map_eq_supportedDual
    {K ι : Type*} [Field K] (U : Submodule K (ι → K)) (S : Finset ι) :
    (LinearMap.range ((coordinateProjection K S).comp U.subtype)).dualAnnihilator.map
        (coordinateProjection K S).dualMap = supportedDual K U S := by
  let p := coordinateProjection K S
  let W := LinearMap.range (p.comp U.subtype)
  change W.dualAnnihilator.map p.dualMap =
    U.dualAnnihilator ⊓ (LinearMap.ker p).dualAnnihilator
  ext φ
  rw [Submodule.mem_map, Submodule.mem_inf]
  constructor
  · rintro ⟨ψ, hψ, rfl⟩
    constructor
    · apply (Submodule.mem_dualAnnihilator _).2
      intro x hx
      change ψ (p x) = 0
      exact (Submodule.mem_dualAnnihilator ψ).1 hψ (p x)
        (LinearMap.mem_range.mpr ⟨⟨x,hx⟩, rfl⟩)
    · apply (Submodule.mem_dualAnnihilator _).2
      intro x hx
      change ψ (p x) = 0
      rw [LinearMap.mem_ker.mp hx, map_zero]
  · rintro ⟨hU, hker⟩
    have hmem : φ ∈ LinearMap.range p.dualMap := by
      rw [LinearMap.range_dualMap_eq_dualAnnihilator_ker]
      exact hker
    obtain ⟨ψ, hψ⟩ := LinearMap.mem_range.mp hmem
    refine ⟨ψ, ?_, hψ⟩
    apply (Submodule.mem_dualAnnihilator _).2
    intro y hy
    obtain ⟨x, hx⟩ := LinearMap.mem_range.mp hy
    rw [← hx]
    change ψ (p x.1) = 0
    change p.dualMap ψ x.1 = 0
    rw [hψ]
    exact (Submodule.mem_dualAnnihilator φ).1 hU x.1 x.2

theorem projectedAnnihilator_finrank_eq_supportedDual
    {K ι : Type*} [Field K] [Fintype ι]
    (U : Submodule K (ι → K)) (S : Finset ι) :
    Module.finrank K
        (LinearMap.range ((coordinateProjection K S).comp U.subtype)).dualAnnihilator =
      Module.finrank K (supportedDual K U S) := by
  have h := (Submodule.equivMapOfInjective (coordinateProjection K S).dualMap
    (LinearMap.dualMap_injective_of_surjective (coordinateProjection_surjective K S))
    (LinearMap.range ((coordinateProjection K S).comp U.subtype)).dualAnnihilator).finrank_eq
  rw [projectedAnnihilator_map_eq_supportedDual U S] at h
  exact h

/-- A functional vanishing on the projection kernel depends only on S. -/
theorem supportedDual_agree {K ι : Type*} [Field K]
    (U : Submodule K (ι → K)) (S : Finset ι)
    (φ : Module.Dual K (ι → K)) (hφ : φ ∈ supportedDual K U S)
    (x y : ι → K) (hxy : ∀ i ∈ S, x i = y i) :
    φ x = φ y := by
  have hker : φ ∈ (LinearMap.ker (coordinateProjection K S)).dualAnnihilator :=
    (Submodule.mem_inf.mp hφ).2
  have heq : coordinateProjection K S x = coordinateProjection K S y := by
    funext i
    exact hxy i.1 i.2
  have hmem : x - y ∈ LinearMap.ker (coordinateProjection K S) := by
    rw [LinearMap.mem_ker, map_sub, heq, sub_self]
  have hzero := (Submodule.mem_dualAnnihilator φ).1 hker (x - y) hmem
  rw [map_sub, sub_eq_zero] at hzero
  exact hzero

#print axioms supportedDual
#print axioms projectedAnnihilator_map_eq_supportedDual
#print axioms projectedAnnihilator_finrank_eq_supportedDual
#print axioms supportedDual_agree


/-- Pushforward of a uniform finite input law, defined by actual fiber counts. -/
noncomputable def uniformObservationMass {M L : Type*}
    (g : M → L) (l : L) : ℝ :=
  (Nat.card {x : M // g x = l} : ℝ) / (Nat.card M : ℝ)

theorem uniformObservationMass_linear {K M N : Type*}
    [Field K] [Finite K] [AddCommGroup M] [Module K M]
    [AddCommGroup N] [Module K N]
    [FiniteDimensional K M] [FiniteDimensional K N]
    (f : M →ₗ[K] N) (x₀ : M) :
    uniformObservationMass f (f x₀) =
      1 / (Nat.card (LinearMap.range f) : ℝ) := by
  have hK : Nat.card K ≠ 0 := Nat.ne_of_gt Nat.card_pos
  have hM : (Nat.card M : ℝ) ≠ 0 := by
    have h : Nat.card M ≠ 0 := by
      rw [finiteVectorSpace_card_pow K M]
      exact pow_ne_zero _ hK
    exact_mod_cast h
  have hR : (Nat.card (LinearMap.range f) : ℝ) ≠ 0 := by
    have h : Nat.card (LinearMap.range f) ≠ 0 := by
      rw [finiteVectorSpace_card_pow K (LinearMap.range f)]
      exact pow_ne_zero _ hK
    exact_mod_cast h
  unfold uniformObservationMass
  apply (div_eq_div_iff hM hR).2
  rw [one_mul]
  exact_mod_cast linearFiber_card_mul_range f x₀

/-- The transcript fiber and its coordinate-projection fiber are equivalent,
even for inputs restricted to an arbitrary domain M. -/
def queryTraceFiberEquivProjection {K ι M : Type*}
    [Field K] [DecidableEq ι]
    (t : CoordinateQueryTree ι K) (g : M → (ι → K)) (x₀ : M) :
    {x : M // queryTrace t (g x) = queryTrace t (g x₀)} ≃
      {x : M // coordinateProjection K (queriedCoordinates t (g x₀)) (g x) =
        coordinateProjection K (queriedCoordinates t (g x₀)) (g x₀)} where
  toFun x := ⟨x.1, by
    funext i
    exact (queryTrace_eq_iff_agreeCoordinates t (g x₀) (g x.1)).mp x.2 i.1 i.2⟩
  invFun x := ⟨x.1, by
    apply (queryTrace_eq_iff_agreeCoordinates t (g x₀) (g x.1)).mpr
    intro i hi
    exact congrFun x.2 ⟨i,hi⟩⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem uniformTraceMass_eq_projectionMass {K ι M : Type*}
    [Field K] [DecidableEq ι]
    (t : CoordinateQueryTree ι K) (g : M → (ι → K)) (x₀ : M) :
    uniformObservationMass (fun x => queryTrace t (g x)) (queryTrace t (g x₀)) =
      uniformObservationMass
        (fun x => coordinateProjection K (queriedCoordinates t (g x₀)) (g x))
        (coordinateProjection K (queriedCoordinates t (g x₀)) (g x₀)) := by
  unfold uniformObservationMass
  rw [Nat.card_congr (queryTraceFiberEquivProjection t g x₀)]

theorem uniformCoordinateMass_ambient {K ι : Type*}
    [Field K] [Finite K] [Fintype ι]
    (S : Finset ι) (x : ι → K) :
    uniformObservationMass (coordinateProjection K S) (coordinateProjection K S x) =
      1 / (Nat.card (S → K) : ℝ) := by
  have h := uniformObservationMass_linear (coordinateProjection K S) x
  have hc : Nat.card (LinearMap.range (coordinateProjection K S)) =
      Nat.card (S → K) :=
    Nat.card_congr (LinearEquiv.ofTop _ (LinearMap.range_eq_top.mpr
      (coordinateProjection_surjective K S))).toEquiv
  rw [hc] at h
  exact h

/-- Exact feasible-leaf likelihood ratio for actual adaptive coordinate queries. -/
theorem uniformTraceMass_feasible_ratio {K ι : Type*}
    [Field K] [Finite K] [Fintype ι] [DecidableEq ι]
    (U : Submodule K (ι → K)) (t : CoordinateQueryTree ι K) (x₀ : U) :
    uniformObservationMass (queryTrace t) (queryTrace t x₀.1) =
      uniformObservationMass (fun x : U => queryTrace t x.1) (queryTrace t x₀.1) /
        (Nat.card K : ℝ) ^
          Module.finrank K (supportedDual K U (queriedCoordinates t x₀.1)) := by
  let S := queriedCoordinates t x₀.1
  let p := coordinateProjection K S
  let W := LinearMap.range (p.comp U.subtype)
  have ha : uniformObservationMass (queryTrace t) (queryTrace t x₀.1) =
      1 / (Nat.card (S → K) : ℝ) := by
    rw [show uniformObservationMass (queryTrace t) (queryTrace t x₀.1) =
      uniformObservationMass p (p x₀.1) from
        uniformTraceMass_eq_projectionMass t (fun x : ι → K => x) x₀.1]
    exact uniformCoordinateMass_ambient S x₀.1
  have hu : uniformObservationMass (fun x : U => queryTrace t x.1) (queryTrace t x₀.1) =
      1 / (Nat.card W : ℝ) := by
    rw [show uniformObservationMass (fun x : U => queryTrace t x.1) (queryTrace t x₀.1) =
      uniformObservationMass (p.comp U.subtype) ((p.comp U.subtype) x₀) from
        uniformTraceMass_eq_projectionMass t (fun x : U => x.1) x₀]
    exact uniformObservationMass_linear (p.comp U.subtype) x₀
  have hc : Nat.card W * Nat.card K ^ Module.finrank K (supportedDual K U S) =
      Nat.card (S → K) := by
    have h := projectedRange_card_mul_dual_pow W
    rw [show Module.finrank K W.dualAnnihilator =
      Module.finrank K (supportedDual K U S) from
        projectedAnnihilator_finrank_eq_supportedDual U S] at h
    exact h
  have hcR : (Nat.card W : ℝ) * (Nat.card K : ℝ) ^
      Module.finrank K (supportedDual K U S) = (Nat.card (S → K) : ℝ) := by
    exact_mod_cast hc
  change _ = _ / (Nat.card K : ℝ) ^ Module.finrank K (supportedDual K U S)
  rw [ha, hu, ← hcR, div_div]

#print axioms uniformObservationMass
#print axioms uniformObservationMass_linear
#print axioms queryTraceFiberEquivProjection
#print axioms uniformTraceMass_eq_projectionMass
#print axioms uniformCoordinateMass_ambient
#print axioms uniformTraceMass_feasible_ratio


theorem uniformObservationMass_nonneg {M L : Type*} (g : M → L) (l : L) :
    0 ≤ uniformObservationMass g l := by
  unfold uniformObservationMass
  positivity

theorem uniformObservationMass_eq_zero_of_not_realized {M L : Type*}
    (g : M → L) (l : L) (h : ∀ x, g x ≠ l) :
    uniformObservationMass g l = 0 := by
  letI : IsEmpty {x : M // g x = l} := ⟨fun x => h x.1 x.2⟩
  simp [uniformObservationMass, Nat.card_of_isEmpty]

/-- The uniform observation law is normalized on any finite observation type. -/
theorem uniformObservationMass_sum_one {M L : Type*}
    [Finite M] [Nonempty M] [Fintype L] (g : M → L) :
    ∑ l, uniformObservationMass g l = 1 := by
  classical
  letI := Fintype.ofFinite M
  have hcard : (∑ l : L, Nat.card {x : M // g x = l}) = Nat.card M := by
    simp_rw [Nat.card_eq_fintype_card, Fintype.card_subtype]
    simpa using Finset.sum_card_fiberwise_eq_card_filter
      (Finset.univ : Finset M) (Finset.univ : Finset L) g
  have hcast : (∑ l : L, (Nat.card {x : M // g x = l} : ℝ)) =
      (Nat.card M : ℝ) := by exact_mod_cast hcard
  have hM : (Nat.card M : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt (Nat.card_pos (α := M)))
  unfold uniformObservationMass
  rw [← Finset.sum_div, hcast, div_self hM]

/-- Explicit equivalence between a partitioned observation fiber and
the unpartitioned fiber; this makes the mixture identity a count, not an assumption. -/
noncomputable def partitionFiberEquiv {M L : Type*} (P : M → Prop)
    (g : M → L) (l : L) :
    ({x : {m : M // P m} // g x.1 = l} ⊕
      {x : {m : M // ¬ P m} // g x.1 = l}) ≃ {m : M // g m = l} := by
  classical
  refine
    { toFun := fun s => match s with
        | .inl x => ⟨x.1.1,x.2⟩
        | .inr x => ⟨x.1.1,x.2⟩
      invFun := fun x => if h : P x.1 then
        .inl ⟨⟨x.1,h⟩,x.2⟩ else .inr ⟨⟨x.1,h⟩,x.2⟩
      left_inv := ?_
      right_inv := ?_ }
  · intro x
    cases x with
    | inl x => simp [x.1.2]
    | inr x => simp [x.1.2]
  · intro x
    dsimp
    split <;> rfl

theorem partitionFiber_card {M L : Type*} [Finite M]
    (P : M → Prop) (g : M → L) (l : L) :
    Nat.card {x : {m : M // P m} // g x.1 = l} +
      Nat.card {x : {m : M // ¬ P m} // g x.1 = l} =
        Nat.card {m : M // g m = l} := by
  rw [← Nat.card_sum, Nat.card_congr (partitionFiberEquiv P g l)]

theorem partitionDomain_card {M : Type*} [Finite M] (P : M → Prop) :
    Nat.card {m : M // P m} + Nat.card {m : M // ¬ P m} = Nat.card M := by
  classical
  rw [← Nat.card_sum, Nat.card_congr (Equiv.sumCompl P)]

/-- Uniform ambient mass is the exact cardinality-weighted mixture of
the uniform class and its uniform complement. Both classes must be nonempty. -/
theorem uniformObservationMass_partition {M L : Type*} [Finite M] [Nonempty M]
    (P : M → Prop) [Nonempty {m : M // P m}] [Nonempty {m : M // ¬ P m}]
    (g : M → L) (l : L) :
    uniformObservationMass g l =
      ((Nat.card {m : M // P m} : ℝ) / (Nat.card M : ℝ)) *
        uniformObservationMass (fun x : {m : M // P m} => g x.1) l +
      (1 - (Nat.card {m : M // P m} : ℝ) / (Nat.card M : ℝ)) *
        uniformObservationMass (fun x : {m : M // ¬ P m} => g x.1) l := by
  have hM : (Nat.card M : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt (Nat.card_pos (α := M)))
  have hP : (Nat.card {m : M // P m} : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt (Nat.card_pos (α := {m : M // P m})))
  have hC : (Nat.card {m : M // ¬ P m} : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt (Nat.card_pos (α := {m : M // ¬ P m})))
  have hd : (Nat.card {m : M // P m} : ℝ) +
      (Nat.card {m : M // ¬ P m} : ℝ) = (Nat.card M : ℝ) := by
    exact_mod_cast partitionDomain_card P
  have hf : (Nat.card {x : {m : M // P m} // g x.1 = l} : ℝ) +
      (Nat.card {x : {m : M // ¬ P m} // g x.1 = l} : ℝ) =
        (Nat.card {m : M // g m = l} : ℝ) := by
    exact_mod_cast partitionFiber_card P g l
  unfold uniformObservationMass
  rw [← hf]
  have hweight : 1 - (Nat.card {m : M // P m} : ℝ) / (Nat.card M : ℝ) =
      (Nat.card {m : M // ¬ P m} : ℝ) / (Nat.card M : ℝ) := by
    field_simp
    linarith
  rw [hweight]
  field_simp
  <;> ring

#print axioms uniformObservationMass_nonneg
#print axioms uniformObservationMass_eq_zero_of_not_realized
#print axioms uniformObservationMass_sum_one
#print axioms partitionFiberEquiv
#print axioms partitionFiber_card
#print axioms partitionDomain_card
#print axioms uniformObservationMass_partition

end URF.Foundation.AdaptiveProfileAudit

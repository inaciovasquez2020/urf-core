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

end URF.Foundation.AdaptiveProfileAudit

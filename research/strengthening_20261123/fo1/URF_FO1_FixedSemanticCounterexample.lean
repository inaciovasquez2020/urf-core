import Init

/-!
A fixed, non-vacuous interpretation of one-variable first-order logic over
nonempty loopless graphs with edge and equality as the only relation symbols.
No Mathlib, axioms, sorry, admit, opaque, or native_decide.

This is an isolated mathematical certificate candidate, NOT a replacement for
URF.H1Locality and NOT a proof of the intended FO^k locality theorem.

Status: NOT_RUN (requires a Lean 4.27.0 compilation and #print axioms).
The semantics is intentionally stated explicitly rather than chosen by a
witness to an existential interface.
-/

namespace URF.FixedFO1

/-- Standard FO with a *single reusable variable*: the only possible
atomic edge formula is `E(x,x)`. This covers FO¹ over the graph language
{edge, equality}, with no constants or unary colors. -/
inductive Formula where
  | eqSelf
  | edgeSelf
  | neg (p : Formula)
  | conj (p q : Formula)
  | quant (p : Formula)
  deriving Repr

/-- The quantifier rebinds the only available variable. -/
def sat {V : Type} (E : V → V → Prop) (v : V) : Formula → Prop
  | .eqSelf => v = v
  | .edgeSelf => E v v
  | .neg p => ¬ sat E v p
  | .conj p q => sat E v p ∧ sat E v q
  | .quant p => ∃ w : V, sat E w p

/-- Diagonal agreement is sufficient for agreement on *all* FO¹ formulas.
In particular FO¹ cannot see any off-diagonal edge. -/
theorem sat_diagonal_invariant {V : Type}
    (E F : V → V → Prop)
    (h : ∀ v : V, E v v ↔ F v v) :
    ∀ (p : Formula) (v : V), sat E v p ↔ sat F v p := by
  intro p
  induction p with
  | eqSelf =>
      intro v
      rfl
  | edgeSelf =>
      intro v
      exact h v
  | neg p ih =>
      intro v
      change (¬ sat E v p) ↔ (¬ sat F v p)
      exact not_congr (ih v)
  | conj p q ihp ihq =>
      intro v
      change (sat E v p ∧ sat E v q) ↔ (sat F v p ∧ sat F v q)
      exact and_congr (ihp v) (ihq v)
  | quant p ih =>
      intro v
      change (∃ w : V, sat E w p) ↔ (∃ w : V, sat F w p)
      constructor
      · intro hx
        cases hx with
        | intro w hw => exact ⟨w, (ih w).mp hw⟩
      · intro hx
        cases hx with
        | intro w hw => exact ⟨w, (ih w).mpr hw⟩

/-- All vertices of any loopless graph have the same FO¹ type, even
without vertex transitivity. -/
theorem sat_vertex_invariant_of_irreflexive {V : Type}
    (E : V → V → Prop) (h : ∀ v : V, ¬ E v v) :
    ∀ (p : Formula) (x y : V), sat E x p ↔ sat E y p := by
  intro p
  induction p with
  | eqSelf =>
      intro x y
      change (x = x) ↔ (y = y)
      exact ⟨(fun _ => rfl), (fun _ => rfl)⟩
  | edgeSelf =>
      intro x y
      change E x x ↔ E y y
      constructor
      · intro hx
        exact False.elim (h x hx)
      · intro hy
        exact False.elim (h y hy)
  | neg p ih =>
      intro x y
      change (¬ sat E x p) ↔ (¬ sat E y p)
      exact not_congr (ih x y)
  | conj p q ihp ihq =>
      intro x y
      change (sat E x p ∧ sat E x q) ↔ (sat E y p ∧ sat E y q)
      exact and_congr (ihp x y) (ihq x y)
  | quant p ih =>
      intro x y
      rfl

abbrev V4 := Fin 4
abbrev Graph4 := V4 → V4 → Prop

def complete : Graph4 := fun u v => u ≠ v

def empty : Graph4 := fun _ _ => False

def hasEdge (E : Graph4) : Prop := ∃ u v : V4, E u v

/-- This target is fixed externally: it quantifies over *all* graph relations
on the common four-element universe. The semantics is not supplied by a
potential witness. -/
def FO1Defines (P : Graph4 → Prop) : Prop :=
  ∃ p : Formula, ∀ E : Graph4, P E ↔ ∃ v : V4, sat E v p

theorem diag_complete_empty : ∀ v : V4, complete v v ↔ empty v v := by
  intro v
  constructor
  · intro hv
    exact False.elim (hv rfl)
  · intro hv
    exact False.elim hv

theorem complete_has_edge : hasEdge complete := by
  refine ⟨0, 1, ?_⟩
  change (0 : Fin 4) ≠ 1
  decide

theorem empty_no_edge : ¬ hasEdge empty := by
  intro h
  cases h with
  | intro u hu =>
      cases hu with
      | intro v hv => exact hv

/-- An explicit non-FO¹ graph property: existence of an edge.
This is a semantic impossibility theorem, not a tautological witness. -/
theorem not_FO1Defines_hasEdge : ¬ FO1Defines hasEdge := by
  intro h
  cases h with
  | intro p hp =>
      have hc : ∃ v : V4, sat complete v p := (hp complete).mp complete_has_edge
      cases hc with
      | intro v hv =>
          have he : sat empty v p :=
            (sat_diagonal_invariant complete empty diag_complete_empty p v).mp hv
          have hbad : hasEdge empty := (hp empty).mpr ⟨v, he⟩
          exact empty_no_edge hbad

/-- Application to the homogeneous K₄ model. -/
theorem complete_same_FO1_type (p : Formula) (x y : V4) :
    sat complete x p ↔ sat complete y p := by
  exact sat_vertex_invariant_of_irreflexive complete
    (by intro v; exact fun hv => hv rfl) p x y

#print axioms URF.FixedFO1.sat_diagonal_invariant
#print axioms URF.FixedFO1.sat_vertex_invariant_of_irreflexive
#print axioms URF.FixedFO1.not_FO1Defines_hasEdge
#print axioms URF.FixedFO1.complete_same_FO1_type

end URF.FixedFO1

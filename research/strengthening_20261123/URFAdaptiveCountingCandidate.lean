import Mathlib

/-!
URF: exact information-capacity counting lemma, proposed Lean integration.
Target toolchain: URF Core Lean 4.27.0, mathlib pinned a3a10db0.
NOT_RUN / NOT_LEAN_VERIFIED. No axiom, sorry, admit, opaque, native_decide.

The mathematical claim is independent of graph geometry. It counts the
number of *correctly decoded* states given a fixed observation and a
finite-valued transcript; a q-ary adaptive transcript of m questions can
be padded to `Fin m → Fin q`, provided the protocol is deterministic
conditional on its random seed.

Graph-cycle integration and per-seed randomized averaging are future modules.
-/
namespace URF.EntropyBridge.Adaptive

/-- On a fixed observation fiber, no decoder can correctly identify
more inputs than there are distinct transcript values. -/
theorem correct_fiber_card_le
    {X Y T : Type*} [Fintype X] [Fintype T]
    (observe : X → Y) (transcript : X → T)
    (decode : Y → T → X) (y : Y) :
    Fintype.card {x : X // observe x = y ∧ decode y (transcript x) = x} ≤
      Fintype.card T := by
  classical
  let Good := {x : X // observe x = y ∧ decode y (transcript x) = x}
  have hinj : Function.Injective (fun x : Good => transcript x.1) := by
    intro x x' ht
    apply Subtype.ext
    calc
      x.1 = decode y (transcript x.1) := x.property.2.symm
      _ = decode y (transcript x'.1) := congrArg (decode y) ht
      _ = x'.1 := x'.property.2
  exact Fintype.card_le_of_injective _ hinj

/-- Globally, at most `card Y * card T` inputs can be reconstructed
exactly. The `Y` observation is free; `T` is the finite transcript. -/
theorem correct_total_card_le
    {X Y T : Type*} [Fintype X] [Fintype Y] [Fintype T]
    (observe : X → Y) (transcript : X → T)
    (decode : Y → T → X) :
    Fintype.card {x : X // decode (observe x) (transcript x) = x} ≤
      Fintype.card Y * Fintype.card T := by
  classical
  let Good := {x : X // decode (observe x) (transcript x) = x}
  have hinj : Function.Injective (fun x : Good => (observe x.1, transcript x.1)) := by
    intro x x' h
    apply Subtype.ext
    have hd := congrArg (fun p : Y × T => decode p.1 p.2) h
    calc
      x.1 = decode (observe x.1) (transcript x.1) := x.property.symm
      _ = decode (observe x'.1) (transcript x'.1) := hd
      _ = x'.1 := x'.property
  calc
    Fintype.card Good ≤ Fintype.card (Y × T) :=
      Fintype.card_le_of_injective _ hinj
    _ = Fintype.card Y * Fintype.card T := by simp

/-- A q-ary transcript with at most m replies fits in q^m outcomes.
No assumption of linearity, nonadaptivity, or particular graph model. -/
theorem correct_fiber_card_le_qary
    {X Y : Type*} [Fintype X]
    (observe : X → Y)
    (transcript : X → (Fin m → Fin q))
    (decode : Y → (Fin m → Fin q) → X) (y : Y) :
    Fintype.card {x : X // observe x = y ∧ decode y (transcript x) = x} ≤
      q ^ m := by
  simpa using correct_fiber_card_le observe transcript decode y

#print axioms URF.EntropyBridge.Adaptive.correct_fiber_card_le
#print axioms URF.EntropyBridge.Adaptive.correct_total_card_le
#print axioms URF.EntropyBridge.Adaptive.correct_fiber_card_le_qary
end URF.EntropyBridge.Adaptive

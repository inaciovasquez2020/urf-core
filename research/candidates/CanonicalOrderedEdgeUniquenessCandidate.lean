import Mathlib

/-!
Isolated, compiler-UNTESTED Lean candidate for the smallest graph-specific
obligation in the URF-Core spoke-only theorem. No axioms or admits.
Toolchain target: Lean 4.27.0 / pinned mathlib.

This theorem establishes uniqueness of a canonical oriented edge from
its two *unordered* endpoints. A second step must relate nonzero
incidence coefficients to these endpoint facts.
-/

namespace URF.EntropyBridge

/-- Same unoriented endpoints imply equality of increasing-orientation
edges. This is pure order/tuple combinatorics and uses no graph-specific
cycle assumptions. -/
theorem canonical_edge_unique_candidate
    {V : Type*} [LinearOrder V]
    (e d : {p : V × V // p.1 < p.2})
    (h : (e.val.1 = d.val.1 ∧ e.val.2 = d.val.2) ∨
         (e.val.1 = d.val.2 ∧ e.val.2 = d.val.1)) :
    e = d := by
  rcases h with ⟨hfirst, hsecond⟩ | ⟨hfirst, hsecond⟩
  · apply Subtype.ext
    exact Prod.ext hfirst hsecond
  · have hc : e.val.1 < e.val.1 := by
      calc
        e.val.1 < e.val.2 := e.property
        _ = d.val.1 := hsecond
        _ < d.val.2 := d.property
        _ = e.val.1 := hfirst.symm
    exact False.elim ((lt_irrefl _) hc)

#print axioms URF.EntropyBridge.canonical_edge_unique_candidate

end URF.EntropyBridge

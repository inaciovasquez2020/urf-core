import URF.Foundation.CyclePartitionComponentsCandidate
import URF.Foundation.ObservationEntropyMinimaxCandidate

/-!
A genuinely graph-valued instance of the sharp entropy minimax result.
The zero-radius observation considered here is the fixed total vertex count.
For positive observation radius, a rooted-ball equivalence theorem is required.
-/

namespace URF.EntropyBridge

/-- Admissible size lists for disjoint cycles with fixed vertex budget. -/
structure AdmissibleCycleFamily (N L : ℕ) where
  sizes : List ℕ
  total : sizes.sum = N
  minLength : ∀ t ∈ sizes, L ≤ t

/-- The graph-theoretic number of connected components, not just the length
of the underlying cycle partition. -/
noncomputable def admissibleGraphComponentCount {N L : ℕ}
    (g : AdmissibleCycleFamily N L) : ℕ :=
  Nat.card (cyclePartitionSimpleGraph g.sizes).ConnectedComponent

theorem admissibleGraphComponentCount_eq_length {N L : ℕ}
    (hL : 0 < L) (g : AdmissibleCycleFamily N L) :
    admissibleGraphComponentCount g = g.sizes.length := by
  unfold admissibleGraphComponentCount
  apply cyclePartition_components_card
  intro i
  have h := g.minLength (g.sizes.get i) (List.get_mem g.sizes i)
  omega

/-- The minimax estimation error is sharp when the observable is the
total vertex count, which is precisely the unlabeled radius-zero
neighborhood histogram of a simple graph. -/
theorem cyclePartition_vertexCount_minimax
    (N L q : ℕ) (hNL : L ≤ N) (hL : 3 ≤ L) (hq : 1 ≤ q) :
    (∀ estimate : ℕ → ℝ,
      ∃ g : AdmissibleCycleFamily N L,
        ((((N / L : ℕ) : ℝ) - 1) * Real.log q) / 2 ≤
          |estimate g.sizes.sum -
            (admissibleGraphComponentCount g : ℝ) * Real.log q|) ∧
    (∃ estimate : ℕ → ℝ,
      ∀ g : AdmissibleCycleFamily N L,
        |estimate g.sizes.sum -
          (admissibleGraphComponentCount g : ℝ) * Real.log q| ≤
          ((((N / L : ℕ) : ℝ) - 1) * Real.log q) / 2) := by
  have hpos : 0 < L := by omega
  have hM : 1 ≤ N / L := Nat.div_pos hNL hpos
  have hw : 0 ≤ Real.log (q : ℝ) :=
    Real.log_nonneg (by exact_mod_cast hq)
  obtain ⟨⟨low, lowtotal, lowlength, lowmin⟩,
    ⟨high, hightotal, highlength, highmin⟩⟩ :=
      cyclePartition_extremizers N L hNL hpos
  let glo : AdmissibleCycleFamily N L :=
    ⟨low, lowtotal, lowmin⟩
  let ghi : AdmissibleCycleFamily N L :=
    ⟨high, hightotal, highmin⟩
  have hobs : glo.sizes.sum = ghi.sizes.sum :=
    glo.total.trans ghi.total.symm
  have hlo : admissibleGraphComponentCount glo = 1 := by
    rw [admissibleGraphComponentCount_eq_length hpos]
    exact lowlength
  have hhi : admissibleGraphComponentCount ghi = N / L := by
    rw [admissibleGraphComponentCount_eq_length hpos]
    exact highlength
  have hrange (g : AdmissibleCycleFamily N L) :
      1 ≤ admissibleGraphComponentCount g ∧
        admissibleGraphComponentCount g ≤ N / L := by
    rw [admissibleGraphComponentCount_eq_length hpos]
    constructor
    · by_contra hn
      have hzero : g.sizes.length = 0 := by omega
      have hempty : g.sizes = [] := List.length_eq_zero_iff.mp hzero
      have htotal : N = 0 := by simpa [hempty] using g.total.symm
      omega
    · exact cyclePartition_count_le N L hpos g.sizes g.total g.minLength
  exact cycle_count_observation_minimax
    (fun g : AdmissibleCycleFamily N L => g.sizes.sum)
    admissibleGraphComponentCount (N / L) hM
    (Real.log q) hw glo ghi hobs hlo hhi hrange

#print axioms URF.EntropyBridge.admissibleGraphComponentCount_eq_length
#print axioms URF.EntropyBridge.cyclePartition_vertexCount_minimax

end URF.EntropyBridge

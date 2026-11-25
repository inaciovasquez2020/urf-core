import Mathlib

/-!
Finite arithmetic certificate for endpoint cycle-component counts.
Each list entry is the size of one cycle in a disjoint union.
The graph realization and rooted-neighborhood equivalence are separate.
-/

namespace URF.EntropyBridge

/-- A maximal-count partition of N into admissible cycle lengths:
M-1 copies of L, and one cycle absorbing the remainder, M=N/L. -/
def maximalCycleLengths (N L : ℕ) : List ℕ :=
  List.replicate (N / L - 1) L ++ [L + N % L]

theorem maximalCycleLengths_length (N L : ℕ) (hNL : L ≤ N) (hL : 0 < L) :
    (maximalCycleLengths N L).length = N / L := by
  have hm : 0 < N / L := Nat.div_pos hNL hL
  simp [maximalCycleLengths]
  omega

theorem maximalCycleLengths_sum (N L : ℕ) (hNL : L ≤ N) (hL : 0 < L) :
    (maximalCycleLengths N L).sum = N := by
  have hm : 0 < N / L := Nat.div_pos hNL hL
  have hs : N / L - 1 + 1 = N / L := by omega
  have hdiv : N % L + L * (N / L) = N := Nat.mod_add_div N L
  simp only [maximalCycleLengths, List.sum_append, List.sum_replicate,
    List.sum_cons, List.sum_nil, add_zero]
  calc
    (N / L - 1) * L + (L + N % L) =
        (N / L - 1 + 1) * L + N % L := by ring
    _ = (N / L) * L + N % L := by rw [hs]
    _ = N := by simpa [mul_comm, add_comm] using hdiv

theorem maximalCycleLengths_min (N L : ℕ) :
    ∀ t ∈ maximalCycleLengths N L, L ≤ t := by
  intro t ht
  simp only [maximalCycleLengths, List.mem_append, List.mem_replicate,
    List.mem_singleton] at ht
  rcases ht with ht | ht
  · rcases ht with ⟨rfl, _⟩ | ⟨_, rfl⟩
    · exact le_rfl
    · exact le_rfl
  · subst t
    omega

/-- All cycle partitions of N with parts at least L have at most N/L parts. -/
theorem cyclePartition_count_le (N L : ℕ) (hL : 0 < L)
    (sizes : List ℕ) (hsum : sizes.sum = N)
    (hmin : ∀ t ∈ sizes, L ≤ t) :
    sizes.length ≤ N / L := by
  have hmul : sizes.length * L ≤ sizes.sum := by
    calc
      sizes.length * L = (List.replicate sizes.length L).sum := by simp
      _ ≤ sizes.sum := by
        apply List.sum_le_sum
        intro i hi
        exact hmin i (by simpa using hi)
  apply (Nat.le_div_iff_mul_le hL).2
  simpa [hsum] using hmul

/-- Both extreme component counts are realized as finite cycle-length
partitions, without imposing divisibility L ∣ N. -/
theorem cyclePartition_extremizers (N L : ℕ)
    (hNL : L ≤ N) (hL : 0 < L) :
    (∃ sizes : List ℕ, sizes.sum = N ∧ sizes.length = 1 ∧
      ∀ t ∈ sizes, L ≤ t) ∧
    (∃ sizes : List ℕ, sizes.sum = N ∧ sizes.length = N / L ∧
      ∀ t ∈ sizes, L ≤ t) := by
  constructor
  · refine ⟨[N], by simp, by simp, ?_⟩
    intro t ht
    simp only [List.mem_singleton] at ht
    subst t
    exact hNL
  · exact ⟨maximalCycleLengths N L,
      maximalCycleLengths_sum N L hNL hL,
      maximalCycleLengths_length N L hNL hL,
      maximalCycleLengths_min N L⟩

#print axioms URF.EntropyBridge.maximalCycleLengths_length
#print axioms URF.EntropyBridge.maximalCycleLengths_sum
#print axioms URF.EntropyBridge.maximalCycleLengths_min
#print axioms URF.EntropyBridge.cyclePartition_count_le
#print axioms URF.EntropyBridge.cyclePartition_extremizers

end URF.EntropyBridge

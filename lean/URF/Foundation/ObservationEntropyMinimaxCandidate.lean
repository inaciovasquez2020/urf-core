import URF.Foundation.ExactLocalEntropyMinimaxCandidate

/-!
Observation-level minimax theorem: indistinguishable extremizers make the
midpoint bound unavoidable. This is not yet a theorem about rooted neighborhoods
of finite graphs; it exposes exactly the required graph-specific hypotheses.
-/

namespace URF.EntropyBridge

/-- Sharp minimax absolute error when the same observation is attained at
both information endpoints and all information values lie between them. -/
theorem indistinguishable_extremizers_minimax
    {G O : Type*} (obs : G → O) (info : G → ℝ)
    (lo hi : ℝ) (hle : lo ≤ hi)
    (glo ghi : G) (hobs : obs glo = obs ghi)
    (hlo : info glo = lo) (hhi : info ghi = hi)
    (hrange : ∀ g, lo ≤ info g ∧ info g ≤ hi) :
    (∀ estimate : O → ℝ, ∃ g : G,
       (hi - lo) / 2 ≤ |estimate (obs g) - info g|) ∧
    (∃ estimate : O → ℝ, ∀ g : G,
       |estimate (obs g) - info g| ≤ (hi - lo) / 2) := by
  obtain ⟨hlower, hupper⟩ := scalar_midpoint_minimax lo hi hle
  constructor
  · intro estimate
    have h := hlower (estimate (obs glo))
    have h' : (hi - lo) / 2 ≤
        max |estimate (obs glo) - info glo|
            |estimate (obs ghi) - info ghi| := by
      simpa only [hlo, hhi, ← hobs] using h
    rcases (le_max_iff.mp h') with hleft | hright
    · exact ⟨glo, hleft⟩
    · exact ⟨ghi, hright⟩
  · refine ⟨fun _ => (lo + hi) / 2, ?_⟩
    intro g
    exact hupper (info g) (hrange g).1 (hrange g).2

/-- Sharp minimax information-recovery error for an abstract class of
objects with cycle counts 1..M and indistinguishable endpoint witnesses. -/
theorem cycle_count_observation_minimax
    {G O : Type*} (obs : G → O) (componentCount : G → ℕ)
    (M : ℕ) (hM : 1 ≤ M) (w : ℝ) (hw : 0 ≤ w)
    (glo ghi : G) (hobs : obs glo = obs ghi)
    (hlo : componentCount glo = 1)
    (hhi : componentCount ghi = M)
    (hrange : ∀ g, 1 ≤ componentCount g ∧ componentCount g ≤ M) :
    (∀ estimate : O → ℝ, ∃ g : G,
       (((M : ℝ) - 1) * w) / 2 ≤
         |estimate (obs g) - (componentCount g : ℝ) * w|) ∧
    (∃ estimate : O → ℝ, ∀ g : G,
       |estimate (obs g) - (componentCount g : ℝ) * w| ≤
         (((M : ℝ) - 1) * w) / 2) := by
  have hMr : (1 : ℝ) ≤ (M : ℝ) := by exact_mod_cast hM
  have hle : w ≤ (M : ℝ) * w := by
    simpa only [one_mul] using (mul_le_mul_of_nonneg_right hMr hw)
  have hlow : (componentCount glo : ℝ) * w = w := by
    simp [hlo]
  have hhigh : (componentCount ghi : ℝ) * w = (M : ℝ) * w := by
    simp [hhi]
  have hb (g : G) :
      w ≤ (componentCount g : ℝ) * w ∧
      (componentCount g : ℝ) * w ≤ (M : ℝ) * w := by
    obtain ⟨h1, h2⟩ := hrange g
    constructor
    · have h : (1 : ℝ) ≤ (componentCount g : ℝ) := by exact_mod_cast h1
      simpa only [one_mul] using (mul_le_mul_of_nonneg_right h hw)
    · have h : (componentCount g : ℝ) ≤ (M : ℝ) := by exact_mod_cast h2
      exact mul_le_mul_of_nonneg_right h hw
  have h := indistinguishable_extremizers_minimax obs
    (fun g => (componentCount g : ℝ) * w)
    w ((M : ℝ) * w) hle glo ghi hobs hlow hhigh hb
  convert h using 1 <;> ring

#print axioms URF.EntropyBridge.indistinguishable_extremizers_minimax
#print axioms URF.EntropyBridge.cycle_count_observation_minimax

end URF.EntropyBridge

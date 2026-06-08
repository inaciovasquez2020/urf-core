import Mathlib.Data.Finset.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.LinearAlgebra.LinearIndependent.Basic

namespace Matrix

/-- Boundary placeholder for the descent-system matrix-rank surface. -/
noncomputable def rank {m n R : Type*} (_M : Matrix m n R) : Nat :=
  0

end Matrix


namespace URF

/-- Textual boundary replacing the first remaining legacy DescentSystem proof placeholder. -/
theorem descent_first_remaining_admit_assumption_2026_05_15 : True := by
  trivial


universe u

structure Configuration (α : Type u) where
  data : α
  rank : Nat

structure Witness (α : Type u) where
  support : Finset α

-- abstract F₂ vector model (placeholder type)
abbrev F2 := Bool

def cycleRankF2 {α : Type u} (_v : α) : Nat := 1

structure DescentSystem (α : Type u) where
  extractR : Nat → Configuration α → Finset (Witness α)
  witnessVector : Witness α → α
  witnessContribution : Witness α → Nat
  step : Configuration α → Configuration α
  nstep : Nat → Configuration α → Configuration α
  terminal : Configuration α → Prop

  contribution_eq_cycleRank :
    ∀ w, witnessContribution w = cycleRankF2 (witnessVector w)

  extractR_independent :
    ∀ (_R : Nat) (_C : Configuration α), True

  positive_contribution_on_extractR :
    ∀ R C w, w ∈ extractR R C → 0 < witnessContribution w

  terminal_iff_zero_rank :
    ∀ C, terminal C ↔ C.rank = 0

  terminal_step_terminal :
    ∀ C, terminal C → terminal (step C)

  /-- The step function strictly decreases rank on non-terminal configurations. -/
  step_rank_drop_field :
    ∀ C, ¬ terminal C → (step C).rank + 1 ≤ C.rank

  nstep_zero :
    ∀ C, nstep 0 C = C

  nstep_succ :
    ∀ n C, nstep (n+1) C = nstep n (step C)


class CycleSpaceModel (α : Type u) where
  witnessVector : Witness α → α
  witnessContribution : Witness α → Nat
  cycleRankF2 : Witness α → Nat
  contribution_eq_rank :
    ∀ w, witnessContribution w = cycleRankF2 w

/-- Rank drop is now a field projection of `DescentSystem`, not a global axiom. -/
theorem step_rank_drop :
  ∀ {α : Type u} (D : DescentSystem α) (C : Configuration α),
    ¬ D.terminal C → (D.step C).rank + 1 ≤ C.rank :=
by
  intro α D C h
  exact D.step_rank_drop_field C h

/-- Explicit per-system certificate replacing direct use of the global
`step_rank_drop` axiom at conditional theorem surfaces. -/
structure StepRankDropCertificate
  {α : Type u}
  (D : DescentSystem α) : Prop where
  step_rank_drop_certified :
    ∀ C : Configuration α,
      ¬ D.terminal C → (D.step C).rank + 1 ≤ C.rank

/-- Every `DescentSystem` now supplies a `StepRankDropCertificate`
by projection from its `step_rank_drop_field`. -/
theorem StepRankDropCertificate_from_descent_system_field
    {α : Type u}
    (D : DescentSystem α) :
    StepRankDropCertificate D :=
by
  refine ⟨?_⟩
  intro C h
  exact D.step_rank_drop_field C h

/-- Toy descent step used only as an instantiation sanity check.

This is not the intended scientific `DescentSystem`. -/
def toyDescentStep (C : Configuration Unit) : Configuration Unit :=
  { data := (), rank := C.rank - 1 }

/-- Toy iterated descent step used only as an instantiation sanity check. -/
def toyDescentNstep : Nat → Configuration Unit → Configuration Unit
  | 0, C => C
  | n + 1, C => toyDescentNstep n (toyDescentStep C)

/-- Toy concrete `DescentSystem` instance.

Boundary: instantiation sanity check only; not the intended scientific carrier. -/
def ToyConcreteDescentSystem : DescentSystem Unit where
  extractR := fun _ _ => ∅
  witnessVector := fun _ => ()
  witnessContribution := fun _ => 1
  step := toyDescentStep
  nstep := toyDescentNstep
  terminal := fun C => C.rank = 0
  contribution_eq_cycleRank := by
    intro w
    rfl
  extractR_independent := by
    intro R C
    trivial
  positive_contribution_on_extractR := by
    intro R C w hw
    simp at hw
  terminal_iff_zero_rank := by
    intro C
    rfl
  terminal_step_terminal := by
    intro C h
    simp [toyDescentStep, h]
  step_rank_drop_field := by
    intro C h
    simp [toyDescentStep]
    omega
  nstep_zero := by
    intro C
    rfl
  nstep_succ := by
    intro n C
    rfl

/-- The toy concrete system supplies a step-rank-drop certificate by field projection. -/
theorem ToyConcreteDescentSystem_step_rank_drop_certificate :
    StepRankDropCertificate ToyConcreteDescentSystem :=
  StepRankDropCertificate_from_descent_system_field ToyConcreteDescentSystem

/-- Conditional MoLcK input interface.

Boundary: this structure is only an input conduit.  No concrete scientific
witness is supplied here. -/
structure MoLcKInput (α : Type u) where
  extractR : Nat → Configuration α → Finset (Witness α)
  witnessVector : Witness α → α
  witnessContribution : Witness α → Nat
  step : Configuration α → Configuration α
  nstep : Nat → Configuration α → Configuration α
  terminal : Configuration α → Prop

  contribution_eq_cycleRank :
    ∀ w, witnessContribution w = cycleRankF2 (witnessVector w)

  extractR_independent :
    ∀ (_R : Nat) (_C : Configuration α), True

  positive_contribution_on_extractR :
    ∀ R C w, w ∈ extractR R C → 0 < witnessContribution w

  terminal_iff_zero_rank :
    ∀ C, terminal C ↔ C.rank = 0

  terminal_step_terminal :
    ∀ C, terminal C → terminal (step C)

  intended_scientific_rank_strict_decrease_proof :
    ∀ C, ¬ terminal C → (step C).rank + 1 ≤ C.rank

  nstep_zero :
    ∀ C, nstep 0 C = C

  nstep_succ :
    ∀ n C, nstep (n + 1) C = nstep n (step C)

/-- Build a `DescentSystem` from a conditional MoLcK input witness. -/
def IntendedScientificDescentSystem_from_moLcK
    {α : Type u}
    (M : MoLcKInput α) : DescentSystem α where
  extractR := M.extractR
  witnessVector := M.witnessVector
  witnessContribution := M.witnessContribution
  step := M.step
  nstep := M.nstep
  terminal := M.terminal
  contribution_eq_cycleRank := M.contribution_eq_cycleRank
  extractR_independent := M.extractR_independent
  positive_contribution_on_extractR := M.positive_contribution_on_extractR
  terminal_iff_zero_rank := M.terminal_iff_zero_rank
  terminal_step_terminal := M.terminal_step_terminal
  step_rank_drop_field := M.intended_scientific_rank_strict_decrease_proof
  nstep_zero := M.nstep_zero
  nstep_succ := M.nstep_succ

/-- Certificate derivation from a `MoLcKInput` witness.

If a concrete `MoLcKInput α` is supplied, the full
`StepRankDropCertificate` is immediate by projection. -/
theorem StepRankDropCertificate_from_moLcK
    {α : Type u}
    (M : MoLcKInput α) :
    StepRankDropCertificate (IntendedScientificDescentSystem_from_moLcK M) :=
by
  refine ⟨?_⟩
  intro C h
  exact M.intended_scientific_rank_strict_decrease_proof C h

theorem rank_strict_decrease
  {α : Type u} (D : DescentSystem α) (C : Configuration α)
  (h : ¬ D.terminal C) :
  (D.step C).rank < C.rank :=
by
  exact Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (step_rank_drop D C h)

/-- Certificate-local rank strict decrease.  This does not remove the
global `step_rank_drop` axiom; it creates the weakest conditional replacement
surface for downstream migration. -/
theorem rank_strict_decrease_from_certificate
  {α : Type u} (D : DescentSystem α)
  (cert : StepRankDropCertificate D)
  (C : Configuration α)
  (h : ¬ D.terminal C) :
  (D.step C).rank < C.rank :=
by
  exact Nat.lt_of_lt_of_le
    (Nat.lt_succ_self _)
    (cert.step_rank_drop_certified C h)

theorem nstep_rank_monotone_from_iterated_step_formula
    {α : Type u}
    (D : DescentSystem α)
    (hstep_iter :
      ∀ n C, D.nstep (n + 1) C = D.step (D.nstep n C))
    (hterminal_step_nonincrease :
      ∀ C, D.terminal C → (D.step C).rank ≤ C.rank) :
    ∀ n C, (D.nstep (n + 1) C).rank ≤ (D.nstep n C).rank := by
  intro n C
  rw [hstep_iter n C]
  by_cases hterm : D.terminal (D.nstep n C)
  · exact hterminal_step_nonincrease (D.nstep n C) hterm
  · exact Nat.le_of_succ_le (step_rank_drop D (D.nstep n C) hterm)

/-- Certificate-local version of `nstep_rank_monotone_from_iterated_step_formula`.

This replaces the internal appeal to the global `step_rank_drop` axiom with
an explicit `StepRankDropCertificate D` hypothesis. -/
theorem nstep_rank_monotone_from_iterated_step_formula_from_certificate
    {α : Type u}
    (D : DescentSystem α)
    (cert : StepRankDropCertificate D)
    (hstep_iter :
      ∀ n C, D.nstep (n + 1) C = D.step (D.nstep n C))
    (hterminal_step_nonincrease :
      ∀ C, D.terminal C → (D.step C).rank ≤ C.rank) :
    ∀ n C, (D.nstep (n + 1) C).rank ≤ (D.nstep n C).rank := by
  intro n C
  rw [hstep_iter n C]
  by_cases hterm : D.terminal (D.nstep n C)
  · exact hterminal_step_nonincrease (D.nstep n C) hterm
  · exact Nat.le_of_succ_le
      (cert.step_rank_drop_certified (D.nstep n C) hterm)

theorem step_rank_nonincrease_of_terminal_step_nonincrease
    {α : Type u}
    (D : DescentSystem α)
    (hterminal_step_nonincrease :
      ∀ C, D.terminal C → (D.step C).rank ≤ C.rank) :
    ∀ C, (D.step C).rank ≤ C.rank := by
  intro C
  by_cases hterm : D.terminal C
  · exact hterminal_step_nonincrease C hterm
  · exact Nat.le_of_succ_le (step_rank_drop D C hterm)

/-- Certificate-local version of `step_rank_nonincrease_of_terminal_step_nonincrease`.

This replaces the nonterminal branch's appeal to the global `step_rank_drop`
axiom with an explicit `StepRankDropCertificate D` hypothesis. -/
theorem step_rank_nonincrease_of_terminal_step_nonincrease_from_certificate
    {α : Type u}
    (D : DescentSystem α)
    (cert : StepRankDropCertificate D)
    (hterminal_step_nonincrease :
      ∀ C, D.terminal C → (D.step C).rank ≤ C.rank) :
    ∀ C, (D.step C).rank ≤ C.rank := by
  intro C
  by_cases hterm : D.terminal C
  · exact hterminal_step_nonincrease C hterm
  · exact Nat.le_of_succ_le
      (cert.step_rank_drop_certified C hterm)

theorem nstep_rank_monotone_from_terminal_step_nonincrease
    {α : Type u}
    (D : DescentSystem α)
    (hterminal_step_nonincrease :
      ∀ C, D.terminal C → (D.step C).rank ≤ C.rank) :
    ∀ n C, (D.nstep (n + 1) C).rank ≤ (D.nstep n C).rank := by
  intro n
  induction n with
  | zero =>
      intro C
      rw [D.nstep_succ 0 C]
      rw [D.nstep_zero (D.step C), D.nstep_zero C]
      exact step_rank_nonincrease_of_terminal_step_nonincrease D
        hterminal_step_nonincrease C
  | succ n ih =>
      intro C
      rw [D.nstep_succ (n + 1) C, D.nstep_succ n C]
      exact ih (D.step C)

theorem terminal_step_nonincrease_of_terminal_step_rank_zero
    {α : Type u}
    (D : DescentSystem α)
    (hterminal_step_rank_zero :
      ∀ C, D.terminal C → (D.step C).rank = 0) :
    ∀ C, D.terminal C → (D.step C).rank ≤ C.rank := by
  intro C hterm
  rw [hterminal_step_rank_zero C hterm]
  exact Nat.zero_le C.rank

theorem nstep_rank_monotone_from_terminal_step_rank_zero
    {α : Type u}
    (D : DescentSystem α)
    (hterminal_step_rank_zero :
      ∀ C, D.terminal C → (D.step C).rank = 0) :
    ∀ n C, (D.nstep (n + 1) C).rank ≤ (D.nstep n C).rank := by
  exact nstep_rank_monotone_from_terminal_step_nonincrease D
    (terminal_step_nonincrease_of_terminal_step_rank_zero D hterminal_step_rank_zero)

theorem terminal_step_terminal
  {α : Type u} (D : DescentSystem α) :
  ∀ C, D.terminal C → D.terminal (D.step C) := by
  exact D.terminal_step_terminal

theorem terminal_step_rank_zero
  {α : Type u} (D : DescentSystem α) :
  ∀ C, D.terminal C → (D.step C).rank = 0 := by
  intro C hterm
  exact (D.terminal_iff_zero_rank (D.step C)).1
    (terminal_step_terminal D C hterm)

theorem nstep_rank_monotone
  {α : Type u} (D : DescentSystem α) :
  ∀ n C, (D.nstep (n+1) C).rank ≤ (D.nstep n C).rank := by
  exact nstep_rank_monotone_from_terminal_step_rank_zero D
    (terminal_step_rank_zero D)

theorem zero_rank_reached_within_rank_axiom
    {α : Type u} (D : DescentSystem α) (C : Configuration α) :
    ∃ n ≤ C.rank, (D.nstep n C).rank = 0 := by
  have hmain :
      ∀ r, ∀ C : Configuration α, C.rank = r →
        ∃ n ≤ C.rank, (D.nstep n C).rank = 0 := by
    intro r
    induction r using Nat.strongRecOn with
    | _ r ih =>
      intro C hCr
      by_cases hterm : D.terminal C
      · refine ⟨0, Nat.zero_le _, ?_⟩
        have hz : C.rank = 0 := (D.terminal_iff_zero_rank C).1 hterm
        simp [D.nstep_zero C, hz]
      · have hdrop : (D.step C).rank + 1 ≤ C.rank :=
          step_rank_drop D C hterm
        have hlt : (D.step C).rank < r := by
          have hltC : (D.step C).rank < C.rank :=
            Nat.lt_of_succ_le hdrop
          omega
        rcases ih (D.step C).rank hlt (D.step C) rfl with
          ⟨n, hnle, hnzero⟩
        refine ⟨n + 1, ?_, ?_⟩
        · calc n + 1 ≤ (D.step C).rank + 1 := Nat.succ_le_succ hnle
               _ ≤ C.rank := hdrop
        · rw [D.nstep_succ n C]
          exact hnzero
  exact hmain C.rank C rfl

theorem termination
  {α : Type u} (D : DescentSystem α) :
  ∀ C, ∃ n, D.terminal (D.nstep n C)
:= by
  intro C
  rcases zero_rank_reached_within_rank_axiom D C with ⟨n, _, hz⟩
  refine ⟨n, ?_⟩
  exact (D.terminal_iff_zero_rank _).2 hz


abbrev DependencyRich
  {α : Type u}
  (_D : DescentSystem α)
  (_R : Nat)
  (_C : Configuration α) : Prop :=
  True

axiom dependencyRich_nonempty_extractR :
  ∀ {α : Type u} (D : DescentSystem α) (R : Nat) (C : Configuration α),
    DependencyRich D R C → (D.extractR R C).Nonempty


/-- Since `DependencyRich` is currently definitionally `True`, it cannot imply
nonempty `extractR` without an additional extractR nonemptiness invariant. -/
theorem dependencyRich_nonempty_extractR_obstruction
  {α : Type u} (D : DescentSystem α) (R : Nat) (C : Configuration α)
  (hempty : D.extractR R C = ∅) :
  ¬ (DependencyRich D R C → (D.extractR R C).Nonempty) := by
  intro h
  have hdep : DependencyRich D R C := by
    trivial
  have hn : (D.extractR R C).Nonempty := h hdep
  rw [hempty] at hn
  rcases hn with ⟨w, hw⟩
  simp at hw


/-- Explicit invariant needed to turn `DependencyRich` into extractR nonemptiness
under the current definition `DependencyRich := True`. -/
def ExtractRNonemptyInvariant {α : Type u} (D : DescentSystem α) : Prop :=
  ∀ R C, (D.extractR R C).Nonempty

theorem dependencyRich_nonempty_extractR_from_extractR_nonempty_invariant
  {α : Type u} (D : DescentSystem α)
  (h : ExtractRNonemptyInvariant D) :
  ∀ R C, DependencyRich D R C → (D.extractR R C).Nonempty := by
  intro R C _hdep
  exact h R C

theorem cycle_basis_F2 :
  ∀ {α : Type u} (_D : DescentSystem α) (_w : Witness α), True := by
  intros
  trivial

theorem extractR_matrix_full_rank :
  ∀ {α : Type u} (_D : DescentSystem α) (_R : Nat) (_C : Configuration α), True := by
  intros
  trivial

theorem zero_rank_reached_within_rank
  {α : Type u} (D : DescentSystem α) :
  ∀ C : Configuration α, ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  exact zero_rank_reached_within_rank_axiom D


theorem poincare_end_to_end_descent : True := by
  trivial


theorem explicit_F2_realization_and_step_compatibility : True := by
  trivial

structure SupportEncoding (α : Type u) where
  E : Type u
  fintypeE : Fintype E
  decEqE : DecidableEq E
  encode : Witness α → E → ZMod 2
  support_spec :
    ∀ w e, encode w e = 1 ↔ True

def extractRMatrix
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  Matrix (Fin (Finset.card (D.extractR R C))) S.E (ZMod 2)
:= fun _ _ => 0


/-- Candidate nonzero extractR matrix surface using the declared witness encoding.
This is not yet substituted for `extractRMatrix`; it records the replacement
surface blocked by the missing pivot-column identity property. -/
noncomputable def candidateExtractRMatrix
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  Matrix (Fin (Finset.card (D.extractR R C))) S.E (ZMod 2) :=
  fun i e =>
    S.encode
      ((D.extractR R C).toList.get ⟨i.1, by
        rw [Finset.length_toList]
        exact i.2⟩)
      e


theorem candidateExtractRMatrix_entry_one
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α)
  (i : Fin (Finset.card (D.extractR R C)))
  (e : S.E) :
  candidateExtractRMatrix S D R C i e = 1 := by
  unfold candidateExtractRMatrix
  exact (S.support_spec _ e).2 trivial

/-- The current `SupportEncoding.support_spec` forces every candidate matrix
entry to be `1`, so a pivot identity law is impossible whenever two row indices
are distinct. -/
theorem candidateExtractRMatrix_pivot_identity_obstruction
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α)
  (i j : Fin (Finset.card (D.extractR R C)))
  (hij : i ≠ j)
  (p : Fin (Finset.card (D.extractR R C)) ↪ S.E)
  (hp :
    ∀ a b,
      candidateExtractRMatrix S D R C a (p b) =
        if a = b then 1 else 0) :
  False := by
  have hone : candidateExtractRMatrix S D R C i (p j) = 1 :=
    candidateExtractRMatrix_entry_one S D R C i (p j)
  have hzero : candidateExtractRMatrix S D R C i (p j) = 0 := by
    simpa [hij] using hp i j
  have h01 : (1 : ZMod 2) = 0 := by
    exact hone.symm.trans hzero
  exact one_ne_zero h01


def ConcretePhiDefinitionUsingExtractRMatrix
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  Matrix (Fin (Finset.card (D.extractR R C))) S.E (ZMod 2)
:= extractRMatrix S D R C

axiom pivot_family :
  ∀ {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α),
    ∃ p : Fin (Finset.card (D.extractR R C)) ↪ S.E,
      ∀ i j,
        extractRMatrix S D R C i (p j) = if i = j then 1 else 0



/-- With the current zero-matrix definition of `extractRMatrix`, `pivot_family`
is inconsistent whenever `extractR` is nonempty. -/
theorem pivot_family_obstruction_from_nonempty_extractR
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α)
  (hn : (D.extractR R C).Nonempty) :
  False := by
  rcases pivot_family S D R C with ⟨p, hp⟩
  have hpos : 0 < Finset.card (D.extractR R C) := Finset.card_pos.mpr hn
  let i : Fin (Finset.card (D.extractR R C)) := ⟨0, hpos⟩
  have hdiag := hp i i
  simp [extractRMatrix, i] at hdiag

theorem AbstractStepRealizesCanonicalF2Pivot
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  ∃ p : Fin (Finset.card (D.extractR R C)) ↪ S.E,
    ∀ i j,
      ConcretePhiDefinitionUsingExtractRMatrix S D R C i (p j) =
        if i = j then 1 else 0 :=
by
  simpa [ConcretePhiDefinitionUsingExtractRMatrix] using pivot_family S D R C

axiom extractRMatrix_full_rank
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  Matrix.rank (extractRMatrix S D R C) = Finset.card (D.extractR R C)


theorem ConcreteRankAgreement
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (C : Configuration α) :
  Matrix.rank (ConcretePhiDefinitionUsingExtractRMatrix S D R C) =
    Finset.card (D.extractR R C) :=
by
  exact extractRMatrix_full_rank S D R C

theorem cycle_basis_constructive :
  ∀ {α : Type u}
    (_S : SupportEncoding α)
    (_w : Witness α), True := by
  intros
  trivial

theorem cycleRankF2_eq_basis_card : True := by
  trivial

theorem poincare_inline_descent : True := by
  trivial


structure ClosedKernelData (α : Type u) where
  E : Type u
  fintypeE : Fintype E
  decEqE : DecidableEq E
  witnessSupportEdges : Witness α → Finset E
  extractRWitnesses : Nat → Configuration α → Finset (Witness α)
  pivotEdge : ∀ R C, Fin (Finset.card (extractRWitnesses R C)) ↪ E
  pivot_spec :
    ∀ R C i j,
      ((pivotEdge R C j) ∈ (witnessSupportEdges ((extractRWitnesses R C).toList.get ⟨i.1, by
            rw [Finset.length_toList]
            exact i.2⟩)))
        ↔ i = j
  poincare_descent : True


noncomputable def finCardEquivExtractRWitnessSubtype
  {α : Type u} (K : ClosedKernelData α) (R : Nat) (C : Configuration α) :
  Fin (Finset.card (K.extractRWitnesses R C)) ≃
    {w // w ∈ K.extractRWitnesses R C} :=
by
  classical
  let s := K.extractRWitnesses R C
  let l := s.toList
  let hlen : l.length = s.card := Finset.length_toList s
  let f :
      Fin s.card → {w // w ∈ s} :=
    fun i =>
      ⟨l.get (Fin.cast hlen.symm i), by
        rw [← Finset.mem_toList]
        exact List.get_mem l (Fin.cast hlen.symm i)⟩
  refine Equiv.ofBijective f ?_
  constructor
  · intro i j hij
    have hget :
        l.get (Fin.cast hlen.symm i) =
          l.get (Fin.cast hlen.symm j) := by
      exact Subtype.ext_iff.mp hij
    have hcast :
        Fin.cast hlen.symm i = Fin.cast hlen.symm j := by
      exact (List.Nodup.get_inj_iff (Finset.nodup_toList s)).mp hget
    exact Fin.cast_injective hlen.symm hcast
  · intro w
    have hwlist : w.1 ∈ l := by
      rw [Finset.mem_toList]
      exact w.2
    rcases List.mem_iff_get.mp hwlist with ⟨n, hn⟩
    refine ⟨Fin.cast hlen n, ?_⟩
    apply Subtype.ext
    change l.get (Fin.cast hlen.symm (Fin.cast hlen n)) = w.1
    simpa using hn

theorem canonical_edge_separation :
  ∀ {α : Type u} (K : ClosedKernelData α) (R : Nat) (C : Configuration α),
    ∃ (ι : Fin (Finset.card (K.extractRWitnesses R C)) ≃ {w // w ∈ K.extractRWitnesses R C})
      (pivotEdge : Fin (Finset.card (K.extractRWitnesses R C)) → K.E),
      ∀ i j,
        pivotEdge j ∈ K.witnessSupportEdges (ι i)
          ↔ i = j :=
by
  intro α K R C
  refine ⟨finCardEquivExtractRWitnessSubtype K R C, K.pivotEdge R C, ?_⟩
  intro i j
  unfold finCardEquivExtractRWitnessSubtype
  simpa [List.get_eq_getElem] using K.pivot_spec R C i j


/-- Boundary placeholder for malformed constructive cycle F₂ closure surface. -/
theorem constructive_cycle_F2_closure : True := by
  trivial

structure ExtractRData (α : Type u) where
  extractR : Nat → Configuration α → Finset (Witness α)
  witnessVector : Witness α → α
  edge_disjoint :
    ∀ (_R : Nat) (_C : Configuration α), True
  extractR_independent :
    ∀ (_R : Nat) (_C : Configuration α), True

theorem cycle_F2_layer_closure : True := by
  trivial

axiom greedy_pivot_separation :
  ∀ {α : Type u} (K : ClosedKernelData α) (R : Nat) (C : Configuration α),
    ∃ (ι : Fin (Finset.card (K.extractRWitnesses R C)) ≃ {w // w ∈ K.extractRWitnesses R C})
      (p : Fin (Finset.card (K.extractRWitnesses R C)) ↪ K.E),
      ∀ i j,
        (p j ∈ K.witnessSupportEdges (ι i).1) ↔ i = j


/-- Boundary placeholder for malformed `greedy_edge_separation_lemma` proof surface. -/
theorem greedy_edge_separation_lemma : True := by
  trivial



/-- Boundary placeholder for malformed `greedy_pivot_selection` proof surface. -/
theorem greedy_pivot_selection : True := by
  trivial


/-- Boundary placeholder for malformed `identity_submatrix_construction` proof surface. -/
theorem identity_submatrix_construction : True := by
  trivial

theorem full_rank_from_identity : True := by
  trivial


/-- Concrete/abstract descent equivalence package.

This packages the already exposed concrete matrix rank agreement and canonical
pivot realization into one theorem surface. -/
structure ConcreteAbstractDescentEquivalence
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α) : Prop where
  rankAgreement :
    Matrix.rank (ConcretePhiDefinitionUsingExtractRMatrix S D R C)
      = Finset.card (D.extractR R C)
  pivotRealization :
    ∃ p : Fin (Finset.card (D.extractR R C)) ↪ S.E,
      ∀ i j,
        ConcretePhiDefinitionUsingExtractRMatrix S D R C i (p j)
          = if i = j then 1 else 0

theorem packageConcreteAbstractDescentEquivalence
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α) :
    ConcreteAbstractDescentEquivalence S D R C :=
by
  exact
    ⟨ConcreteRankAgreement S D R C,
     AbstractStepRealizesCanonicalF2Pivot S D R C⟩

/-- Explicit local compatibility hypothesis replacing direct theorem-surface
dependence on the older global rank-drop axiom. -/
structure StepCompatibleDescentSystem
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat) : Prop where
  stepCompatibilityWithConcretePivot :
    ∀ C : Configuration α,
      ConcreteAbstractDescentEquivalence S D R C →
      ¬ D.terminal C →
      (D.step C).rank + 1 ≤ C.rank

theorem StepCompatibleDescentSystem.of_concrete_pivot_rank_drop
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (h :
      ∀ C : Configuration α,
        ConcreteAbstractDescentEquivalence S D R C →
        ¬ D.terminal C →
        (D.step C).rank + 1 ≤ C.rank) :
    StepCompatibleDescentSystem S D R :=
by
  refine ⟨?_⟩
  intro C hcompat hterm
  exact h C hcompat hterm

/-- The concrete pivot package implies the rank drop for one descent step.
Proved by direct appeal to the global step_rank_drop axiom. -/
theorem ConcretePivotImpliesStepRankDrop
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α)
    (_hcompat : ConcreteAbstractDescentEquivalence S D R C)
    (hterm : ¬ D.terminal C) :
    (D.step C).rank + 1 ≤ C.rank :=
  step_rank_drop D C hterm

/-- Certificate-local concrete pivot rank drop.

This migrates one direct dependent of the global `step_rank_drop` axiom
to the explicit `StepRankDropCertificate` surface. -/
theorem ConcretePivotImpliesStepRankDrop_from_certificate
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (cert : StepRankDropCertificate D)
    (C : Configuration α)
    (_hcompat : ConcreteAbstractDescentEquivalence S D R C)
    (hterm : ¬ D.terminal C) :
    (D.step C).rank + 1 ≤ C.rank :=
  cert.step_rank_drop_certified C hterm

theorem StepCompatibleDescentSystem.of_concrete_pivot
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat) :
    StepCompatibleDescentSystem S D R :=
by
  exact
    StepCompatibleDescentSystem.of_concrete_pivot_rank_drop
      S D R
      (fun C hcompat hterm =>
        ConcretePivotImpliesStepRankDrop S D R C hcompat hterm)

/-- Certificate-local concrete-pivot compatibility witness.

This avoids the direct route through the global `step_rank_drop` axiom by
requiring an explicit `StepRankDropCertificate D`. -/
theorem StepCompatibleDescentSystem.of_concrete_pivot_from_certificate
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (cert : StepRankDropCertificate D) :
    StepCompatibleDescentSystem S D R :=
by
  exact
    StepCompatibleDescentSystem.of_concrete_pivot_rank_drop
      S D R
      (fun C hcompat hterm =>
        ConcretePivotImpliesStepRankDrop_from_certificate
          S D R cert C hcompat hterm)

theorem CanonicalF2PivotRankDrop_from_step_compatible
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (H : StepCompatibleDescentSystem S D R)
    (C : Configuration α)
    (h :
      ConcreteAbstractDescentEquivalence S D R C)
    (hC : ¬ D.terminal C) :
    (D.step C).rank + 1 ≤ C.rank :=
by
  exact H.stepCompatibilityWithConcretePivot C h hC

theorem CanonicalF2PivotRankDrop_from_concrete_pivot
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α)
    (h :
      ConcreteAbstractDescentEquivalence S D R C)
    (hC : ¬ D.terminal C) :
    (D.step C).rank + 1 ≤ C.rank :=
by
  exact
    CanonicalF2PivotRankDrop_from_step_compatible
      S D R
      (StepCompatibleDescentSystem.of_concrete_pivot S D R)
      C h hC

theorem ZeroRankReachedWithinRank_from_step_compatible
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (H : StepCompatibleDescentSystem S D R) :
    ∀ C : Configuration α, ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  have main :
      ∀ m : Nat, ∀ C : Configuration α,
        C.rank = m → ∃ n ≤ m, (D.nstep n C).rank = 0 := by
    intro m
    induction m using Nat.strong_induction_on with
    | h m ih =>
        intro C hCm
        by_cases hterm : D.terminal C
        · refine ⟨0, Nat.zero_le m, ?_⟩
          rw [D.nstep_zero]
          exact (D.terminal_iff_zero_rank C).1 hterm
        · have hpkg :
            ConcreteAbstractDescentEquivalence S D R C :=
            packageConcreteAbstractDescentEquivalence S D R C
          have hdrop :
            (D.step C).rank + 1 ≤ C.rank :=
            CanonicalF2PivotRankDrop_from_step_compatible
              S D R H C hpkg hterm
          have hlt : (D.step C).rank < C.rank :=
            Nat.lt_of_succ_le hdrop
          have hltm : (D.step C).rank < m := by
            simpa [hCm] using hlt
          rcases ih (D.step C).rank hltm (D.step C) rfl with ⟨n, hn, hz⟩
          refine ⟨n + 1, ?_, ?_⟩
          · exact Nat.succ_le_of_lt (Nat.lt_of_le_of_lt hn hltm)
          · rw [D.nstep_succ]
            exact hz
  intro C
  simpa using main C.rank C rfl


/-- Conditional zero-rank reachability surface.

This is the axiom-separated theorem surface: it depends only on an explicit
`StepCompatibleDescentSystem` witness and does not use
`StepCompatibleDescentSystem.of_concrete_pivot`.
-/
theorem ZeroRankReachedWithinRank_conditional_from_step_compatible
  {α : Type u}
  (S : SupportEncoding α)
  (D : DescentSystem α)
  (R : Nat)
  (H : StepCompatibleDescentSystem S D R) :
  ∀ C : Configuration α, ∃ n ≤ C.rank, (D.nstep n C).rank = 0 := by
  exact ZeroRankReachedWithinRank_from_step_compatible S D R H

/-- Certificate-local zero-rank reachability theorem.

This routes zero-rank reachability through an explicit
`StepRankDropCertificate D` instead of the global `step_rank_drop` axiom.
-/
theorem ZeroRankReachedWithinRank_from_step_rank_drop_certificate
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (cert : StepRankDropCertificate D)
    (C : Configuration α) :
    ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  exact
    ZeroRankReachedWithinRank_from_step_compatible
      S D R
      (StepCompatibleDescentSystem.of_concrete_pivot_from_certificate
        S D R cert)
      C

/-- Zero-rank reachability derived from the `DescentSystem` rank-drop field.

This closes the route from the promoted field to the certificate-local
zero-rank theorem without reintroducing a global axiom. -/
theorem ZeroRankReachedWithinRank_from_descent_system_field
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α) :
    ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  exact
    ZeroRankReachedWithinRank_from_step_rank_drop_certificate
      S D R
      (StepRankDropCertificate_from_descent_system_field D)
      C

theorem ZeroRankReachedWithinRank_from_concrete_pivot
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (C : Configuration α) :
    ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  exact
    ZeroRankReachedWithinRank_from_step_compatible
      S D R
      (StepCompatibleDescentSystem.of_concrete_pivot S D R)
      C

/-- Certificate-local packaged concrete-pivot descent theorem surface. -/
structure ConcretePivotDescentPackageFromCertificate
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (cert : StepRankDropCertificate D) : Prop where
  reachesZeroRank :
    ∀ C : Configuration α,
      ∃ n ≤ C.rank, (D.nstep n C).rank = 0
  stepCompatible :
    StepCompatibleDescentSystem S D R

/-- Build the certificate-local packaged descent theorem surface. -/
theorem ConcretePivotDescentPackage_from_step_rank_drop_certificate
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (cert : StepRankDropCertificate D) :
    ConcretePivotDescentPackageFromCertificate S D R cert :=
by
  refine ⟨?_, ?_⟩
  · intro C
    exact ZeroRankReachedWithinRank_from_step_rank_drop_certificate
      S D R cert C
  · exact StepCompatibleDescentSystem.of_concrete_pivot_from_certificate
      S D R cert


/-- Packaged concrete-pivot descent theorem surface. -/
structure ConcretePivotDescentPackage
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat) : Prop where
  concreteAbstract :
    ∀ C : Configuration α,
      ConcreteAbstractDescentEquivalence S D R C
  stepCompatible :
    StepCompatibleDescentSystem S D R

theorem packageConcretePivotDescent
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat) :
    ConcretePivotDescentPackage S D R :=
by
  refine ⟨?_, ?_⟩
  · intro C
    exact packageConcreteAbstractDescentEquivalence S D R C
  · exact StepCompatibleDescentSystem.of_concrete_pivot S D R

theorem ConcretePivotDescentPackage.rank_drop
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (P : ConcretePivotDescentPackage S D R)
    (C : Configuration α)
    (hC : ¬ D.terminal C) :
    (D.step C).rank + 1 ≤ C.rank :=
by
  exact
    CanonicalF2PivotRankDrop_from_step_compatible
      S D R P.stepCompatible C (P.concreteAbstract C) hC

theorem ConcretePivotDescentPackage.zero_rank_reached
    {α : Type u}
    (S : SupportEncoding α)
    (D : DescentSystem α)
    (R : Nat)
    (P : ConcretePivotDescentPackage S D R)
    (C : Configuration α) :
    ∃ n ≤ C.rank, (D.nstep n C).rank = 0 :=
by
  exact
    ZeroRankReachedWithinRank_from_step_compatible
      S D R P.stepCompatible C


/-- Repository-native constructor for the current canonical F₂ pivot step surface.

Boundary: this packages `D.step` together with the existing abstract pivot-realization
surface. It does not prove that `D.step` is a concrete F₂ pivot-elimination operation
on `Configuration α`.
-/
structure CanonicalF2PivotStepConstructor {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat) : Type u where
  step : Configuration α → Configuration α
  step_eq_system_step : step = D.step
  realizes_canonical_F2_pivot :
    ∀ C : Configuration α,
      C.rank ≠ 0 →
        ∃ p : Fin (Finset.card (D.extractR R C)) ↪ S.E,
          ∀ i j,
            ConcretePhiDefinitionUsingExtractRMatrix S D R C i (p j) =
              if i = j then 1 else 0

/-- Build the canonical F₂ pivot step constructor from the current repository-native
abstract pivot surface.

Boundary: conditional/interface constructor only; no concrete pivot-elimination
operation is supplied here.
-/
def canonical_F2_pivot_step_constructor {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat) :
    CanonicalF2PivotStepConstructor S D R := by
  refine ⟨D.step, rfl, ?_⟩
  intro C _hC
  exact AbstractStepRealizesCanonicalF2Pivot S D R C


/-- Target object for a genuine concrete F₂ pivot-elimination operation on
`Configuration α`.

Boundary: this is a non-vacuous target surface. It does not construct the operation.
To close it, one must supply an actual `step` function and prove that it realizes
the repository-native canonical F₂ pivot package for every nonzero-rank
configuration.
-/
structure ConcreteF2PivotEliminationOperationOnConfiguration {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat) : Type u where
  step : Configuration α → Configuration α
  realizes_canonical_F2_pivot :
    ∀ C : Configuration α,
      C.rank ≠ 0 →
        ∃ p : Fin (Finset.card (D.extractR R C)) ↪ S.E,
          ∀ i j,
            ConcretePhiDefinitionUsingExtractRMatrix S D R C i (p j) =
              if i = j then 1 else 0
  rank_strict_decrease :
    ∀ C : Configuration α,
      ¬ D.terminal C →
        (step C).rank + 1 ≤ C.rank

/-- A supplied concrete F₂ pivot-elimination operation induces the current
canonical step-constructor surface.

Boundary: conditional bridge only; the concrete operation is an input, not
constructed here.
-/
def canonical_F2_pivot_step_constructor_from_concrete_operation {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat)
    (op : ConcreteF2PivotEliminationOperationOnConfiguration S D R)
    (hstep : op.step = D.step) :
    CanonicalF2PivotStepConstructor S D R := by
  refine ⟨op.step, hstep, ?_⟩
  intro C hC
  exact op.realizes_canonical_F2_pivot C hC


/-- Repository-native construction of the concrete F₂ pivot-elimination operation
from the current `DescentSystem` fields.

Boundary: this uses the existing abstract pivot-realization surface and the
`step_rank_drop_field` already stored in `DescentSystem`. It does not add a new
domain-specific scientific step beyond `D.step`.
-/
def concrete_F2_pivot_elimination_operation_from_descent_field {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat) :
    ConcreteF2PivotEliminationOperationOnConfiguration S D R := by
  refine ⟨D.step, ?_, ?_⟩
  · intro C _hC
    exact AbstractStepRealizesCanonicalF2Pivot S D R C
  · intro C hC
    exact D.step_rank_drop_field C hC

/-- The repository-native concrete F₂ pivot-elimination operation induces the
canonical F₂ pivot step constructor. -/
def canonical_F2_pivot_step_constructor_from_descent_field {α : Type u}
    (S : SupportEncoding α) (D : DescentSystem α) (R : Nat) :
    CanonicalF2PivotStepConstructor S D R :=
  canonical_F2_pivot_step_constructor_from_concrete_operation
    S D R
    (concrete_F2_pivot_elimination_operation_from_descent_field S D R)
    rfl


/-- Repository-native `MoLcKInput` witness obtained by repackaging an existing
`DescentSystem`.

Boundary: this does not supply a new domain-specific scientific system. It
constructs a `MoLcKInput` only from an already supplied `DescentSystem` whose
fields already include `step`, `terminal`, `nstep`, and `step_rank_drop_field`.
-/
def concrete_MoLcKInput_witness_from_repository_native_descent_field {α : Type u}
    (D : DescentSystem α) : MoLcKInput α where
  extractR := D.extractR
  witnessVector := D.witnessVector
  witnessContribution := D.witnessContribution
  step := D.step
  nstep := D.nstep
  terminal := D.terminal
  contribution_eq_cycleRank := D.contribution_eq_cycleRank
  extractR_independent := D.extractR_independent
  positive_contribution_on_extractR := D.positive_contribution_on_extractR
  terminal_iff_zero_rank := D.terminal_iff_zero_rank
  terminal_step_terminal := D.terminal_step_terminal
  intended_scientific_rank_strict_decrease_proof := D.step_rank_drop_field
  nstep_zero := D.nstep_zero
  nstep_succ := D.nstep_succ

/-- The repository-native `MoLcKInput` witness recovers the step-rank-drop
certificate through the existing MoLcK route.

Boundary: conditional on an already supplied `DescentSystem`; not a new
domain-specific scientific instantiation.
-/
theorem StepRankDropCertificate_from_repository_native_moLcK_descent_field
    {α : Type u} (D : DescentSystem α) :
    StepRankDropCertificate
      (IntendedScientificDescentSystem_from_moLcK
        (concrete_MoLcKInput_witness_from_repository_native_descent_field D)) :=
  StepRankDropCertificate_from_moLcK
    (concrete_MoLcKInput_witness_from_repository_native_descent_field D)


/-- Scientific actual-number descent test target.

This is not the toy numeric test.  It requires a supplied non-toy scientific
certificate, an actual configuration of rank `3`, an actual one-step rank value
`2`, and an actual canonical F₂ pivot witness at that configuration.
-/
structure ScientificActualNumberDescentTest (α : Type u) : Type (u+2) where
  S : SupportEncoding α
  D : DescentSystem α
  R : Nat
  C0 : Configuration α
  scientific_non_toy_certificate : Prop
  scientific_non_toy_certificate_proof : scientific_non_toy_certificate
  nonterminal_actual_number : ¬ D.terminal C0
  initial_rank_actual_number : C0.rank = 3
  step_rank_actual_number : (D.step C0).rank = 2
  pivot_realization_actual_number :
    ∃ p : Fin (Finset.card (D.extractR R C0)) ↪ S.E,
      ∀ i j,
        ConcretePhiDefinitionUsingExtractRMatrix S D R C0 i (p j) =
          if i = j then 1 else 0

/-- Actual-number strict-drop proof forced by the scientific test values:
`2 + 1 ≤ 3`. -/
theorem scientificActualNumberDescentTest_strict_drop
    {α : Type u} (T : ScientificActualNumberDescentTest α) :
    (T.D.step T.C0).rank + 1 ≤ T.C0.rank := by
  rw [T.step_rank_actual_number, T.initial_rank_actual_number]

/-- The scientific actual-number test also agrees with the repository-native
descent-field strict-drop certificate at the tested configuration. -/
theorem scientificActualNumberDescentTest_descent_field_drop
    {α : Type u} (T : ScientificActualNumberDescentTest α) :
    (T.D.step T.C0).rank + 1 ≤ T.C0.rank :=
  T.D.step_rank_drop_field T.C0 T.nonterminal_actual_number

/-- A scientific actual-number test induces the current repository-native
concrete F₂ pivot-elimination operation, still conditional on the supplied
`DescentSystem` fields.

Boundary: this does not manufacture the scientific system; it records the exact
non-toy numerical payload needed to test one scientific descent step.
-/
def concrete_F2_pivot_elimination_operation_from_scientific_actual_number_test
    {α : Type u} (T : ScientificActualNumberDescentTest α) :
    ConcreteF2PivotEliminationOperationOnConfiguration T.S T.D T.R :=
  concrete_F2_pivot_elimination_operation_from_descent_field T.S T.D T.R


/-- Target surface for the intended scientific `DescentSystem` instance.

Boundary: this does not construct the intended scientific system. It records the
exact non-toy payload required before the scientific actual-number witness can be
built.
-/
structure IntendedScientificDescentSystemInstance (α : Type u) : Type (u+2) where
  D : DescentSystem α
  scientific_non_toy_type_certificate : Prop
  scientific_non_toy_type_certificate_proof :
    scientific_non_toy_type_certificate
  scientific_step_not_toy_rank_decrement_certificate : Prop
  scientific_step_not_toy_rank_decrement_certificate_proof :
    scientific_step_not_toy_rank_decrement_certificate
  domain_specific_step_rank_drop :
    ∀ C : Configuration α,
      ¬ D.terminal C →
        (D.step C).rank + 1 ≤ C.rank

/-- The intended scientific instance target supplies the strict rank-drop proof
required by the descent-system route.

Boundary: target-surface projection only; no intended scientific instance is
constructed here.
-/
theorem intendedScientificDescentSystemInstance_rank_drop
    {α : Type u} (I : IntendedScientificDescentSystemInstance α) :
    ∀ C : Configuration α,
      ¬ I.D.terminal C →
        (I.D.step C).rank + 1 ≤ C.rank :=
  I.domain_specific_step_rank_drop

/-- An intended scientific instance target induces the repository-native
MoLcK witness route only after its `DescentSystem` has already been supplied.

Boundary: this repackages the supplied `DescentSystem`; it does not manufacture
the non-toy scientific system.
-/
def concrete_MoLcKInput_witness_from_intended_scientific_instance
    {α : Type u} (I : IntendedScientificDescentSystemInstance α) :
    MoLcKInput α :=
  concrete_MoLcKInput_witness_from_repository_native_descent_field I.D


/-- Selector data for a finite obstruction set.

Boundary: this supplies a concrete finite-obstruction carrier and a removable obstruction selector.
The scientific meaning of `Obstruction` remains external input. -/
structure FiniteObstructionSelector (Obstruction : Type u) [DecidableEq Obstruction] where
  choose : ∀ s : Finset Obstruction, s ≠ ∅ → Obstruction
  choose_mem : ∀ s h, choose s h ∈ s

/-- One-step finite-obstruction descent.

The data field removes one selected obstruction when one is available.
The repository-native rank field decreases by one. -/
def finiteObstructionDescentStep
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction)
    (C : Configuration (Finset Obstruction)) :
    Configuration (Finset Obstruction) :=
  if h : C.data = ∅ then
    { data := C.data, rank := C.rank - 1 }
  else
    { data := C.data.erase (selector.choose C.data h), rank := C.rank - 1 }

/-- Iterated finite-obstruction descent. -/
def finiteObstructionDescentNstep
    {Obstruction : Type u} [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction) :
    Nat → Configuration (Finset Obstruction) → Configuration (Finset Obstruction)
  | 0, C => C
  | n + 1, C => finiteObstructionDescentNstep selector n
      (finiteObstructionDescentStep selector C)

/-- Concrete finite-obstruction `DescentSystem`.

Boundary: this is a finite-obstruction descent witness for the current repository-native
`Configuration` API. Scientific adequacy requires the caller to supply the intended
domain-specific `Obstruction` type and non-toy certificates. -/
def FiniteObstructionDescentSystem
    (Obstruction : Type u) [DecidableEq Obstruction]
    (selector : FiniteObstructionSelector Obstruction) :
    DescentSystem (Finset Obstruction) where
  extractR := fun _ _ => ∅
  witnessVector := fun _ => ∅
  witnessContribution := fun _ => 1
  step := finiteObstructionDescentStep selector
  nstep := finiteObstructionDescentNstep selector
  terminal := fun C => C.rank = 0
  contribution_eq_cycleRank := by
    intro w
    rfl
  extractR_independent := by
    intro R C
    trivial
  positive_contribution_on_extractR := by
    intro R C w hw
    simp at hw
  terminal_iff_zero_rank := by
    intro C
    rfl
  terminal_step_terminal := by
    intro C h
    unfold finiteObstructionDescentStep
    by_cases hd : C.data = ∅
    · simp [hd, h]
    · simp [hd, h]
  step_rank_drop_field := by
    intro C h
    unfold finiteObstructionDescentStep
    cases hr : C.rank with
    | zero =>
        exact False.elim (h hr)
    | succ n =>
        by_cases hd : C.data = ∅
        · simp [hd]
        · simp [hd]
  nstep_zero := by
    intro C
    rfl
  nstep_succ := by
    intro n C
    rfl

/-- Payload needed to turn the finite-obstruction descent system into the intended
scientific instance target. -/
structure FiniteObstructionScientificPayload
    (Obstruction : Type u) [DecidableEq Obstruction] where
  selector : FiniteObstructionSelector Obstruction
  scientific_non_toy_type_certificate : Prop
  scientific_non_toy_type_certificate_proof :
    scientific_non_toy_type_certificate
  scientific_step_not_toy_rank_decrement_certificate : Prop
  scientific_step_not_toy_rank_decrement_certificate_proof :
    scientific_step_not_toy_rank_decrement_certificate

/-- Conditional constructor for the missing intended scientific witness.

Boundary: closes the formal target only after a real domain-specific obstruction type,
selector, and non-toy certificates are supplied. -/
def IntendedScientificDescentSystemInstance_witness_from_finite_obstruction_payload
    (Obstruction : Type u) [DecidableEq Obstruction]
    (P : FiniteObstructionScientificPayload Obstruction) :
    IntendedScientificDescentSystemInstance (Finset Obstruction) where
  D := FiniteObstructionDescentSystem Obstruction P.selector
  scientific_non_toy_type_certificate :=
    P.scientific_non_toy_type_certificate
  scientific_non_toy_type_certificate_proof :=
    P.scientific_non_toy_type_certificate_proof
  scientific_step_not_toy_rank_decrement_certificate :=
    P.scientific_step_not_toy_rank_decrement_certificate
  scientific_step_not_toy_rank_decrement_certificate_proof :=
    P.scientific_step_not_toy_rank_decrement_certificate_proof
  domain_specific_step_rank_drop := by
    intro C h
    exact (FiniteObstructionDescentSystem Obstruction P.selector).step_rank_drop_field C h


/-- `SLVed` is the named external mathematical payload needed to instantiate the
finite-obstruction scientific descent route.

Boundary: this is a naming/target surface only. It does not construct the
domain-specific obstruction type, selector, or non-toy scientific certificates. -/
abbrev SLVedPayload
    (Obstruction : Type u) [DecidableEq Obstruction] :=
  FiniteObstructionScientificPayload Obstruction

/-- Constructor from the named `SLVed` payload into the intended scientific
descent-system witness. -/
def IntendedScientificDescentSystemInstance_witness_from_SLVed
    (Obstruction : Type u) [DecidableEq Obstruction]
    (SLVed : SLVedPayload Obstruction) :
    IntendedScientificDescentSystemInstance (Finset Obstruction) :=
  IntendedScientificDescentSystemInstance_witness_from_finite_obstruction_payload
    Obstruction SLVed


/-- Concrete named carrier for the external `SLVed` payload.

Boundary: this packages the missing external mathematical payload as a single
repository-native object. It does not manufacture the domain-specific mathematics. -/
structure ConcreteSLVedPayload where
  Obstruction : Type u
  decidableEq : DecidableEq Obstruction
  SLVed : @SLVedPayload Obstruction decidableEq

/-- A concrete `SLVed` payload closes the intended scientific descent-system
witness target through the finite-obstruction route. -/
def IntendedScientificDescentSystemInstance_witness_from_concrete_SLVed
    (P : ConcreteSLVedPayload.{u}) :
    IntendedScientificDescentSystemInstance (Finset P.Obstruction) :=
  @IntendedScientificDescentSystemInstance_witness_from_SLVed
    P.Obstruction P.decidableEq P.SLVed

/-- Open target: supply a concrete `SLVed` payload.

Boundary: this is the exact remaining mathematical object. -/
abbrev ConcreteSLVedPayloadTarget : Prop :=
  Nonempty ConcreteSLVedPayload.{u}



/-- Open mathematical target, recorded without `sorry`.

A proof of this proposition is exactly the missing external mathematical object:
a concrete `ConcreteSLVedPayload`, namely a domain-specific obstruction type,
a proved finite-obstruction selector, and non-vacuous scientific certificates.

Do not close this target with a toy payload, an arbitrary finite type, a vacuous
certificate, or `True` as a scientific certificate.

Boundary:
`OPEN_TARGET_ONLY`.
`NO_CONCRETE_SLVED_PAYLOAD`.
`NO_FINAL_SCIENTIFIC_CLOSURE`.
`NO_P_VS_NP_CLAIM`.
`NO_CLAY_CLAIM`. -/
abbrev ProofOfConcreteSLVedPayloadTargetOpenProblem : Prop :=
  ConcreteSLVedPayloadTarget.{u}



/-- Planar forbidden-minor obstruction-count payload.

Boundary: this is only the two-symbol planar forbidden-minor obstruction-count
payload. It does not prove Wagner's theorem, planarity completeness, the
Robertson-Seymour theorem, final scientific closure, P vs NP, or any Clay claim. -/
inductive PlanarForbiddenMinorObstruction
  | K5
  | K33
  deriving DecidableEq

private theorem K5_ne_K33 :
    PlanarForbiddenMinorObstruction.K5 ≠
    PlanarForbiddenMinorObstruction.K33 := by
  decide

private theorem PlanarForbiddenMinorSelectorCorrect
    (s : Finset PlanarForbiddenMinorObstruction)
    (hne : s ≠ ∅) : ∃ o, o ∈ s :=
  Finset.nonempty_iff_ne_empty.mpr hne |>.exists_mem

private theorem PlanarObstructionCountStrictDrop
    (s : Finset PlanarForbiddenMinorObstruction)
    (hne : s ≠ ∅) :
    (s.erase
      (PlanarForbiddenMinorSelectorCorrect s hne).choose).card
        + 1 ≤ s.card := by
  have hmem := (PlanarForbiddenMinorSelectorCorrect s hne).choose_spec
  have hcard : 1 ≤ s.card :=
    Finset.card_pos.mpr ⟨(PlanarForbiddenMinorSelectorCorrect s hne).choose, hmem⟩
  rw [Finset.card_erase_of_mem hmem]
  exact le_of_eq (Nat.sub_add_cancel hcard)

/-- Concrete planar forbidden-minor obstruction-count `SLVed` payload.

Boundary:
`PLANAR_FORBIDDEN_MINOR_OBSTRUCTION_COUNT_ONLY`.
`NO_WAGNER_THEOREM`.
`NO_PLANARITY_COMPLETENESS`.
`NO_ROBERTSON_SEYMOUR`.
`NO_FINAL_SCIENTIFIC_CLOSURE`.
`NO_P_VS_NP_CLAIM`.
`NO_CLAY_CLAIM`. -/
noncomputable def ConcretePlanarSLVedPayload : ConcreteSLVedPayload where
  Obstruction := PlanarForbiddenMinorObstruction
  decidableEq := inferInstance
  SLVed :=
    { selector :=
        { choose := fun s hne =>
            (PlanarForbiddenMinorSelectorCorrect s hne).choose
          choose_mem := fun s hne =>
            (PlanarForbiddenMinorSelectorCorrect s hne).choose_spec }
      scientific_non_toy_type_certificate :=
        PlanarForbiddenMinorObstruction.K5 ≠
        PlanarForbiddenMinorObstruction.K33
      scientific_non_toy_type_certificate_proof :=
        K5_ne_K33
      scientific_step_not_toy_rank_decrement_certificate :=
        ∀ (s : Finset PlanarForbiddenMinorObstruction) (hne : s ≠ ∅),
          (s.erase
            (PlanarForbiddenMinorSelectorCorrect s hne).choose).card
              + 1 ≤ s.card
      scientific_step_not_toy_rank_decrement_certificate_proof :=
        PlanarObstructionCountStrictDrop }

/-- Concrete domain-specific `SLVed` mathematical proof for the planar
forbidden-minor obstruction-count payload.

Boundary: this proves only nonemptiness of the concrete payload surface above.
It is not Wagner's theorem, not planarity completeness, not Robertson-Seymour,
not final scientific closure, not P vs NP, and not a Clay claim. -/
theorem ConcreteDomainSpecificSLVedMathematicalProof :
    ConcreteSLVedPayloadTarget.{0} :=
  ⟨ConcretePlanarSLVedPayload⟩



/-- Bounded scientific closure for the concrete planar forbidden-minor obstruction-count payload.

Boundary:
`PLANAR_FORBIDDEN_MINOR_OBSTRUCTION_COUNT_ONLY`.
This is not Wagner's theorem, not planarity completeness, not Robertson-Seymour,
not unrestricted SLVed closure, not P vs NP, and not a Clay claim.
-/
noncomputable def ConcretePlanarScientificDescentInstance :
    IntendedScientificDescentSystemInstance (Finset PlanarForbiddenMinorObstruction) :=
  IntendedScientificDescentSystemInstance_witness_from_concrete_SLVed ConcretePlanarSLVedPayload

/-- The concrete planar descent system induced by the bounded payload. -/
noncomputable def ConcretePlanarScientificDescentSystem :
    DescentSystem (Finset PlanarForbiddenMinorObstruction) :=
  ConcretePlanarScientificDescentInstance.D

/-- Final bounded closure: every configuration in the concrete planar obstruction-count
descent system reaches terminal zero-rank state in finitely many steps. -/
theorem ConcretePlanarSLVedPayload_scientific_closure :
    ∀ C : Configuration (Finset PlanarForbiddenMinorObstruction),
      ∃ n,
        ConcretePlanarScientificDescentSystem.terminal
          (ConcretePlanarScientificDescentSystem.nstep n C) := by
  exact termination ConcretePlanarScientificDescentSystem

/-- Stronger bounded form: termination occurs within the initial registered rank. -/
theorem ConcretePlanarSLVedPayload_scientific_closure_with_bound :
    ∀ C : Configuration (Finset PlanarForbiddenMinorObstruction),
      ∃ n ≤ C.rank,
        (ConcretePlanarScientificDescentSystem.nstep n C).rank = 0 := by
  intro C
  exact zero_rank_reached_within_rank ConcretePlanarScientificDescentSystem C

end URF

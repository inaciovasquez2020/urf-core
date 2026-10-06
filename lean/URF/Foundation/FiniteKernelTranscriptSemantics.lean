import Mathlib
import URF.Foundation.FiniteTranscriptDistribution
import URF.Foundation.FlagshipFiniteKernelTheoremSurface

namespace URF.Foundation

open URF.Foundation.FlagshipFiniteKernelTheoremSurface

/--
Concrete finite transcript semantics for a kernel whose output law depends only
on the retained input. At each step the next observation is drawn from the
same transition law; the repeated conditionally-independent sampling semantics
are made explicit rather than derived from the one-step kernel interface.
-/
noncomputable def finiteKernelTranscriptDistribution
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β) :
    (T : ℕ) → FiniteTranscriptDistributionData α β T
  | 0 =>
      { joint := fun p => input.prob p.1
        nonneg := by
          intro p
          exact input.nonneg p.1
        sum_one := by
          simpa using input.sum_one }
  | T + 1 =>
      { joint := fun p =>
          let q := (transcriptPrefixLastEquiv β T) p.2
          (finiteKernelTranscriptDistribution input K T).joint (p.1, q.1) *
            (K.transition p.1).prob q.2
        nonneg := by
          intro p
          let q := (transcriptPrefixLastEquiv β T) p.2
          exact mul_nonneg
            ((finiteKernelTranscriptDistribution input K T).nonneg (p.1, q.1))
            ((K.transition p.1).nonneg q.2)
        sum_one := by
          let e :
              α × (Fin (T + 1) → β) ≃
                (α × (Fin T → β)) × β :=
            (Equiv.refl α).prodCongr (transcriptPrefixLastEquiv β T)
          rw [Fintype.sum_equiv e]
          simp only [Finset.sum_product]
          calc
            ∑ p : α × (Fin T → β), ∑ b : β,
                (finiteKernelTranscriptDistribution input K T).joint p *
                  (K.transition p.1).prob b
                =
                ∑ p : α × (Fin T → β),
                  (finiteKernelTranscriptDistribution input K T).joint p *
                    ∑ b : β, (K.transition p.1).prob b := by
                      apply Finset.sum_congr rfl
                      intro p hp
                      rw [Finset.mul_sum]
            _ =
                ∑ p : α × (Fin T → β),
                  (finiteKernelTranscriptDistribution input K T).joint p := by
                    apply Finset.sum_congr rfl
                    intro p hp
                    rw [(K.transition p.1).sum_one]
                    simp
            _ = 1 := (finiteKernelTranscriptDistribution input K T).sum_one }

theorem finiteKernelTranscriptDistribution_nonneg
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β)
    (T : ℕ) :
    ∀ p : α × (Fin T → β),
      0 ≤ (finiteKernelTranscriptDistribution input K T).joint p :=
  (finiteKernelTranscriptDistribution input K T).nonneg

theorem finiteKernelTranscriptDistribution_sum_one
    {α β : Type u}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (input : FinDist α)
    (K : FinKernel α β)
    (T : ℕ) :
    ∑ p, (finiteKernelTranscriptDistribution input K T).joint p = 1 :=
  (finiteKernelTranscriptDistribution input K T).sum_one

end URF.Foundation

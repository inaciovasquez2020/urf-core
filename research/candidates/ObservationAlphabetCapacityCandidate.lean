import URF.Foundation.FiniteTranscriptCapacityBound

namespace URF.Foundation.ObservationAlphabetAudit

noncomputable def swapDistribution
    {α β : Type u} [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] (P : FiniteMutualInformationData α β) :
    FiniteMutualInformationData β α where
  joint := fun p => P.joint (p.2, p.1)
  nonneg := fun p => P.nonneg (p.2, p.1)
  sum_one := by
    rw [Fintype.sum_prod_type]
    exact (Fintype.sum_prod_type_right P.joint).symm.trans P.sum_one

theorem swapDistribution_mutualInformation
    {α β : Type u} [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] (P : FiniteMutualInformationData α β) :
    finiteMutualInformation (swapDistribution P) = finiteMutualInformation P := by
  classical
  unfold finiteMutualInformation
  apply Fintype.sum_equiv (Equiv.prodComm β α)
  rintro ⟨y, x⟩
  change P.joint (x,y) * Real.log (P.joint (x,y) /
    ((∑ a : α, P.joint (a,y)) * (∑ b : β, P.joint (x,b)))) =
    P.joint (x,y) * Real.log (P.joint (x,y) /
    ((∑ b : β, P.joint (x,b)) * (∑ a : α, P.joint (a,y))))
  rw [mul_comm (∑ a : α, P.joint (a,y)) (∑ b : β, P.joint (x,b))]

theorem finiteMutualInformation_le_log_card_right
    {α β : Type u} [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β] (P : FiniteMutualInformationData α β) :
    finiteMutualInformation P ≤ Real.log (Fintype.card β) := by
  rw [← swapDistribution_mutualInformation P]
  exact finiteMutualInformation_le_log_card_left (swapDistribution P)

theorem transcript_mutual_information_le_time_log_card_observation
    {α β : Type u} {T : ℕ}
    [DecidableEq α] [DecidableEq β] [Fintype α] [Fintype β]
    (P : FiniteTranscriptDistributionData α β T) :
    transcriptMutualInformation P ≤ T * Real.log (Fintype.card β) := by
  have h := finiteMutualInformation_le_log_card_right
    (transcriptMutualInformationData P)
  change transcriptMutualInformation P ≤
    Real.log (Fintype.card (Fin T → β)) at h
  simpa only [Fintype.card_fun, Fintype.card_fin, Nat.cast_pow, Real.log_pow] using h

#print axioms swapDistribution
#print axioms swapDistribution_mutualInformation
#print axioms finiteMutualInformation_le_log_card_right
#print axioms transcript_mutual_information_le_time_log_card_observation

end URF.Foundation.ObservationAlphabetAudit

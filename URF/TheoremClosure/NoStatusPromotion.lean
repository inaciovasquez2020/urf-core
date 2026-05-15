namespace URF

inductive ClosureStatus where
  | frontier_open
  | certified_frontier
  | conditional
  | solved
  deriving DecidableEq, Repr

def closureStatusRank : ClosureStatus → Nat
  | .frontier_open => 0
  | .certified_frontier => 1
  | .conditional => 2
  | .solved => 3

def StatusPromotion (source target : ClosureStatus) : Prop :=
  closureStatusRank source < closureStatusRank target

structure ClosureTransfer where
  sourceStatus : ClosureStatus
  targetStatus : ClosureStatus
  status_nonincrease :
    closureStatusRank targetStatus ≤ closureStatusRank sourceStatus

theorem no_status_promotion_closed
    (T : ClosureTransfer) :
    ¬ StatusPromotion T.sourceStatus T.targetStatus := by
  intro h
  exact Nat.not_lt_of_ge T.status_nonincrease h

theorem frontier_open_cannot_transfer_to_solved_closed
    (T : ClosureTransfer)
    (h_source : T.sourceStatus = ClosureStatus.frontier_open) :
    T.targetStatus ≠ ClosureStatus.solved := by
  intro h_target
  have hle := T.status_nonincrease
  rw [h_source, h_target] at hle
  simp [closureStatusRank] at hle

theorem solved_target_requires_solved_source_rank_closed
    (T : ClosureTransfer)
    (h_target : T.targetStatus = ClosureStatus.solved) :
    closureStatusRank ClosureStatus.solved ≤ closureStatusRank T.sourceStatus := by
  rw [← h_target]
  exact T.status_nonincrease

end URF

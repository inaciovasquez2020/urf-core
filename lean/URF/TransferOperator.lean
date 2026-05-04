namespace URF

inductive URFStatus where
  | frontier_open
  | certified_frontier
  | conditional
  | solved
deriving DecidableEq, Repr

def statusRank : URFStatus → Nat
  | .frontier_open      => 0
  | .certified_frontier => 1
  | .conditional        => 2
  | .solved             => 3

def StatusPromotes (s t : URFStatus) : Prop :=
  statusRank s < statusRank t

structure URFSurface where
  State        : Type
  Boundary     : State → Prop
  Invariant    : State → Type
  Certificate  : State → Prop
  Status       : State → URFStatus
  admissible   : State → Prop
  status_sound :
    ∀ {x : State},
      admissible x →
      Boundary x →
      Certificate x →
      statusRank URFStatus.certified_frontier ≤ statusRank (Status x)

structure TransferOperator (A B : URFSurface) where
  map_state :
    A.State → B.State

  map_certificate :
    ∀ {x : A.State},
      A.Certificate x →
      B.Certificate (map_state x)

  preserve_admissible :
    ∀ {x : A.State},
      A.admissible x →
      B.admissible (map_state x)

  preserve_boundary :
    ∀ {x : A.State},
      A.Boundary x →
      B.Boundary (map_state x)

  invariant_pullback :
    ∀ {x : A.State},
      B.Invariant (map_state x) → A.Invariant x

  status_nonincrease :
    ∀ {x : A.State},
      statusRank (B.Status (map_state x)) ≤ statusRank (A.Status x)

structure CertifiedFrontier (A : URFSurface) where
  x    : A.State
  adm  : A.admissible x
  bdry : A.Boundary x
  cert : A.Certificate x

def CertifiedFrontier.transport
  {A B : URFSurface}
  (T : TransferOperator A B)
  (F : CertifiedFrontier A) :
  CertifiedFrontier B where
  x := T.map_state F.x
  adm := T.preserve_admissible F.adm
  bdry := T.preserve_boundary F.bdry
  cert := T.map_certificate F.cert

theorem transfer_no_status_promotion
  {A B : URFSurface}
  (T : TransferOperator A B)
  {x : A.State} :
  ¬ StatusPromotes (A.Status x) (B.Status (T.map_state x)) :=
by
  intro h
  exact Nat.not_lt_of_ge T.status_nonincrease h

theorem CertifiedFrontier.transport_status_nonincrease
  {A B : URFSurface}
  (T : TransferOperator A B)
  (F : CertifiedFrontier A) :
  statusRank (B.Status (CertifiedFrontier.transport T F).x)
    ≤
  statusRank (A.Status F.x) :=
by
  exact T.status_nonincrease (x := F.x)

theorem CertifiedFrontier.transport_no_status_promotion
  {A B : URFSurface}
  (T : TransferOperator A B)
  (F : CertifiedFrontier A) :
  ¬ StatusPromotes
      (A.Status F.x)
      (B.Status (CertifiedFrontier.transport T F).x) :=
by
  intro h
  exact Nat.not_lt_of_ge
    (CertifiedFrontier.transport_status_nonincrease T F)
    h

theorem CertifiedFrontier.transport_target_status_sound
  {A B : URFSurface}
  (T : TransferOperator A B)
  (F : CertifiedFrontier A) :
  statusRank URFStatus.certified_frontier
    ≤
  statusRank (B.Status (CertifiedFrontier.transport T F).x) :=
by
  exact B.status_sound
    (CertifiedFrontier.transport T F).adm
    (CertifiedFrontier.transport T F).bdry
    (CertifiedFrontier.transport T F).cert

theorem transfer_target_solved_requires_source_rank_at_least_solved
  {A B : URFSurface}
  (T : TransferOperator A B)
  {x : A.State}
  (h : B.Status (T.map_state x) = URFStatus.solved) :
  statusRank (A.Status x) ≥ statusRank URFStatus.solved :=
by
  simpa [h] using T.status_nonincrease (x := x)

theorem transfer_cannot_promote_frontier_open_to_solved
  {A B : URFSurface}
  (T : TransferOperator A B)
  {x : A.State}
  (hA : A.Status x = URFStatus.frontier_open) :
  B.Status (T.map_state x) ≠ URFStatus.solved :=
by
  intro hB
  have hle := T.status_nonincrease (x := x)
  simp [hA, hB, statusRank] at hle

end URF

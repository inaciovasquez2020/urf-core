namespace URF

/--
A finite transcript history whose next state deterministically retains the
previous state.  This is a structural recoverability interface only: it does
not define probability measures, mutual information, entropy, or a chain rule.
-/
structure AccumulatingTranscriptHistory where
  horizon : Nat
  Sample : Type
  Snapshot : Type
  state : Nat → Sample → Snapshot
  recoverPrevious : Nat → Snapshot → Snapshot
  recover_previous :
    ∀ t : Nat, t < horizon → ∀ ω : Sample,
      recoverPrevious t (state (t + 1) ω) = state t ω

def AccumulatingTranscriptHistory.status : String :=
  "ACCUMULATING_TRANSCRIPT_HISTORY_INTERFACE_ONLY_NO_INFORMATION_THEORETIC_CHAIN_RULE"

def AccumulatingTranscriptHistory.nextAdmissibleObject : String :=
  "FINITE_ACCUMULATING_TRANSCRIPT_CHAIN_RULE_DERIVATION"

end URF

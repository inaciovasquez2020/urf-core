import Mathlib

namespace URF

/--
Concrete F₂ matrix descent state.

This is only the concrete carrier needed before defining the bridge map
from `Configuration α` through `extractRMatrix`.
-/
structure F2DescentState (n m : Nat) where
  matrix : Matrix (Fin n) (Fin m) (ZMod 2)
  rank : Nat

namespace F2DescentState

def descentRank {n m : Nat} (S : F2DescentState n m) : Nat :=
  S.rank

theorem descentRank_eq_rank {n m : Nat} (S : F2DescentState n m) :
    descentRank S = S.rank :=
  rfl

end F2DescentState

end URF

# Vertex Boundary Transport Frontier

Status: Conditional.

The Lean file `chronos/Transport/VertexBoundaryTransport.lean` has no `admit`.

The remaining mathematical frontier is the explicit entropy growth axiom:

```lean
axiom entropy_mul_card_bound
  (C n : Nat) :
  entropy_of_set (C * n) ≤ entropy_of_set n + (C * InfoStepBound)
Boundary:
This does not prove entropy transport unconditionally.
This replaces the local admit with a named frontier axiom.
Build success verifies artifact integrity only.

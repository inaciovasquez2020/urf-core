The Unified Capacity–Locality Problem

Problem Statement.
Consider any oracle-free, uniform, polynomial-time computation.

Question.
Is it true that every such computation admits a simulation by a process that:

1. Operates only on bounded-radius local state
2. Injects at most polylogarithmic information per step
3. Has total progress (entropy reduction or structural refinement)
   bounded by total injected information

Equivalently:
Is global computational progress universally limited by local information capacity?

Significance.
A positive answer implies:
- Local refinement is complete for polynomial-time computation
- EntropyDepth is a universal obstruction
- Superlinear entropy lower bounds imply P ≠ NP

A negative answer implies:
- Existence of irreducibly global polynomial-time computation
- Failure of locality as a fundamental principle of computation
- Breakdown of information-accounting limits

Either resolution forces a foundational revision of complexity theory.


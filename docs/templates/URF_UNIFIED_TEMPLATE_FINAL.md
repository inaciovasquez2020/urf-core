# URF Unified Template (Final)

## Evolution Regimes
T(α):
- α < 1  → Ω(n)
- α = 1  → Ω(n / log n)
- α > 1  → O(log n)

## Kernel Decomposition
Σ = Σ_ker ⊕ Σ_acc  
Π_{k,R}(Σ_ker) = 0

## Chronos Functional
T ≥ H(I*) / Cap_step(α)

## Capacity Scaling
- α < 1  → Θ(1)
- α = 1  → Θ(log n)
- α > 1  → Θ(n^γ)

## Applications
### Distributed Computing
Local consensus requires Ω(n) rounds under locality constraints.

### Quantum Topology
Logical states protected in Σ_ker; local noise cannot access.

## Principle
Locality ∩ Capacity ∩ Topology ⇒ Phase-Dependent Rigidity

# URF Dependency DAG

```mermaid
graph TD
  A[urf-core]

  A --> B[chronos-urf-rr]
  A --> C[scientific-infrastructure]
  A --> D[urf-verifier]
  A --> E[urf-axioms]
  A --> F[urf-spine]
  A --> G[urf-core-verifier]
  A --> H[cycle-local-rigidity]
  A --> I[capacity-locality-certification]
  A --> J[urf-counterexamples]
  A --> K[urf-minimal-obstruction]
  A --> L[urf-open-review-ledger]
  A --> M[urf-reductions-sat-csp]
  A --> N[cslib-fmt]
  A --> O[overlap-rigidity-lean]
  A --> P[support-drift]
  A --> Q[terminal-rigidity-witness-erb]
  A --> R[owc-counterexamples]
  A --> S[inaciovasquez2020]

  E --> B
  F --> B
  C --> D
  D --> G
  N --> H
  H --> I
  J --> I
  K --> J
  L --> D
  M --> B
  O --> H
  P --> B
  Q --> I

  B --> T[radiative-rigidity]
  B --> U[dfm-mkc-cosmology]
  B --> V[pachner-invariant]
  B --> W[urf-application-stress-test]
  B --> X[urc-minimal-blockchain]
  H --> Y[rank-dichotomy-cat0]

  B -. exploratory .-> Z[clay-problem-lab]
  B -. exploratory .-> AA[ym-spectral-wall-next]
  B -. exploratory .-> AB[cells-downwards-rh]
  H -. dev .-> AC[overlap-rigidity-lean-dev]

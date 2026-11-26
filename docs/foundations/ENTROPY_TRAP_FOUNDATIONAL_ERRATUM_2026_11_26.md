# Foundational entropy accounting and TRAP normalization erratum

Date: 2026-11-26. Paper-level proofs and counterexamples; Lean NOT_RUN; independent novelty NOT_ESTABLISHED. Base commit 322d1af0f2338b6b61df25cb342ca377a5441a95. This note supersedes the affected historical assertions only; frozen source blobs, theorem declarations and certificates are unchanged.

## 1. CE-Bridge is false with the stated evolving-state definitions

The historical CE-Bridge defines D_H = H(C_t)-H(C_{t+1}) and D_I = I(C_t;Pi_{t+1}|Pi_t). Let C_0=X be uniform on n bits, C_1 be a constant, and Pi_0=Pi_1 be constant. Then D_H=n and D_I=0. Even the asserted Markov condition holds, yet no finite universal f(0) bounds n. Erasing one bit at a time likewise refutes a linear-through-the-origin bound even with bounded writes. The claimed Markov chain C_t -> Pi_t -> Pi_{t+1}, if imposed, actually implies D_I=0; it does not imply an entropy-loss bound.

For finite random variables and nested transcripts (Pi_t is a deterministic function of Pi_{t+1}), the chain rule gives the exact identity:
```
H(C_t|Pi_t)-H(C_{t+1}|Pi_{t+1})
 = I(C_t;Pi_{t+1}|Pi_t)
   + H(C_t|C_{t+1},Pi_{t+1})
   - H(C_{t+1}|C_t,Pi_{t+1}).
```
Proof: subtract H(C_t|Pi_{t+1}) first, then expand H(C_t,C_{t+1}|Pi_{t+1}) in both orders. If C_t can be reconstructed from (C_{t+1},Pi_{t+1}), the positive erasure term vanishes and a one-sided bound follows; if the transition is also deterministic given (C_t,Pi_{t+1}), equality follows. These are conditional-entropy results, not a repair of the original unconditional marginal-entropy expression.

For a fixed hidden finite X, E_t=H(X|Pi_t) gives exactly E_t-E_{t+1}=I(X;Pi_{t+1}|Pi_t). Thus if each increment is at most c>0, T >= (E_0-E_T)/c. Full recovery and input-independent initial transcript are necessary to replace the numerator by H(X). For decision of a deterministic target Y=g(X), the same theorem holds with Y in place of X; a binary decision target has at most one bit of entropy, and deciding it need not reconstruct X. A separate semantic obstruction (query support, communication, etc.) is needed for large decision lower bounds.

## 2. Entropy contraction is not time

The historical sum ED=sum_t (H(C_t)-H(C_{t+1})) telescopes to H(C_0)-H(C_T). If C_0 is determined by an n-bit input and fixed parameters, ED<=n, regardless of execution time. Padding by identity steps does not change ED; an irreversible state transition can reduce entropy without producing an observation. The net contraction cannot itself be a general time or refinement-depth invariant in the sense of recovering elapsed rounds. For fixed hidden X and nested observations the alternative sum is also telescoping, but has the justified monotonicity and capacity inequality in Section 1. Keep elapsed rounds, total work, observation capacity and target uncertainty separate. The historical simulation inequality is not established by the supplied CE-Bridge proof. A valid transfer requires the actual per-step cap and a nontrivial terminal residual-entropy requirement.

## 3. Restricted expanded-graph normalization

For a fixed deterministic single-tape Turing machine M with fixed alphabet and finite control, choose a known input-length-dependent horizon T and a tape interval containing every visited cell plus blank boundary padding. Encode each cell by its symbol and either no head or the head/control state. A deterministic radius-one rule on the preceding row implements each machine step: a head writes its new symbol, control moves to the adjacent cell prescribed by the transition (or remains), and other symbols persist. Pad halting by an absorbing configuration. Legal initial rows have exactly one head; induction proves all subsequent rows are the exact configurations.

Make an expanded graph with a vertex for each (time,cell), and directed distinct L,C,R dependency edges from each of the at most three preceding-row cells to its successor cell; use fixed boundary constants as needed. This graph has bounded degree and size O((T+1)(n+T+1)), with a finite input-independent wiring scheme given n,T. Initial symbols/head are encoded at row zero; other facts start unknown. A monotone synchronous rule accumulates the unique state fact at a vertex once all predecessor states are known, retaining old facts. The transition table is finite. A fixed-variable FO formula with variables for the destination and three predecessors and a finite disjunction of state cases performs each update; old facts are kept by disjunction. By induction all rows through t are known after t rounds, and the row t is exact. Edge-labeled directed one-dimensional WL color refinement on the initial graph (with separate incoming edge labels and fixed initial labels) also admits a fixed stage-independent local decoder for these facts: decode the old color, then decode predecessor colors by label and use the transition table when the three states are known. Each color records the old color and labeled neighbor-color multiset. The decoder is defined recursively on the color representation, not asserted to be an ordinary FO^k type equivalence. Extra WL distinctions need not correspond to machine information. Fixed-point iteration and formula depth must be distinguished.

If a chosen machine observation transcript consists of specified deterministic readouts of the successive rows, the normalized simulation can emit those exact same readouts; their joint laws and conditional entropy increments agree for every input distribution. This is selected-transcript preservation only. It says nothing about the entropy of all accumulated facts or full WL colors, nor does bounded per-cell update imply bounded aggregate observation capacity. Sequential work and original-machine time are not identified with simultaneous vertex updates. The graph includes auxiliary space-time geometry; its construction does not establish locality in the original SAT incidence graph.

## 4. Strict original-instance locality cannot be universal

Consider F0=(x) AND (y) AND (y), and F1=(x) AND (y) AND (NOT y), where clause occurrences are distinct vertices in the signed variable-clause incidence graph. Their x-components coincide; F0 is satisfiable and F1 is not. Suppose initialization of every vertex depends only on its own connected component (common input-independent parameters allowed), every update is a bounded-distance function of earlier states on the original graph, and the fixed output vertex is x. By induction all states in the x-component coincide in both runs at every round. Hence this model cannot decide SAT, even with unlimited rounds. Input-dependent global preprocessing, global readout or auxiliary edges can escape this argument, but must be specified and charged separately. On connected graphs radius-r updates similarly have radius-rt causal cones after t rounds; this conclusion fails for arbitrary graph expansions adding shortcuts.

This refutes the strict fixed-output/component-preserving interpretation of TRAP, not every possible precise version of the original underspecified axiom. The original TRAP statement remains OPEN. The exact remaining contract is an encoding and output semantics plus proved preservation of the lower-bound model's information access, capacity and cost in both representations. Existence of a polynomial simulation alone gives at most an inverse-polynomial transfer of a depth lower bound if the simulated depth is bounded by a polynomial in original time. It does not prove constant distortion. The NST assertion that wiring and preprocessing are charged requires an actual cost and bound. No P vs NP conclusion follows.

## 5. Status surfaces and related limitations

The historical referee map and proven-results list cannot cite the false CE-Bridge as an unconditional equivalence between marginal entropy loss and transcript capacity. Valid fixed-hidden-variable accounting and separately verified finite-graph entropy/minimax theorems are retained. An Omega(n) lower bound alone does not exclude polynomial time; the referee map's claim that any polynomial-time refinement algorithm must violate H1-H3 requires a stronger argument than its displayed linear bound. The bounded-aggregation note's conjecture remains OPEN: bounding each gate does not bound aggregate information across parallel gates. The EF cycle-linkage sketch does not identify a valid Spoiler strategy or establish type separation; the corrected cycle-orbit-splitting note already identifies the homogeneous Petersen obstruction. Historical AC0 unconditional labels are superseded by the merged AC0 CSP erratum, not by a new universal theorem.

## Inspected source blobs

- docs/foundations/ce_bridge.md: 73cfe481f4cb6e0817170ad374b4d8ff8d0c66ca
- docs/foundations/entropydepth_simulation.md: d6f89787ce85b370563d5f78726d5b4ba0351359
- docs/foundations/nst.md: e4972d7ad2fce15255544dfeab05a6ab5e09e516
- docs/normalization/TRAP.md: 110a99183d0b3c70e1e350931540d685ab38ee40
- docs/referee/PROVEN_RESULTS.md: 51e1ab25292317f623ed4185a77752dd80427fb1
- docs/referee/REFEREE_MAP.md: b5e791290f0e511de5a54221c5db1e9ca1764788
- papers/fo-k-locality/ef_cycle_trap.tex: 7192e77f42a3d8c80b2ffd343729d3de4b835e9f
- papers/fo-k-locality/cycle_orbit_splitting.tex: 22d7c127a59a5b372daa461f77bff78ef424892b
- papers/ac0-csp/bounded-aggregation-note.md: 30b4d8253b9b462f4f8ad8ff1e9c89fef140fe37
- papers/ac0-csp/README.md: d42f238e40ab9b0b0296735145cd945e607933d0
- papers/ac0-csp/STATUS.md: c52749beebb10d82924ab5a93a4a321498439854
- docs/normalization/Referee-Checklist.md: fe2cb1b23297d84df1fc1d4c8c8f1bf2f4045d32

No claim is made about uninspected Lean declarations, external reviews, or new kernel verification.

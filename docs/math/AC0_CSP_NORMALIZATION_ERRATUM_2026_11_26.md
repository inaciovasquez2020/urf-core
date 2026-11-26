# AC0-local CSP separation and normalization: mathematical erratum

Date: 2026-11-26. Paper-level counterexamples and restricted replacement proofs. Lean verification NOT_RUN. Novelty not established.

## 1. Implication-chain example

The displayed unseeded instance x1 -> x2 -> ... -> xn has both the all-zero and all-one satisfying assignments. It has no unit clause to start unit propagation. Add the unit clause x1=1 and count time zero as the initial unit assignment. In synchronous unit propagation, with each round using only assignments available at the start of that round, after t rounds exactly the first min(n,t+1) variables are forced. Induction: the only new forward implication whose antecedent is known and consequent not yet known is the one from the last known vertex to its successor. Thus for n>=1 the process finishes in n-1 completed rounds. This is a theorem about that algorithm and initialization, not every solver, and not a bound on deciding satisfiability. A known satisfiable family may admit a constant decision or a uniform all-one output without simulating propagation.

## 2. Exact distributed replacement theorem

Let P_n be a path on n>=1 vertices. Each adjacent pair is constrained to have equal Boolean output, and the first vertex alone initially receives an arbitrary bit b. Fix all other initial data independently of b. Each vertex's state in the next synchronous round is a deterministic function of its own and neighboring states from the previous round; no input-dependent auxiliary initialization, global readout as a substitute for local outputs, or nonlocal communication is allowed. Require every vertex to produce its correct output for both seeds.

Induction on t shows that the state at vertex v after t rounds depends only on initial states in its radius-t ball. For t<n-1, the last vertex has identical states in the two executions b=0 and b=1, although its required output differs. Hence a correct algorithm needs at least n-1 rounds in the worst case. Broadcasting the bit one edge per round attains n-1, giving exact minimum depth. The argument also covers randomized algorithms required to be correct with probability one, by fixing a common seed outside the union of the two null failure events. More generally, before the bit reaches the final vertex, its output law is seed-independent under input-independent randomness, so its worst-case success probability is at most 1/2. For radius r>=1 access, the corresponding lower bound is ceil((n-1)/r); it is attained when the model permits direct communication with every vertex within distance r. This is a distributed output theorem, not an unconditional lower bound on SAT or arbitrary AC0-local CSP solvers.

## 3. Bounded fan-in does not imply a global information cap

For n independent uniform input bits located one per vertex, let each vertex copy its bit to its own output in one parallel radius-zero round. Every individual gate has fan-in one, and the update has bounded arity, but n output bits are jointly exposed. Relative to an initially input-independent observation transcript S0, H(X|S0)-H(X|S1)=n bits. This refutes an O(1) aggregate information cap derived solely from bounded local fan-in and arity. If the initial transcript already includes the complete input, conditional gain is instead zero; the observation convention matters.

For a bounded total number of local observations, a valid conditional entropy cap follows from a chain-rule accounting of the conditional entropy or mutual information of each observation. A bounded number of input dependencies per output gate does not bound the number of output gates. A fixed finite vocabulary and bounded arity do not prohibit simultaneously updating many relation tuples. Circuit-to-logic simulation requires the uniformity, vocabulary and encoding of circuit wiring to be specified. Bounded-depth bounded-fan-in circuits have bounded-size dependency cones per output, not necessarily geometric locality in the input graph or constant aggregate transcript entropy. The cited proof sketch does not establish preservation of EntropyDepth up to constant factors.

## 4. Bounded quantifier rank is not strict neighborhood locality

In a graph with unary predicate P, the formula (x=x) AND (exists y P(y)) has quantifier rank one. Changing P at a vertex outside the radius-r ball of x can change the formula's truth while leaving the rooted labeled ball unchanged. This works on connected paths of sufficiently large diameter. Gaifman locality does not say that arbitrary bounded-rank formulas are determined by one rooted ball; global sentence information can enter. Explicit ball-restricted semantics or a justified local formula fragment is required. Substitution of bounded-rank logic for finite-variable logic does not by itself preserve all prior results.

## 5. Control-information accounting

If M0 denotes the entire initial configuration of a deterministic fixed program, the complete instruction/address trace is a deterministic function of M0, so its conditional entropy given M0 is zero. If M0 excludes read-only random input, consider a fixed branching program that reads each of n independent uniform bits and takes one of two distinguishable control states, then joins before reading the next bit. The full control trace determines the input, so its entropy conditional on fixed data memory is n bits, with zero data-memory writes. Indirect addressing is unnecessary. If register or control-state changes themselves count as writes, this is a different accounting model and the counterexample must be interpreted accordingly. For variable write counts an expected-cost or pathwise formulation must also be specified. The asserted coupling needs precise state, conditioning and cost definitions; the supplied argument does not prove an equivalence to TRAP. TRAP remains an explicit assumption in its own source.

## 6. Publication status

The universal separation claim EDA_A(F)=Theta(n) for every solver and every frozen instance is not established by the inspected normalization argument and example. In particular a lower-bound argument alone cannot prove a universal upper bound, and a successful solver may incur unnecessary delay. The definition of frozen instance, admissible solvers, success/output, and EDA must be fixed before transferring a lower bound. The unrestricted separation and constant-distortion simulation are OPEN on the evidence supplied; this erratum does not claim a refutation of every precise possible version. Retain the valid restricted propagation result above.

Historical sources, frozen assumptions, PDFs, and Lean declarations remain unchanged. The following exact source blobs were identified at revision e21cd6de029dfa2f2eaf0183d3e8160e805ca9dd; this note supersedes the unsupported claims to the extent described above.

- docs/normalization/AC0-CSP-Separation.md (blob 26ebcd38eb2a2c673cd1c3adb0f748d029e37c97)
- docs/normalization/AC0-CSP.md (blob 0e6a489ee905adca5d52a05166f33d329f0145d6)
- docs/normalization/Bounded-Rank-Logic.md (blob 3b83e1f4798eecc00425c4a2872994111895e883)
- docs/normalization/Bstarstar-AC0-proof.md (blob 51f05acebc351d79b4d312f1ea54566d2d9739b3)
- docs/normalization/Bstarstar-AC0.md (blob 63e70262bf87393945ff3219044e9fff24ff7dbf)
- docs/normalization/Control-Information-Coupling.md (blob f2e2fd358de9120bcfcc25182712f3eadc12c3b9)
- docs/normalization/Main-Theorem-AC0-CSP.tex (blob bd226e2d0f630c1000db106df3a001632c3f6883)
- docs/normalization/TRAP.md (blob 110a99183d0b3c70e1e350931540d685ab38ee40)
- papers/ac0-csp/REFEREE-MAP.md (blob c5658146de6d78909749f4b717369b887d4a9e8d)
- papers/ac0-csp/ac0-csp-separation.tex (blob ff49570d4d272d1d7412d25c1821f03ad8afc78e)
- papers/ac0-csp/example-linear-EDA.md (blob 9078eee031fb6c4c4d53b525f8be22d58e0b3cb8)

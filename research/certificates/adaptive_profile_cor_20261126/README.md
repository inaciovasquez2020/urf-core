# Exact adaptive query profile, local cycle rank, and aggregation audit

Date: 2026-11-26. Base: URF-Core 322d1af0f2338b6b61df25cb342ca377a5441a95; Chronos 8928c36df88c0f4b72b8d23d868318bf6101cdf4. Status: PROVED_ON_PAPER for the theorems below; COMPUTATION_PASS for the recorded finite tests; new Lean formalization of these four results NOT_RUN. Novelty NOT_ESTABLISHED. This is an additive correction; no existing declaration or certificate is changed.

## 1. Exact adaptive coordinate-query decision profile over finite fields

Let U be a proper linear subspace of F_q^m, D=U^perp, r=dim D>0. Let mu be uniform on U, nu uniform on its complement, and lambda uniform on F_q^m. For 0<=k<=m define
j(k)=max_{|S|<=k} dim {w in D : supp(w) subset S}.
An algorithm has input-independent initialization and random seed; its only input-dependent observations are coordinate queries, with at most k queries on every path. With balanced class priors the maximum success probability is

P*(k) = (1 + (1-q^(-j(k)))/(1-q^(-r)))/2.

Proof. Fix a seed. Each leaf of the full query history is a cylinder L fixing coordinates S, |S|<=k. Write j_S=dim(D intersect F_q^S), where vectors on S are extended by zero. The annihilator of the projection of U onto S is precisely that intersection; its image has dimension |S|-j_S. On a feasible cylinder mu(L)=q^(-|S|+j_S), lambda(L)=q^(-|S|); on an infeasible cylinder mu(L)=0. Consequently, on every feasible leaf lambda(L)<=mu(L), and summing the positive differences gives TV(mu_transcript,lambda_transcript)<=1-q^(-j(k)). The exact mixture lambda=q^(-r)mu+(1-q^(-r))nu implies the displayed bound on TV(mu_transcript,nu_transcript). A fixed maximizing S realizes equality, since all feasible leaves then have the same ratio and an optimal decision accepts precisely the feasible patterns. Randomizing over seeds cannot improve the bound; coarsening a transcript cannot improve distinguishability. The balanced-prior decision formula is P*=(1+TV)/2.

For generalized Hamming weights d_i(D), defined as minimum support size of an i-dimensional subcode, j(k)=max({0} union {i:d_i<=k}). Hence the positive-bias threshold is d_1, and zero-error threshold is d_r=|union_{w in D}supp(w)|. A fixed query set is optimal at each worst-case budget; this does not assert optimality for expected-cost, arbitrary distributions or noncoordinate observations. The existing minimum-support parity argument is a special case; general satisfiability classes must not be identified with a single parity cut unless justified.

Additional paper corollary (not included in the executable tests): for prior pi on U and 1-pi on its complement, optimal error at budget k is
min(pi, (1-pi)*(q^(-j(k))-q^(-r))/(1-q^(-r))).
Indeed on feasible leaves nu(L)/mu(L)=(q^(-j_S)-q^(-r))/(1-q^(-r)); multiply the minimum of the weighted likelihoods by mu(L), and sum. Infeasible leaves contribute zero error. A maximizing fixed S again attains the bound.

## 2. Exact overlap bound for cycle-span rank

Let G be finite simple, R a nonnegative integer, B_R(v) induced balls, W_v their F2 cycle spaces embedded in the global edge vector space. Let C=dim(sum_v W_v)=COR_R(G). Put a_e=number of balls containing edge e, M=max({1} union {a_e:e in E(G)}). Then
sum_v dim(W_v) <= M*C, and C <= sum_v dim(W_v).

Proof: choose C pivot coordinates J for which projection onto J is injective on the global sum W, by row reduction on a basis matrix. Restricted to W_v it remains injective, and coordinates outside the ball edge set are zero. Thus dim W_v<=|J intersect E(B_R(v))|. Sum over v to obtain <= sum_{e in J} a_e <= M*C. Subadditivity of dimension gives the reverse upper bound. Since M>=1 this covers R=0 and edgeless or empty graphs, unlike the unguarded quotient by a potentially zero maximum. This compares embedded ranks, not logical type counts or cycle template counts. The same linear-algebra argument works for any finite family of coordinate-supported subspaces over any field.

## 3. Fixed-threshold circuit normalization

For fixed h>=1, THR_h on n Boolean inputs is an OR over all h-subsets of their ANDs, using at most 1+binom(n,h) gates and depth two in the standard unbounded-fan-in model. If h>n the empty disjunction is false; h=0 gives constant true. Replacing every fixed-threshold gate in a polynomial-size constant-depth circuit yields a polynomial-size constant-depth circuit (when fan-in is polynomially bounded by the circuit size/input length). Conversely ordinary AC0 is included. This is a circuit expressiveness result, not a preservation of original graph locality or coordinate-access cost. OR is one unbounded-fan-in gate but has exact deterministic worst-case coordinate-query complexity n (on all-zero input each coordinate must be queried). An unconditional polylogarithmic comparison between those two cost measures is false. The historical bounded-aggregation efficiency conjecture remains underspecified until it fixes a common cost model.

## 4. Control-information coupling

If M0 includes the complete deterministic initial state and all input, the control trace P is a function of M0 and H(P|M0)=0. If M0 is only public initial data and the machine reads n independent private bits, a fixed-address-order read-only execution can branch on each bit and record distinct instruction paths without writing to data memory. Then H(P|M0)=n bits and data-memory writes are zero. This is a counterexample when data writes exclude control updates and reads access private input; indirect addressing is not necessary. For example a family of straight-line programs with one read and a two-path branch that rejoins for each coordinate realizes this trace. If every control-register update is charged or the full input is already in M0 the interpretation differs.

Correct statement: if P is a deterministic function of M0 and the entire read-result transcript R=(R1,...,RT), then H(P|M0)<=H(R|M0)<=sum_t log|R_t alphabet|. The first inequality is the conditional entropy chain rule and the second is subadditivity plus the finite-alphabet bound. Fix/pad the horizon or include termination as part of the observation alphabet. No equivalence to unrestricted TRAP follows.

## 5. Executable receipts

Both Python sources were replayed in the container using Python 3.13.5; stdout matched the existing logs byte-for-byte, exit zero. No Mac run, no new dependency download. Run with assertions enabled, using python3 -B on each adjacent .py file; each has a 90-second timeout. A nonzero exit or timeout is not PASS.

- 711 proper linear subspaces, all ambient dimensions 1..5 over F2, 1..4 over F3, 1..2 over F5. Independent exact decision-tree optimization, 3,845 budget comparisons.
- 4,396 graph-radius cases: every labeled simple graph on 1..5 vertices, R=0..3. GF2 bitset Gaussian elimination on fundamental cycles.
- 4,608 threshold truth-table cases, n=0..8, h=0..n+1.
- Total counted checks: 12,849. No claim of unrestricted proof by enumeration.

| file | SHA256 | Git blob |
|---|---|---|
| urf_adaptive_profile_audit.py | 880af247dd3cb0f54656b46dcb528540d6b967b08c74570dd9b93c7a8e64f9df | 0c3528475bf273d58497af8b46e2aa963862525b |
| urf_adaptive_profile_audit.log | 644845af6a351301603168c3a38f35e5a64c4b9df2b78e2728c8c43f101f7f6c | c770d122575216031ed66821bfddad364b143b8e |
| urf_cor_aggregation_audit.py | 1ea90e4350dda4931017b9d5ed39f4026976040747e9e37119fc1180e52b69ef | 49c1fe70ce1e9ad15ff6f7bb87c2d791f4a9be5d |
| urf_cor_aggregation_audit.log | 29f053d1d37429a15f511f27678741140d2af481940cd5cfc57d7dd9103c70c0 | a1ee33679b19525dbc0da8ece967d6623d61e914 |

## 6. Separate Lean checkpoint

URF-Core PR #612, commit 47468b9725e9013069bd35d3dc23ebc0e72f5b8d, candidate SHA256 798b4a0afa1dd1eba43a15a9f9a3d6f96a399f1251a8ff53e9cac25af5343dec. Exact-head [CI run 45808908908](https://github.com/inaciovasquez2020/urf-core/actions/runs/45808908908), job 139871301119. Inspected logs show Lean 4.27.0 Linux, pinned mathlib a3a10db0e9d66acbebf76c5e6a135066525ac900 checked by workflow, successful dependency build (7899 jobs), and AXIOM_AUDIT := PASS_4_OF_4. The four declarations in URF.Foundation.ObservationAlphabetAudit depend only on propext, Classical.choice, Quot.sound. In particular transcript_mutual_information_le_time_log_card_observation proves I(X;Y_1,...,Y_T)<=T log|Y alphabet| in nats for the actual finite joint-distribution model. This theorem supports the finite observation capacity concept but is not a formalization of Sections 1-4. Mac and production integration remain unverified. The artifact is reported as ID 15112610087; no claim of downloading it.

## Source boundaries

URF-Core: papers/ac0-csp/bounded-aggregation-note.md blob 30b4d8253b9b462f4f8ad8ff1e9c89fef140fe37; docs/normalization/Control-Information-Coupling.md blob f2e2fd358de9120bcfcc25182712f3eadc12c3b9. Chronos: manuscripts/chronos_core/ClauseDualDistanceEntropyDepth.tex blob a77b20ff8898be2537730d7549c3259d2af507c3; docs/oblivion_atom/formal_definitions.md blob a51c3e634a59acffb10f14e3eabf341609f21278. No unrestricted AC0 locality transfer, TRAP, P vs NP, or global Poincare closure is asserted.

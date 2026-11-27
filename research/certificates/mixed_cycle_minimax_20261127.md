# Mixed-cycle neighborhood entropy: exact minimax extension

Status: PROVED (paper argument); COMPUTATION_PASS within the recorded finite bounds; NOT_LEAN_VERIFIED for the extension. Novelty and independent full formal-proof review remain OPEN.

The existing restricted Lean theorem, `URF.EntropyBridge.cyclePartition_radius_minimax_value`, is unchanged. See [source](../../lean/URF/Foundation/CyclePartitionRadiusMinimax.lean) and [certificate](radius_local_cycle_minimax/). At revision `297a633b164fd91dade9e2b47bda6056867e3f59`, its stored axiom audit reports only `propext`, `Classical.choice`, `Quot.sound`. No fresh Lean build is claimed here.

## Statement

Fix integers N >= L >= 3 and r >= 0, and a finite field of cardinality q. Consider disjoint unions of simple cycles with N vertices, each cycle of length at least L. The observation D is the multiset of rooted induced radius-r neighborhoods up to rooted isomorphism. The target I is the Shannon entropy (natural logarithm) of the uniform distribution on the oriented incidence kernel, equal to the number of cycles times log(q). Estimators map D to real numbers; loss is absolute error.

Put T = max(3, 2r+2), A = max(L,T). For a realizable deck let s be the number of short cycles (length < T), and M the number of vertices in long cycles (length >= T). The exact pointwise radius is

    E(D) = max(0, floor(M/A)-1) * log(q)/2.

The exact family minimax is

    E(N,L,r) = max(0, floor(N/A)-1) * log(q)/2.

The formula for all represented cycle families follows by taking L=3. Transfer to a Lean statement over arbitrary finite simple 2-regular graphs requires a formal cycle-component classification and invariance under graph isomorphism; that transfer is not yet verified.

## Proof

A cycle of length t < T contributes t copies of its entire rooted cycle; a cycle of length t >= T contributes t copies of the centered rooted path on 2r+1 vertices. The latter follows by modular offsets -r,...,r; the cutoff excludes adjacency between the endpoints and excludes repeated vertices. The r=0 case is a single vertex. Short rooted cycles of different lengths have distinct vertex cardinalities, and no cycle is isomorphic to a path. Hence D determines the multiplicities of short cycles by dividing their rooted entry counts by their lengths, and determines M by counting path entries.

Each long component has length >= A. If M=0, the cycle count is exactly s. Otherwise realizability implies M>=A. Every integer j from 1 through m=floor(M/A) occurs as the number of long components: take j-1 cycles of length A and one of length M-(j-1)A. The short components are unchanged, and every such graph has the same deck. Conversely jA<=M bounds the possible counts.

The signed boundary on each oriented cycle has one-dimensional kernel: vanishing boundary says adjacent edge coefficients are equal, after orienting each edge consistently. This holds in every characteristic. Taking direct sums gives entropy (s+j) log(q). The endpoints of the consistent target interval are (s+1)log(q) and (s+m)log(q). The triangle inequality forces worst-case error at least half their difference. The estimator s log(q)+(m+1)log(q)/2 attains that bound. When M=0, use s log(q) exactly. This proves the deck formula, including the zero-error cases.

The pointwise radius is monotone in M, and M<=N. If N>=A, the all-long deck M=N is realized by a single N-cycle and by the maximum-count partition; it attains the upper bound. If N<A, since N>=L, every component is short and every realizable deck has zero error. This proves the family formula without requiring L>=2r+2.

## Sharpness and correction of estimator

For r=1, L=3, N=6, the only unordered partitions are [6] and [3,3]. Their decks differ (six rooted paths versus six rooted triangles); their cycle counts can therefore be recovered exactly. The old restricted formula cannot be extrapolated to this regime. At r=1, L=4, N=8, [8] and [4,4] have identical decks and entropy gap log(q). This shows the cutoff is sharp as a uniform sufficient condition for deck constancy; it is not necessary for every individual parameter triple.

For the original long-cycle theorem with m=floor(N/L), the attaining constant estimate is (m+1)log(q)/2, NOT (m-1)log(q)/2. The latter is the minimax error, not the estimate. The merged theorem is not changed by this expository correction.

## Evidence and limitations

Source inspection at the pinned revision confirms: `simpleGraphIncidence` has entries -1 at the initial vertex and +1 at the terminal vertex; `finiteEntropy` sums `-(p * Real.log p)` with zero-safe terms; the rooted setoid requires a graph isomorphism preserving roots; balls are induced on reachable vertices at distance <= r; the observation is a multiset. The existing deck-constancy theorem is `admissibleCycleObservation_eq`. No additional legacy axioms are required by the recorded restricted theorem audit.

A bounded independent Python/NetworkX check is included in `mixed_cycle_minimax_20261127/`. It computes actual rooted induced balls with BFS and rooted isomorphism, caches component decks, constructs signed incidence matrices and checks nullities over GF(2) and GF(3), and compares exact rational errors normalized by log(q). It checks every unordered cycle partition of N=3..24, every r=0..floor(N/2), and every L=3..N. The receipt identifies software versions and counts. The guard exits as INCOMPLETE, never PASS.

The supplied external analysis (Claude) independently derived the formulas and reported zero mismatches in its own bounded experiment; it did not inspect all source dependencies or execute Lean. That report is corroboration, not independent kernel verification. The proof is a specialization of classical local indistinguishability and optimal recovery; no priority claim is made. A systematic literature review remains outstanding.

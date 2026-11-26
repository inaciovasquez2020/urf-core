# Corrected implication-chain example

The unseeded chain x1 -> x2 -> ... -> xn has at least the all-zero and all-one satisfying assignments and no initial unit clause. Add x1=1. Count time zero as the initial unit assignment. With synchronous unit propagation using only assignments known at round start, exactly the first min(n,t+1) variables are forced after t rounds, by induction on the newly forced successor. Completion occurs after n-1 rounds. This is a bound for that algorithm, not every solver or SAT decision.

For the distinct distributed output model, initialize only the first vertex with an arbitrary seed bit, require every vertex to output it, and allow only synchronous nearest-neighbor updates. The last vertex cannot depend on the seed before n-1 rounds; forwarding attains the bound. See [erratum](../../docs/math/AC0_CSP_NORMALIZATION_ERRATUM_2026_11_26.md).

# AC0-local CSP separation — corrected status

**Universal separation: OPEN.** See [AC0 mathematical erratum](../math/AC0_CSP_NORMALIZATION_ERRATUM_2026_11_26.md). Historical statements remain available at the source blobs listed there.

The historical assertion EDA_A(F) = Θ(n) for every AC0-local solver and every frozen instance is not established. B** is unproved; a lower bound alone also cannot supply a universal upper bound. Fix the cost, frozen-instance class, solver access and success/output semantics before making a transfer.

**Restricted distributed theorem (paper proof):** on an n-vertex path, initialize only the first vertex with an arbitrary bit and all other data independently of it. Synchronous radius-one updates depend only on previous own/neighbor states; every vertex must output the seed bit, with no global readout or input-dependent auxiliary initialization. At round t each state depends only on its radius-t initial neighborhood, by induction. For t<n-1 the last vertex cannot distinguish the two seeds. Broadcasting attains n-1 rounds. This is an exact minimum-round result for that model, not a SAT decision or arbitrary EntropyDepth lower bound.

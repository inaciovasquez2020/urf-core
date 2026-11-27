# F10 Psychology: finite observational identifiability

## Status

- **Abstract theorem:** PROVED by elementary finite/set-theoretic argument (not a novelty claim).
- **Finite certificate:** COMPUTATION_PASS for all 64 single-measurement and 512 two-measurement binary three-state cases. Four local test functions passed under Python 3.
- **Repository CI:** require an exact-HEAD green check before promotion.
- **Psychological interpretation and predictive validity:** OPEN.
- **Clinical efficacy or diagnostic use:** NOT CLAIMED.

## Formal statement

Let X be a set of latent states, O : X -> Y an observation map, and T : X -> Z a property of interest. There exists a decoder D : Y -> Z satisfying T = D ∘ O precisely when

    ∀x,x' ∈ X, O(x) = O(x') ⇒ T(x) = T(x').

The forward implication follows by substitution into D. Conversely, assign D(y) the common T-value of states in the fiber O⁻¹(y) whenever that fiber is nonempty; give other outputs an arbitrary value of Z. If Z is empty, handle the degenerate case separately: for nonempty X no map T exists, and for empty X the decoder Y -> Z exists only if Y is empty. For the finite nonempty binary benchmark below, this caveat never occurs.

For a second measurement I : X -> W (including a controlled intervention outcome), define the joint observation J(x) = (O(x), I(x)). Recoverability from J holds if and only if T is constant on J-fibers. Adding measurements cannot destroy recoverability, but can fail to resolve collisions.

## Concrete three-state witness

Let X = {0,1,2}, O = (0,0,1), and T = (0,1,1). States 0 and 1 have the same initial observation but different targets, so there is no initial decoder.

- Resolving measurement: I = (0,1,0) splits states 0 and 1; the target is then reconstructible.
- Non-resolving measurement: I = (1,1,0) leaves states 0 and 1 indistinguishable; the target remains unrecoverable.

These are toy binary labels, not measured psychiatric variables.

## Reproduction

    python3 -m pytest -q tests/test_f10_observational_identifiability.py

The test code independently enumerates all possible binary decoders and checks agreement with the fiber criterion. The space is 2^3 observation maps times 2^3 target maps = 64 cases; with an additional binary measurement it is 2^3 × 2^3 × 2^3 = 512 cases. It also checks monotonicity and both explicit witnesses.

## Open acceptance boundary

No human cognitive data, out-of-task test set, held-out population, latent-state identification protocol, causal identification result, or comparison against psychological baselines is included. This packet does not satisfy the full F10 field acceptance criterion or validate a clinical claim. The next substantive obligation is to specify measured observations and a falsifiable held-out predictive target, then show an advantage over a declared baseline.

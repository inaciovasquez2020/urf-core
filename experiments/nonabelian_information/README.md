# S3 relative-gauge information loss — exact finite certificate

**Scope:** Nonabelian finite-loop observation model. **Novelty:** NOT_ESTABLISHED. **Lean:** NOT_RUN. **Physical fifth-dimensional necessity:** OPEN.

## Objects and observation model

Fix k≥1 based fundamental loops in a connected graph with S3-valued edge transports. A spanning-tree gauge leaves a tuple `x ∈ S3^k`; residual global gauge acts by **one simultaneous conjugation**. The global state space is `X = S3^k/S3`. The observer sees only the conjugacy class of each component independently, with **no shared root gauge or overlap transition functions**: `O : X → (S3/conjugacy)^k`.

This model is different from the binary finite-cycle path-window model in Chronos and the finite-field linear quotient in urf-core's cross-domain-transfer PR #592. In particular, no vector-space dimension formula is applied to nonabelian S3.

## General exact information law (finite surjective observation map)

Under the **uniform prior on global gauge classes** X, let `m_y = |O^{-1}(y)|`, `N = |X|`, and `M = |O(X)|`. All fibers are nonempty. The observer obtains `y` with probability `m_y/N`; its posterior is uniform within that fiber. Thus:

```text
H(X | Y) = (1/N) Σ_y m_y log2(m_y)
P_optimal_exact_full_class = M/N
```

The latter is the best total success probability for either deterministic or randomized decoders. Both statements follow by conditioning on each fiber; no approximation or independence assumption about the observed conjugacy classes is used.

By Burnside's lemma and the centralizers of S3 (one size-6 element, two size-3 elements, three size-2 elements),

```text
N(k) = (6^k + 2*3^k + 3*2^k)/6
M(k) = 3^k.
```

Every tuple of S3 conjugacy classes has a representative, so M=3^k. Unlike the finite-field case, the fiber sizes are generally unequal. Therefore **conditional entropy is not generally log2(N/M)**.

## Exhaustive finite receipts

Run `python3 -B experiments/nonabelian_information/s3_information_fibers.py`; Python standard library only. The script exhaustively enumerates all 6^k tuples and their global conjugation orbits, counts every local observation fiber, independently checks the total against Burnside's formula and supplies an explicit collision.

| k | Global classes N | Observations M | Exact optimal success | Fiber size : frequency |
|---|---:|---:|---:|---|
| 1 | 3 | 3 | 1 | 1:3 |
| 2 | 11 | 9 | 9/11 | 1:7, 2:2 |
| 3 | 49 | 27 | 27/49 | 1:13, 2:9, 3:3, 4:1, 5:1 |
| 4 | 251 | 81 | 81/251 | 1:21, 2:24, 3:12, 4:8, 5:4, 6:6, 8:1, 9:4, 14:1 |

Complete assignment count: 6+36+216+1296 = **1554**. The Shannon entropy is evaluated numerically from *exact integer fiber counts*, not claimed to be exact as a decimal.

The explicit collision compares `((12),(12))` with `((12),(23))`. Their individual conjugacy classes agree, but simultaneous conjugation cannot change whether the two components are equal.

## Assumptions and limitations

- Uniformity is over **global gauge classes**, not raw transport assignments; these measures differ because stabilizers vary. A different prior changes the success probability and entropy.
- Only independent local conjugacy classes are supplied. Shared gauge or transition-function data may restore global reconstruction.
- The statement is about a specified k-loop quotient, not automatically about induced graph balls or physical measurements.
- Finite enumeration for k≤4 is computational evidence; the formulas for N(k), M(k), and finite-map decoding follow analytically.
- No 5D physics, chronology, Poincaré, complexity lower bound, new theorem novelty, or Lean-verified graph representation is claimed.

## Provenance and promotion gate

The preceding S3 orbit-counting model is also under review in Chronos PR #1357. This URF Core experiment adds **nonuniform observation-fiber accounting and exact decoding probabilities**, not a replacement for that PR. Keep the branches and historical artifacts intact. Promote only after exact-HEAD CI, source/diff inspection, and appropriate mathematical scope review.

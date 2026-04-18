# URF Critical Quartet

The following four repositories are designated URF-critical.

1. `urf-core`
2. `chronos-urf-rr`
3. `scientific-infrastructure`
4. `urf-verifier`

## Criterion

A repository is URF-critical iff failure or drift in that repository would break at least one of:
- canonical definitions
- executable closure anchor
- provenance / reproducibility layer
- authoritative verification

## Lock

No other repository is classified as `critical: true`.

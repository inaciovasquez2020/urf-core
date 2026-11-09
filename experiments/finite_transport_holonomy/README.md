# Finite transport and holonomy: connections 001–004

Status: **experimental, exact finite computation**. No Lean compilation, physical fifth-dimension derivation, or independent novelty review is claimed.

## Source artifacts and scope

1. `urf_finite_transport_bridge_001.py`: Z/12 triangular-cycle gauge invariance; filled-face flatness; six-triangle annulus flat on faces but with nonzero loop holonomy; parity collision.
2. `urf_holonomy_noise_bridge_002.py`: three-edge cycle nearest-class decoding with exact rational errors, including a sharp midpoint counterexample. Under the stated *real lifted edge measurements* and integrally quantized total holonomy assumption, the sufficient threshold is `epsilon < 1/(2m)`. This is not a theorem for arbitrary real-valued holonomy or independently rounded edges.
3. `urf_multicycle_bridge_003.py`: three-path theta graph, 144 Z/12 holonomy signatures, linear relation `h13 = h12+h23 (mod 12)`; noise-grid decoder check; one-coordinate corruption ambiguity. Sufficient *path-measurement* error threshold `epsilon < 1/4`; distinct from the direct signature-coordinate error bound.
4. `urf_local_global_bridge_004.py`: C_n local-gauge indistinguishability with globally distinct holonomy; radius-r balls are proper forests for `n > 2r+1`. This assumes observers see gauge classes of *restricted* connections, not raw global-gauge edge labels or globally coordinated gauge choices.

## General algebraic facts (not novel theorems)

For finite connected graph G and abelian group A, gauge-equivalence classes of A-valued edge transports are classified by H^1(G; A). Flat transports over a 2-complex are H^1(K; A). Every tree connection is gauge-trivial; an unfilled cycle need not be. For a finite allowed signature set S with minimum distance delta, nearest-codeword decoding is unique under induced error strictly below delta/2. The cycle-matrix row-L1 bound supplies one sufficient edge-noise certificate; it need not be optimal for every C or error model.

The k-cycle bounded-radius obstruction can be constructed by joining k sufficiently long cycles by bridges (maximum degree can be kept <=3). Every radius-r ball is acyclic if the graph has girth > 2r+1; first cohomology has dimension k over F2. The phenomenon is standard cohomology/locality, not novel physical evidence.

## Reproduce

At the directory containing these four scripts:

```sh
for f in urf_*bridge_*.py; do PYTHONDONTWRITEBYTECODE=1 python3 "$f" || exit 1; done
shasum -a 256 urf_*bridge_*.py
```

Expected summary (current source):
- 001: 2,985,984 gauge checks; 12 unfilled holonomy classes; 6 flat annulus faces.
- 002: for delta 1/7: 324 unique correct; delta 1/6: 300 unique, 24 ties; delta 1/5: 300 unique, 24 wrong.
- 003: 144 signatures; 3,888 sampled rational noise-grid checks; min L∞ separation 1, L1 separation 2.
- 004: 85,524 local-gauge checks; 828 global inequivalence comparisons; 32 negative controls.

## Research boundaries

- `COMPUTATION_PASS`: current scripts executed in an isolated Python environment on 2026-11-09.
- `LEAN_VERIFIED`: NOT_RUN.
- `CHRONOS_R1_R2_R3`: OPEN and unaffected.
- `POINCARE_GLOBAL_JIID`: OPEN and unaffected.
- `FIFTH_DIMENSION_NECESSITY`: OPEN; a 4D gauge connection can encode nontrivial holonomy.
- `NOVELTY`: NOT_ESTABLISHED.

These are candidate interfaces for URF finite-local/global certificates. Do not import them into canonical theorem claims without declaration-level review and a matching proof audit.

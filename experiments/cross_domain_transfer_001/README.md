# URF Cross-Domain Transfer 001 — finite holonomy to locality and information
Status: RESEARCH CHECKPOINT; draft, no theorem promotion.

This directory records a self-contained mathematical argument and finite evidence relating global gauge classes on finite graphs to independently gauge-quotiented local observations. The exact observation model matters: no global synchronization of local gauges or transition functions is supplied.

## Mathematical statement

Let (G) be a finite loopless graph, (p) prime, (Q(G)=\mathbb F_p^E/\mathrm{im}(\partial^T)), and (Z_1(G;\mathbb F_p)=\ker\partial). For chosen local subgraphs (H_i\), set (W\subseteq Z_1(G;\mathbb F_p)) to the span of the embedded local cycle spaces. The local quotient restriction (L:Q(G)\to\prod_iQ(H_i)) satisfies:

```text
dim ker L = dim Z_1(G; F_p) - dim W
```

With a uniform prior on *global gauge classes* and deterministic observations (Y=L(X)), linear algebra yields the exact Shannon entropy and optimal pointwise decoding probability:

```text
H(X | Y) = (dim Z_1(G; F_p) - dim W) log_2(p)
P(best correct global class | Y=y) = p^(-(dim Z_1 - dim W))
```

The constructive proof extends a basis of (W) to the global cycle space, takes dual edge cochains, and integrates local gauge potentials along spanning forests. The cycle (C_n) has a sharp full-observation radius of `floor(n/2)` for induced radius-(r) balls with independent local gauges.

These are instances of established finite-dimensional linear algebra, graph homology, and information theory. **NOVELTY := NOT_ESTABLISHED**.

## Evidence and audit boundary

- **PROVED (paper argument, independent review pending):** finite graph cycle-span/annihilator identity and constructive witnesses, scoped to the exact observation model.
- **COMPUTATION_PASS:** three independent exact finite verifiers with source-bound receipts (original transfer, cycle-span comparison, constructive hidden-holonomy witnesses). Finite evidence is not an unrestricted proof.
- **LEAN_VERIFIED (Mac-reported):** four **abstract** observation-factorization/collision declarations in Lean 4.29.0. User-provided compiler output and axiom audit show only `propext`, `Classical.choice`, `Quot.sound` where needed; two declarations require no axioms. This does not verify the graph-specific transfer.
- **OPEN:** full graph gauge quotient, induced subgraph restriction compatibility, perfect cycle pairing, kernel-dimension identity and entropy transfer *in Lean*.
- **NOT_RUN:** actual experimental URF-AI toolkit integration; draft Chronos PR #1338 head `b0fd6ef97cf0b73658ad7067d0272084c2d60622` was not cached in six checked Mac checkouts.
- **DO NOT CLAIM:** Poincaré, global JIID, P versus NP, superpolynomial complexity lower bounds, fifth-dimensional necessity, or unified physical theory.

The README is a scope ledger, not an independent mathematical review. No project-specific axiom, `sorry`, `admit`, `opaque`, or `native_decide` is permitted in future promoted Lean proofs. Retain this PR as **draft** until exact-source CI, declaration-level audit, and independent mathematical review.

## Source artifacts

- `proofs/`: theorem, cycle-span, and constructive proof notes.
- `lean/`: isolated candidate formalization of the **abstract** factorization lemmas, not integrated with URF Core's older toolchain.
- `verification/`: bounded exact Python checks; no external packages required.
- `receipts/`: exact JSON outputs; verify source and receipt SHA-256 before relying on recorded results.

The saved complete source package was checked for internal SHA-256 consistency before PR staging. Do not replace these exact artifacts with generated approximations.

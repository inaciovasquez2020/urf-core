# H1 fixed-FO^k finite replay — provenance and exact scope

Date: 2026-11-24. Research-only companion to `URF_H1_FIXED_FOK_BOUNDARY_20261124.md`.

## File integrity

All five archived source-package files were uploaded as **exact UTF-8 file bytes**: their verified Git blob object IDs match the archived local files:

| Path (in this directory) | Git blob |
|---|---|
| `URF_H1_FIXED_FOK_BOUNDARY_20261124.md` | `5a9cf91642b250a1f0ce4318d7a8f74eef84e2b7` |
| `verify_complete_graph_fo_k.py` | `679369abf6208f966b744023d8e79ea8a4827290` |
| `verify_fo_k_direct_crosscheck.py` | `2cc90a3131fa0cd3b6ac1fc0c0c154e4450a76f9` |
| `fo_k_replay_receipt_20261124.txt` | `c6b93622604a4ea12f5297e325d9414ed7e3f6b4` |
| `fo_k_direct_crosscheck_receipt_20261124.txt` | `4a4fd92ec296ffbd5d4ff3ca014d31762bcc9864` |

The original package's SHA-256 values are listed in the mathematical note. The two original receipts are preserved verbatim, including all original formatting.

## Independently replayed in the assistant Linux container

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B verify_complete_graph_fo_k.py --max-k 6 --seconds 30 --max-states 20000
PYTHONDONTWRITEBYTECODE=1 python3 -B verify_fo_k_direct_crosscheck.py
```

Both processes returned exit code 0. The canonical symmetry-reduced checker passed every positive `K_k/K_{k+1}` case `k=1..6` and every negative `K_{k-1}/K_k` case `k=2..6`. The independent raw-vertex pair-game passed positives `k=1..3` and negatives `k=2..3`.

**One cosmetic receipt difference:** the canonical checker prints `'seconds': 30.0` in the new execution, where the original archived receipt printed `'seconds': 30`. The command-line parser stores the field as a Python float. After disregarding this *single display-format difference*, every remaining output line matches the original receipt exactly. The independent raw-vertex cross-check receipt matches byte-for-byte. Do **not** characterize the first raw execution log as byte-identical to its original receipt.

**Status:** `COMPUTATION_PASS`, finite scope only. `LEAN := NOT_RUN` for this theorem; Mac-specific execution `NOT_RUN` for these new files. The paper theorem is classical; no original novelty claimed. Timeout or memory guard exhaustion is `INCOMPLETE`, never `PASS`.

**Safety/integration:** No production Lean modification, repository root-import modification, proof-promotion, or merge. The FO^k mathematical note is a logical expressiveness boundary, not a refutation of counting-logic/WL schemes, fixed-degree variants, or a settled proof of scientific H1.

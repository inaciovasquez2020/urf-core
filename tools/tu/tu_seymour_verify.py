#!/usr/bin/env python3
# tu_seymour_verify.py
# Minimal deterministic verifier for Seymour-style TU certificates.
# Scope: verifies (i) submatrix reconstruction, (ii) 1/2/3-sum structural equalities,
# (iii) base-case witnesses: network incidence (row=vertex, col=edge), R10 normalization.

from __future__ import annotations
import json
import sys
from dataclasses import dataclass
from typing import List, Dict, Any, Tuple, Set, Optional


def die(msg: str) -> None:
    raise SystemExit(f"VERIFY_FAIL: {msg}")


def load_json(path: str) -> Any:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def mat_from_flat(m: int, n: int, entries: List[int]) -> List[List[int]]:
    if len(entries) != m * n:
        die(f"matrix entries length {len(entries)} != m*n {m*n}")
    A = []
    k = 0
    for i in range(m):
        row = []
        for j in range(n):
            v = entries[k]
            if v not in (-1, 0, 1):
                die(f"matrix entry not in {{-1,0,1}} at flat index {k}: {v}")
            row.append(v)
            k += 1
        A.append(row)
    return A


def submatrix(A: List[List[int]], rows: List[int], cols: List[int]) -> List[List[int]]:
    m = len(A)
    n = len(A[0]) if m else 0
    for r in rows:
        if r < 0 or r >= m:
            die(f"row index out of range: {r}")
    for c in cols:
        if c < 0 or c >= n:
            die(f"col index out of range: {c}")
    return [[A[r][c] for c in cols] for r in rows]


def eq_matrix(X: List[List[int]], Y: List[List[int]]) -> bool:
    if len(X) != len(Y):
        return False
    if len(X) == 0:
        return True
    if len(X[0]) != len(Y[0]):
        return False
    for i in range(len(X)):
        for j in range(len(X[0])):
            if X[i][j] != Y[i][j]:
                return False
    return True


def zeros_like(m: int, n: int) -> List[List[int]]:
    return [[0 for _ in range(n)] for _ in range(m)]


def block_diag(A: List[List[int]], B: List[List[int]]) -> List[List[int]]:
    m1, n1 = len(A), (len(A[0]) if A else 0)
    m2, n2 = len(B), (len(B[0]) if B else 0)
    Z12 = zeros_like(m1, n2)
    Z21 = zeros_like(m2, n1)
    top = [A[i] + Z12[i] for i in range(m1)]
    bot = [Z21[i] + B[i] for i in range(m2)]
    return top + bot


def extract_rows_cols(node: Dict[str, Any]) -> Tuple[List[int], List[int]]:
    if "A" not in node:
        die("node missing A (rows/cols indices)")
    rows = node["A"]["rows"]
    cols = node["A"]["cols"]
    if not isinstance(rows, list) or not isinstance(cols, list):
        die("node.A.rows/cols must be lists")
    return rows, cols


def verify_network_incidence(A: List[List[int]], wit: Dict[str, Any]) -> None:
    V = wit["V"]
    E = wit["E"]
    tail = wit["tail"]
    head = wit["head"]
    row_to_vertex = wit["row_to_vertex"]
    col_to_edge = wit["col_to_edge"]
    m = len(A)
    n = len(A[0]) if m else 0
    if len(row_to_vertex) != m:
        die("network_witness.row_to_vertex length mismatch")
    if len(col_to_edge) != n:
        die("network_witness.col_to_edge length mismatch")
    if len(tail) != E or len(head) != E:
        die("network_witness tail/head length mismatch")
    for j in range(n):
        e = col_to_edge[j]
        if e < 0 or e >= E:
            die(f"col_to_edge[{j}] out of range: {e}")
        t = tail[e]
        h = head[e]
        seen_pos = []
        seen_neg = []
        for i in range(m):
            v = row_to_vertex[i]
            if v < 0 or v >= V:
                die(f"row_to_vertex[{i}] out of range: {v}")
            a = A[i][j]
            if a == 1:
                seen_pos.append(v)
            elif a == -1:
                seen_neg.append(v)
            elif a != 0:
                die("network base case: non {-1,0,1} entry")
        if len(seen_pos) != 1 or len(seen_neg) != 1:
            die(f"network base case: column {j} does not have exactly one +1 and one -1")
        if not ((seen_neg[0] == t and seen_pos[0] == h) or (seen_neg[0] == h and seen_pos[0] == t)):
            die(f"network base case: column {j} signs do not match tail/head vertices")


def apply_signed_perm_matrix(A: List[List[int]], perm_rows: List[int], perm_cols: List[int],
                             sign_rows: List[int], sign_cols: List[int]) -> List[List[int]]:
    m = len(A)
    n = len(A[0]) if m else 0
    if len(perm_rows) != m or len(sign_rows) != m:
        die("R10 witness row perm/sign length mismatch")
    if len(perm_cols) != n or len(sign_cols) != n:
        die("R10 witness col perm/sign length mismatch")
    B = [[0 for _ in range(n)] for _ in range(m)]
    for i in range(m):
        pi = perm_rows[i]
        if pi < 0 or pi >= m:
            die("R10 perm_rows out of range")
        sr = sign_rows[i]
        if sr not in (-1, 1):
            die("R10 sign_rows not in {-1,1}")
        for j in range(n):
            pj = perm_cols[j]
            if pj < 0 or pj >= n:
                die("R10 perm_cols out of range")
            sc = sign_cols[j]
            if sc not in (-1, 1):
                die("R10 sign_cols not in {-1,1}")
            B[i][j] = sr * A[pi][pj] * sc
    return B


def is_R10_canonical(A: List[List[int]]) -> bool:
    m = len(A)
    n = len(A[0]) if m else 0
    if m != 10 or n != 10:
        return False
    for i in range(10):
        if sum(1 for x in A[i] if x != 0) != 3:
            return False
    for j in range(10):
        if sum(1 for i in range(10) if A[i][j] != 0) != 3:
            return False
    return True


def verify_sum1(parent: List[List[int]], child1: List[List[int]], child2: List[List[int]],
                rows1: List[int], cols1: List[int], rows2: List[int], cols2: List[int],
                parent_rows: List[int], parent_cols: List[int]) -> None:
    if parent_rows != rows1 + rows2:
        die("sum1: parent row list must equal rows1 ++ rows2 (deterministic convention)")
    if parent_cols != cols1 + cols2:
        die("sum1: parent col list must equal cols1 ++ cols2 (deterministic convention)")
    recomposed = block_diag(child1, child2)
    if not eq_matrix(parent, recomposed):
        die("sum1: parent != block_diag(child1, child2)")


def verify_sumk_glue(parent: List[List[int]], child1: List[List[int]], child2: List[List[int]],
                     rows1: List[int], cols1: List[int], rows2: List[int], cols2: List[int],
                     glue_rows: List[int], glue_cols: List[int],
                     parent_rows: List[int], parent_cols: List[int],
                     k: int) -> None:
    if len(glue_rows) != k or len(glue_cols) != k:
        die(f"sum{k}: glue size mismatch")
    Srows1, Srows2 = set(rows1), set(rows2)
    Scols1, Scols2 = set(cols1), set(cols2)
    if set(glue_rows) != (Srows1 & Srows2):
        die(f"sum{k}: row overlap != glue_rows")
    if set(glue_cols) != (Scols1 & Scols2):
        die(f"sum{k}: col overlap != glue_cols")
    if set(parent_rows) != (Srows1 | Srows2):
        die(f"sum{k}: parent rows not union")
    if set(parent_cols) != (Scols1 | Scols2):
        die(f"sum{k}: parent cols not union")

    idx_r = {r: i for i, r in enumerate(parent_rows)}
    idx_c = {c: j for j, c in enumerate(parent_cols)}
    P = zeros_like(len(parent_rows), len(parent_cols))

    for i_r, r in enumerate(rows1):
        for j_c, c in enumerate(cols1):
            P[idx_r[r]][idx_c[c]] = child1[i_r][j_c]

    for i_r, r in enumerate(rows2):
        for j_c, c in enumerate(cols2):
            v = child2[i_r][j_c]
            cur = P[idx_r[r]][idx_c[c]]
            if cur != 0 and v != 0 and cur != v:
                die(f"sum{k}: overlap disagreement at (r={r},c={c}): {cur} vs {v}")
            if cur == 0:
                P[idx_r[r]][idx_c[c]] = v

    if not eq_matrix(parent, P):
        die(f"sum{k}: parent != recomposed union(child1,child2)")


def verify_node(A_full: List[List[int]], node: Dict[str, Any]) -> List[List[int]]:
    kind = node.get("kind")
    if kind not in ("network", "transpose", "R10", "sum1", "sum2", "sum3"):
        die(f"unknown kind: {kind}")

    rows, cols = extract_rows_cols(node)
    parent = submatrix(A_full, rows, cols)

    if kind == "network":
        wit = node.get("network_witness")
        if wit is None:
            die("network node missing network_witness")
        verify_network_incidence(parent, wit)
        return parent

    if kind == "R10":
        wit = node.get("R10_witness")
        if wit is None:
            die("R10 node missing R10_witness")
        B = apply_signed_perm_matrix(
            parent,
            wit["perm_rows"], wit["perm_cols"],
            wit["sign_rows"], wit["sign_cols"]
        )
        if not is_R10_canonical(B):
            die("R10 node: normalized matrix not recognized as canonical R10")
        return parent

    if kind == "transpose":
        ch = node.get("children")
        if not (isinstance(ch, list) and len(ch) == 1):
            die("transpose node must have exactly 1 child")
        child = ch[0]
        child_mat = verify_node(A_full, child)
        crow, ccol = extract_rows_cols(child)
        if rows != ccol or cols != crow:
            die("transpose: index convention violated")
        trans = [list(x) for x in zip(*child_mat)]
        if not eq_matrix(parent, trans):
            die("transpose: parent != child^T")
        return parent

    ch = node.get("children")
    if not (isinstance(ch, list) and len(ch) == 2):
        die(f"{kind} node must have exactly 2 children")
    left, right = ch
    L = verify_node(A_full, left)
    R = verify_node(A_full, right)
    rowsL, colsL = extract_rows_cols(left)
    rowsR, colsR = extract_rows_cols(right)

    if kind == "sum1":
        verify_sum1(parent, L, R, rowsL, colsL, rowsR, colsR, rows, cols)
        return parent

    bd = node.get("sum_boundary")
    if bd is None:
        die(f"{kind} missing sum_boundary")
    glue_rows = bd["glue_rows"]
    glue_cols = bd["glue_cols"]
    if kind == "sum2":
        verify_sumk_glue(parent, L, R, rowsL, colsL, rowsR, colsR, glue_rows, glue_cols, rows, cols, 1)
        return parent
    if kind == "sum3":
        verify_sumk_glue(parent, L, R, rowsL, colsL, rowsR, colsR, glue_rows, glue_cols, rows, cols, 3)
        return parent

    die("unreachable")


def main() -> None:
    if len(sys.argv) != 2:
        die("usage: tu_seymour_verify.py CERT.json")
    cert = load_json(sys.argv[1])
    M = cert.get("matrix", {})
    m = M.get("m")
    n = M.get("n")
    entries = M.get("entries")
    if not isinstance(m, int) or not isinstance(n, int) or not isinstance(entries, list):
        die("certificate.matrix malformed")
    A_full = mat_from_flat(m, n, entries)
    root = cert.get("root")
    if not isinstance(root, dict):
        die("certificate.root missing or not object")
    verify_node(A_full, root)
    print("VERIFY_OK")


if __name__ == "__main__":
    main()

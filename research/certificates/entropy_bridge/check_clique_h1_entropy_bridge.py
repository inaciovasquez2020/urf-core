#!/usr/bin/env python3
"""Exact clique-complex first-homology rank audit.

Enumerate every labeled simple graph with 1..5 vertices, over GF(2), GF(3),
and GF(5), checking ∂1∂2=0 and beta1=dim ker∂1-rank∂2.
Standard library only. This is finite evidence, not a Lean verification.
"""
from itertools import combinations

def modular_rank(rows, prime, ncolumns):
    work = [[x % prime for x in row] for row in rows]
    current = 0
    for col in range(ncolumns):
        pivot = next((i for i in range(current, len(work))
                      if work[i][col]), None)
        if pivot is None:
            continue
        work[current], work[pivot] = work[pivot], work[current]
        inv = pow(work[current][col], -1, prime)
        work[current] = [(x * inv) % prime for x in work[current]]
        for i in range(current + 1, len(work)):
            factor = work[i][col]
            if factor:
                work[i] = [(a - factor * b) % prime
                           for a, b in zip(work[i], work[current])]
        current += 1
        if current == len(work):
            break
    return current

def graph_betti(n, mask, prime):
    possible = list(combinations(range(n), 2))
    edges = [edge for i, edge in enumerate(possible) if mask >> i & 1]
    eset = set(edges)
    triangles = [t for t in combinations(range(n), 3)
                 if all(e in eset for e in combinations(t, 2))]

    d1 = [[-1 if vertex == a else 1 if vertex == b else 0
           for a, b in edges] for vertex in range(n)]
    d2 = [[1 if (a, b) == (t[1], t[2]) else
           -1 if (a, b) == (t[0], t[2]) else
           1 if (a, b) == (t[0], t[1]) else 0
           for t in triangles] for a, b in edges]

    for i in range(n):
        for j in range(len(triangles)):
            assert sum(d1[i][k] * d2[k][j]
                       for k in range(len(edges))) % prime == 0, (
                           "CHAIN_COMPLEX_FAIL", n, mask, prime, i, j)

    rank1 = modular_rank(d1, prime, len(edges))
    rank2 = modular_rank(d2, prime, len(triangles))
    beta = len(edges) - rank1 - rank2
    assert beta >= 0
    return beta

def main():
    counts = {}
    for prime in (2, 3, 5):
        hist = {}
        checked = 0
        for n in range(1, 6):
            for mask in range(1 << (n * (n - 1) // 2)):
                beta = graph_betti(n, mask, prime)
                hist[beta] = hist.get(beta, 0) + 1
                checked += 1
        assert checked == 1099, checked
        assert hist == {0: 909, 1: 180, 2: 10}, hist
        counts[prime] = hist
    print("GRAPHS_PER_FIELD := 1099")
    print("FIELDS := F2,F3,F5")
    print("GRAPH_FIELD_CHECKS := 3297")
    print("BETTI_HISTOGRAM_PER_FIELD := {0:909,1:180,2:10}")
    print("BOUNDARY_COMPOSITION := COMPUTATION_PASS")
    print("FIRST_HOMOLOGY_RANK := COMPUTATION_PASS")
    print("LEAN_VERIFICATION := NOT_RUN")

if __name__ == "__main__":
    main()

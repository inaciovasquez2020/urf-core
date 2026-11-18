#!/usr/bin/env python3
"""Exact GF(2) radius-local comparison on all labeled simple graphs n<=5.

No external packages. No network or filesystem writes. Bounded finite evidence,
NOT a proof of the unrestricted theorem or Lean verification.
"""
from itertools import combinations

def basis(vectors):
    b = {}
    for v in vectors:
        x = v
        while x:
            lead = x.bit_length() - 1
            if lead in b:
                x ^= b[lead]
            else:
                b[lead] = x
                break
    return b

def contained(b, vector):
    x = vector
    while x:
        lead = x.bit_length() - 1
        if lead not in b:
            return False
        x ^= b[lead]
    return True

def connected(edges, subset):
    if not subset:
        return False
    reached = {next(iter(subset))}
    while True:
        nxt = reached | {v for u, v in edges
                         if u in reached and v in subset} | {
                             u for u, v in edges
                             if v in reached and u in subset}
        if nxt == reached:
            return reached == subset
        reached = nxt

def chordal(n, edges):
    for size in range(4, n + 1):
        for items in combinations(range(n), size):
            subset = set(items)
            if all(sum(1 for a, b in edges
                       if (a == v and b in subset) or
                          (b == v and a in subset)) == 2
                   for v in subset) and connected(edges, subset):
                return False
    return True

def check_graph(n, mask):
    edges = [pair for i, pair in
             enumerate(combinations(range(n), 2)) if mask >> i & 1]
    m = len(edges)
    adjacent = {v: set() for v in range(n)}
    for u, v in edges:
        adjacent[u].add(v)
        adjacent[v].add(u)

    cycles = []
    for chain in range(1 << m):
        degree = [0] * n
        for j, (u, v) in enumerate(edges):
            if chain >> j & 1:
                degree[u] ^= 1
                degree[v] ^= 1
        if not any(degree):
            cycles.append(chain)

    short = {
        k: basis(chain for chain in cycles if bin(chain).count('1') <= k)
        for k in range(m + 1)
    }
    radius = {}
    for r in range(3):
        local = []
        for root in range(n):
            ball = {root}
            for _ in range(r):
                ball |= set().union(*(adjacent[v] for v in ball))
            local.extend(chain for chain in cycles
                         if all(not (chain >> i & 1) or
                                (u in ball and v in ball)
                                for i, (u, v) in enumerate(edges)))
        radius[r] = basis(local)
        for k in range(min(m, 2 * r + 1) + 1):
            if not all(contained(radius[r], c)
                       for c in short[k].values()):
                raise AssertionError(("INCLUSION", n, mask, k, r))

    is_chordal = chordal(n, edges)
    if is_chordal:
        k = min(3, m)
        if (len(radius[1]) != len(short[k])
                or not all(contained(radius[1], c)
                           for c in short[k].values())):
            raise AssertionError(("CHORDAL_EQUALITY", n, mask))
    return is_chordal

def main():
    total = 0
    chordal_count = 0
    for n in range(1, 6):
        for mask in range(1 << (n * (n - 1) // 2)):
            chordal_count += check_graph(n, mask)
            total += 1
    assert total == 1099 and chordal_count == 894
    print("LABELED_GRAPHS_TESTED :=", total)
    print("CHORDAL_GRAPHS_TESTED :=", chordal_count)
    print("SUPPORT_TO_RADIUS_INCLUSION := COMPUTATION_PASS")
    print("CHORDAL_EQUALITY := COMPUTATION_PASS")
    print("UNIVERSAL_LEAN_PROOF := NOT_RUN")

if __name__ == "__main__":
    main()

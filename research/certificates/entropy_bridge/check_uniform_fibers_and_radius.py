#!/usr/bin/env python3
"""Exact, bounded checks for URF graph-entropy bridge.
Standard library only. Finite tests are not universal proofs.
Binary linear maps: all F2^n -> F2^m for 1 <= n,m <= 3.
Radius counterexample: C6 with edge-support cutoff 6 and vertex-ball radius 1.
"""
from collections import Counter
from itertools import product

def check_linear_fibers():
    checked = 0
    for n in range(1, 4):
        for m in range(1, 4):
            for rows in product(range(1 << n), repeat=m):
                fibers = Counter(
                    sum((bin(row & x).count("1") % 2) << i
                        for i, row in enumerate(rows))
                    for x in range(1 << n)
                )
                kernel_size = fibers[0]
                assert kernel_size > 0
                assert all(k == kernel_size for k in fibers.values())
                assert len(fibers) * kernel_size == 1 << n
                checked += 1
    assert checked == 682
    return checked

def check_radius_counterexample():
    n = 6
    edges = [(i, (i + 1) % n) for i in range(n)]
    def cycle(bits):
        degree = [0] * n
        for j, (u, v) in enumerate(edges):
            if bits & (1 << j):
                degree[u] ^= 1
                degree[v] ^= 1
        return not any(degree)
    cycles = [bits for bits in range(1 << n) if cycle(bits)]
    assert cycles == [0, (1 << n) - 1]
    for center in range(n):
        ball = {center, (center - 1) % n, (center + 1) % n}
        inside = [
            bits for bits in cycles
            if all(not (bits & (1 << j)) or (u in ball and v in ball)
                   for j, (u, v) in enumerate(edges))
        ]
        assert inside == [0]
    print("C6_GLOBAL_CYCLE_DIMENSION := 1")
    print("SUPPORT_CUTOFF_6_DIMENSION := 1")
    print("RADIUS_1_LOCAL_CYCLE_DIMENSION := 0")
    print("UNRESTRICTED_EQUIVALENCE := REFUTED")

if __name__ == "__main__":
    print("BINARY_LINEAR_MAPS := ", check_linear_fibers(), sep="")
    print("FIBER_CARDINALITY_TEST := COMPUTATION_PASS")
    check_radius_counterexample()

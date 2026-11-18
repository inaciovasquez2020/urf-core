#!/usr/bin/env python3
"""Exact injectivity test of spoke incidence restrictions.

Checks all labeled simple graphs on 1..6 vertices, each vertex center,
and fields F2, F3, F5. Standard library only, no file/network writes.
Theorem is proved mathematically but Lean formalization is NOT_RUN.
"""
from itertools import combinations

def modular_rank(rows, p):
    basis = {}
    for original in rows:
        vector = [x % p for x in original]
        while True:
            pivot = next((j for j, x in enumerate(vector) if x), None)
            if pivot is None:
                break
            if pivot not in basis:
                multiplier = pow(vector[pivot], -1, p)
                basis[pivot] = [(x * multiplier) % p for x in vector]
                break
            factor = vector[pivot]
            vector = [(x - factor * y) % p
                      for x, y in zip(vector, basis[pivot])]
    return len(basis)

def main():
    graph_count = star_count = 0
    for n in range(1, 7):
        pairs = list(combinations(range(n), 2))
        for mask in range(1 << len(pairs)):
            edges = [edge for j, edge in enumerate(pairs) if mask >> j & 1]
            for center in range(n):
                spokes = [edge for edge in edges if center in edge]
                other_vertices = [v for v in range(n) if v != center]
                # Each noncentral incidence row is +1 or -1 at its sole
                # incident spoke column, or zero if no spoke is incident.
                rows = [
                    [(-1 if vertex == a else 1 if vertex == b else 0)
                     for a, b in spokes]
                    for vertex in other_vertices
                ]
                for field in (2, 3, 5):
                    actual_rank = modular_rank(rows, field)
                    assert actual_rank == len(spokes), (
                        n, mask, center, field, actual_rank, len(spokes))
                star_count += 1
            graph_count += 1
    assert graph_count == 33867
    assert star_count == 202013
    print("GRAPHS := ", graph_count, sep="")
    print("VERTEX_STARS := ", star_count, sep="")
    print("FIELD_CHECKS := ", star_count * 3, sep="")
    print("SPOKE_INCIDENCE_INJECTIVITY := COMPUTATION_PASS")
    print("LEAN_VERIFICATION := NOT_RUN")

if __name__ == "__main__":
    main()

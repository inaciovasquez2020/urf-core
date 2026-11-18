#!/usr/bin/env python3
"""Exact local triangle-cycle basis audit over F2, F3 and F5.

All labeled undirected simple graphs with 1..5 vertices, all centers.
No external packages, no downloads, no repository modifications.
Finite computation does not substitute for a universal Lean proof.
"""
from itertools import combinations

def rank(vectors, p):
    pivots = {}
    for original in vectors:
        vec = [x % p for x in original]
        while True:
            lead = next((i for i, x in enumerate(vec) if x), None)
            if lead is None:
                break
            if lead not in pivots:
                inverse = pow(vec[lead], -1, p)
                pivots[lead] = [(x * inverse) % p for x in vec]
                break
            factor = vec[lead]
            vec = [(x - factor * y) % p
                   for x, y in zip(vec, pivots[lead])]
    return len(pivots)

def run():
    graphs = balls = 0
    for n in range(1, 6):
        pairs = list(combinations(range(n), 2))
        for mask in range(1 << len(pairs)):
            edges = [pair for j, pair in enumerate(pairs) if mask >> j & 1]
            adjacent = [set() for _ in range(n)]
            for a, b in edges:
                adjacent[a].add(b)
                adjacent[b].add(a)
            for center in range(n):
                ball = adjacent[center] | {center}
                local_edges = [(a, b) for a, b in edges
                               if a in ball and b in ball]
                rim = [(a, b) for a, b in local_edges
                       if center not in (a, b)]
                edge_index = {e: i for i, e in enumerate(local_edges)}
                triangles = []
                for a, b in rim:
                    vec = [0] * len(local_edges)
                    for x, y in ((a, b), (b, center), (center, a)):
                        edge = (min(x, y), max(x, y))
                        vec[edge_index[edge]] += 1 if x < y else -1
                    triangles.append(vec)
                boundary = [
                    [(-1 if vertex == a else 1 if vertex == b else 0)
                     for a, b in local_edges]
                    for vertex in ball
                ]
                for prime in (2, 3, 5):
                    triangle_rank = rank(triangles, prime)
                    cycle_dimension = len(local_edges) - rank(boundary, prime)
                    assert triangle_rank == cycle_dimension == len(rim), (
                        n, mask, center, prime,
                        triangle_rank, cycle_dimension, len(rim))
                balls += 1
            graphs += 1
    assert graphs == 1099
    assert balls == 5405
    print("GRAPHS := ", graphs, sep="")
    print("BALLS := ", balls, sep="")
    print("FIELD_SPECIFIC_CHECKS := ", balls * 3, sep="")
    print("CONE_BASIS_RANK := COMPUTATION_PASS")
    print("LEAN_VERIFICATION := NOT_RUN")

if __name__ == "__main__":
    run()

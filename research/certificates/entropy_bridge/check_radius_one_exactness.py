#!/usr/bin/env python3
"""Exhaustive exact radius-one cone-cycle rank check.

No third-party dependencies. All labeled simple graphs on 1..6 vertices.
Results independently checked on 2026-11-18: 33867 graphs, 202013 balls.
This is finite computational evidence, not a universal Lean theorem.
"""
from itertools import combinations

def run():
    graphs = balls = 0
    for n in range(1, 7):
        all_edges = list(combinations(range(n), 2))
        for mask in range(1 << len(all_edges)):
            edges = [e for i, e in enumerate(all_edges) if (mask >> i) & 1]
            adj = [set() for _ in range(n)]
            for a, b in edges:
                adj[a].add(b)
                adj[b].add(a)
            for v in range(n):
                ball = adj[v] | {v}
                local_edges = [(a, b) for a, b in edges
                               if a in ball and b in ball]

                seen = set()
                components = 0
                for w in ball:
                    if w in seen:
                        continue
                    components += 1
                    seen.add(w)
                    stack = [w]
                    while stack:
                        x = stack.pop()
                        for u in adj[x] & ball:
                            if u not in seen:
                                seen.add(u)
                                stack.append(u)

                local_cycle_rank = len(local_edges) - len(ball) + components
                center_triangles = sum(1 for a, b in edges
                                       if a in adj[v] and b in adj[v])
                assert local_cycle_rank == center_triangles, (
                    n, mask, v, local_cycle_rank, center_triangles)
                balls += 1
            graphs += 1
    assert graphs == 33867 and balls == 202013
    print("GRAPHS := ", graphs, sep="")
    print("CLOSED_RADIUS_ONE_BALLS := ", balls, sep="")
    print("LOCAL_CYCLE_RANK_EQ_TRIANGLES := COMPUTATION_PASS")
    print("ARBITRARY_FIELD_PROOF := MATHEMATICAL_ARGUMENT")
    print("LEAN_VERIFICATION := NOT_RUN")

if __name__ == "__main__":
    run()
